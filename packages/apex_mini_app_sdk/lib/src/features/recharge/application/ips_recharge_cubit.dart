import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:apex_mini_app_sdk/apex_mini_app_sdk.dart';

/// Cubit for IPS account recharge flow.
class IpsRechargeCubit extends Cubit<IpsRechargeState> {
  /// Orders service used to create recharge charge request.
  final OrdersService service;

  /// Portfolio service used to load pricing and refresh balance.
  final PortfolioService? portfolioService;

  /// Bootstrap service used to resolve pricing context when needed.
  final InvestmentBootstrapService? bootstrapService;

  /// Optional pre-resolved portfolio/pricing context.
  final SdkPortfolioContext? pricingContext;

  /// Host-payment executor.
  final MiniAppPaymentExecutor paymentExecutor;

  /// Localizations used for user-facing errors.
  final SdkLocalizations l10n;

  /// Diagnostic logger.
  final MiniAppLogger logger;

  IpsRechargeCubit({
    required this.service,
    this.portfolioService,
    this.bootstrapService,
    this.pricingContext,
    required this.paymentExecutor,
    required this.l10n,
    this.logger = const SilentMiniAppLogger(),
    double unitPrice = 0,
    double serviceFee = 0,
    String currency = 'MNT',
  }) : super(
         IpsRechargeState(
           unitPrice: unitPrice,
           serviceFee: serviceFee,
           currency: currency,
         ),
       );

  /// Loads pack unit price/service fee before allowing submission.
  Future<void> loadPricing() async {
    final PortfolioService? ps = portfolioService;
    if (ps == null || state.hasPricing) return;

    emit(
      state.copyWith(
        isPricingLoading: true,
        errorMessage: null,
      ),
    );

    try {
      final PortfolioOverview overview = await ps.getIpsBalance(
        context: await _resolvePricingContext(),
      );

      final double? packAmount = overview.packAmount;
      if (packAmount == null || packAmount <= 0) {
        emit(
          state.copyWith(
            isPricingLoading: false,
            currency: overview.currency,
            errorMessage: l10n.ipsContractPackPricingUnavailable,
          ),
        );
        return;
      }

      emit(
        state.copyWith(
          isPricingLoading: false,
          unitPrice: overview.packAmount ?? state.unitPrice,
          serviceFee: overview.packFee ?? state.serviceFee,
          currency: overview.currency,
          errorMessage: null,
        ),
      );
    } catch (error, stackTrace) {
      logger.onError(
        'recharge_pricing_load_failed',
        error: error,
        stackTrace: stackTrace,
      );
      emit(
        state.copyWith(
          isPricingLoading: false,
          errorMessage: formatIpsError(error, l10n),
        ),
      );
    }
  }

  /// Updates selected pack quantity from user input.
  void updatePackQty(String value) {
    emit(state.copyWith(packQty: int.tryParse(value.trim()) ?? 0));
  }

  /// Creates recharge request, delegates payment to host, then refreshes balance.
  Future<void> submit() async {
    if (!state.canSubmit) return;

    emit(
      state.copyWith(
        isSubmitting: true,
        paymentRes: null,
        refreshedOverview: null,
        errorMessage: null,
      ),
    );

    try {
      final RechargeReq req = RechargeReq(
        packQty: state.packQty,
        amount: state.totalPayable,
      );
      await service.chargeIpsAcnt(req);

      final paymentRes = await paymentExecutor.execute(
        flow: MiniAppPaymentFlow.ipsRecharge,
        invoiceRequest: CreateInvoiceApiReq(
          amount: req.amount!.toInt(),
          note: 'ips_recharge',
          isTransaction: true,
        ),
      );

      final PortfolioOverview? refreshedOverview =
          await _refreshBalanceAfterSuccess();

      emit(
        state.copyWith(
          isSubmitting: false,
          paymentRes: paymentRes,
          refreshedOverview: refreshedOverview,
          errorMessage: null,
        ),
      );
    } catch (error) {
      emit(
        state.copyWith(
          isSubmitting: false,
          errorMessage: formatIpsError(error, l10n),
        ),
      );
    }
  }

  Future<PortfolioOverview?> _refreshBalanceAfterSuccess() async {
    final PortfolioService? service = portfolioService;
    if (service == null) {
      return null;
    }

    try {
      return await service.getIpsBalance();
    } catch (error, stackTrace) {
      logger.onError(
        'balance_refresh_after_recharge_failed',
        error: error,
        stackTrace: stackTrace,
      );
      return null;
    }
  }

  Future<SdkPortfolioContext?> _resolvePricingContext() async {
    if (pricingContext case final SdkPortfolioContext value) {
      return value;
    }

    final InvestmentBootstrapService? bootstrap = bootstrapService;
    if (bootstrap == null) {
      return null;
    }

    try {
      final AcntBootstrapState state = await bootstrap.getSecAcntListState();
      return const PortfolioContextResolver().resolve(
        bootstrapState: state,
      );
    } catch (error, stackTrace) {
      logger.onError(
        'recharge_pricing_context_load_failed',
        error: error,
        stackTrace: stackTrace,
      );
      return null;
    }
  }
}
