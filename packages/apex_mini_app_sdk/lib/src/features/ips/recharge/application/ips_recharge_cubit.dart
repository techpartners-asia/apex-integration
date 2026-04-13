import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mini_app_sdk/l10n/sdk_localizations.dart';
import 'package:mini_app_ui/mini_app_ui.dart';

import '../../../../app/investx_api/req/create_invoice_api_req.dart';
import '../../../../payment/mini_app_wallet_payment_request.dart';
import '../../../../runtime/mini_app_payment_executor.dart';
import '../../shared/domain/services/investment_services.dart';
import '../../shared/presentation/helpers/ips_error_formatter.dart';
import 'ips_recharge_state.dart';

class IpsRechargeCubit extends Cubit<IpsRechargeState> {
  final OrdersService service;
  final PortfolioService? portfolioService;
  final MiniAppPaymentExecutor paymentExecutor;
  final SdkLocalizations l10n;
  final MiniAppLogger logger;

  IpsRechargeCubit({
    required this.service,
    this.portfolioService,
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

    try {
      final PortfolioOverview overview = await ps.getIpsBalance();
      emit(
        state.copyWith(
          unitPrice: overview.packAmount ?? state.unitPrice,
          serviceFee: overview.packFee ?? state.serviceFee,
          currency: overview.currency,
        ),
      );
    } catch (error, stackTrace) {
      logger.onError(
        'recharge_pricing_load_failed',
        error: error,
        stackTrace: stackTrace,
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
        flow: MiniAppWalletPaymentFlow.ipsRecharge,
        invoiceRequest: CreateInvoiceApiReq(
          amount: req.amount!.toInt(),
          note: 'ips_recharge',
          refId: _buildRechargeRefId(req),
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
}
