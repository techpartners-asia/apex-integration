import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mini_app_sdk/apex_mini_app_sdk.dart';
import 'package:mini_app_sdk/mini_app_sdk.dart';

class IpsRechargeCubit extends Cubit<IpsRechargeState> {
  final OrdersService service;
  final PortfolioService? portfolioService;
  final InvestmentBootstrapService? bootstrapService;
  final SdkPortfolioContext? pricingContext;
  final MiniAppPaymentExecutor paymentExecutor;
  final SdkLocalizations l10n;
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

  void updatePackQty(String value) {
    emit(state.copyWith(packQty: int.tryParse(value.trim()) ?? 0));
  }

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
          refId: _buildRechargeRefId(req),
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

  String _buildRechargeRefId(RechargeReq req) {
    return 'ips_recharge_${req.packQty}_${DateTime.now().millisecondsSinceEpoch}';
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
