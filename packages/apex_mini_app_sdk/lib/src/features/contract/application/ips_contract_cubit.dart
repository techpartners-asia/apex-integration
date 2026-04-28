import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mini_app_ui/mini_app_ui.dart';
import 'package:mini_app_sdk/mini_app_sdk.dart';

class IpsContractCubit extends Cubit<IpsContractState> {
  static const int _accountLoadAttempts = 5;
  static const Duration _accountLoadDelay = Duration(seconds: 1);

  final ContractService contractService;
  final InvestmentBootstrapService bootstrapService;
  final PortfolioService portfolioService;
  final OrdersService ordersService;
  final MiniAppPaymentExecutor paymentExecutor;
  final ContractPayload payload;
  final SdkLocalizations l10n;
  final MiniAppLogger logger;

  IpsContractCubit({
    required this.contractService,
    required this.bootstrapService,
    required this.portfolioService,
    required this.ordersService,
    required this.paymentExecutor,
    required this.payload,
    required this.l10n,
    this.logger = const SilentMiniAppLogger(),
  }) : super(const IpsContractState());

  Future<void> initialize() async {
    if (state.isInitializing || state.isReady) {
      return;
    }

    emit(state.copyWith(isInitializing: true, errorMessage: null));

    try {
      final ContractRes contractRes =
          state.contractRes ?? await contractService.addBrokerCustContract();
      final AcntBootstrapState bootstrapState = await _waitForIpsAccounts();
      final PortfolioOverview overview = await portfolioService.getIpsBalance(
        context: const PortfolioContextResolver().resolve(
          bootstrapState: bootstrapState,
        ),
      );

      emit(
        state.copyWith(
          isInitializing: false,
          contractRes: contractRes,
          bootstrapState: bootstrapState,
          overview: overview,
          errorMessage: overview.packAmount == null
              ? l10n.ipsContractPackPricingUnavailable
              : null,
        ),
      );
    } catch (error) {
      emit(
        state.copyWith(
          isInitializing: false,
          errorMessage: formatIpsError(error, l10n),
        ),
      );
    }
  }

  Future<AcntBootstrapState> _waitForIpsAccounts() async {
    for (int attempt = 0; attempt < _accountLoadAttempts; attempt += 1) {
      final AcntBootstrapState currentState = await bootstrapService
          .getSecAcntListState(forceRefresh: true);
      if (currentState.hasRequiredIpsAccounts) {
        return currentState;
      }

      if (attempt < _accountLoadAttempts - 1) {
        await Future<void>.delayed(_accountLoadDelay);
      }
    }

    throw StateError(l10n.ipsContractIpsAccountsMissing);
  }

  void appendDigit(int digit) {
    if (digit < 0 || digit > 9 || state.isSubmitting || state.isInitializing) {
      return;
    }

    final String currentValue = state.purchaseQty <= 0
        ? ''
        : state.purchaseQty.toString();
    final String nextValue = '${currentValue == '0' ? '' : currentValue}$digit';
    final int parsed = int.tryParse(nextValue) ?? state.purchaseQty;
    _updatePurchaseQty(parsed);
  }

  void backspaceDigit() {
    if (state.isSubmitting || state.isInitializing) {
      return;
    }

    final String currentValue = state.purchaseQty.toString();
    if (currentValue.isEmpty) {
      return;
    }

    final String nextValue = currentValue.length <= 1
        ? ''
        : currentValue.substring(0, currentValue.length - 1);
    _updatePurchaseQty(int.tryParse(nextValue) ?? 0);
  }

  void _updatePurchaseQty(int value) {
    emit(
      state.copyWith(purchaseQty: value, paymentRes: null, errorMessage: null),
    );
  }

  Future<void> submit() async {
    if (!state.canSubmit) {
      return;
    }

    emit(
      state.copyWith(isSubmitting: true, paymentRes: null, errorMessage: null),
    );

    try {
      final MiniAppPaymentRes paymentRes = await paymentExecutor.execute(
        flow: MiniAppWalletPaymentFlow.ipsRecharge,
        invoiceRequest: CreateInvoiceApiReq(
          amount: state.totalPayable,
          note: 'ips_pack_purchase',
          refId: _buildPurchaseRefId(),
        ),
      );

      if (paymentRes.status != MiniAppPaymentStatus.success) {
        emit(
          state.copyWith(
            isSubmitting: false,
            paymentRes: paymentRes,
            errorMessage: resolvePaymentResultMessage(l10n, paymentRes),
          ),
        );
        return;
      }

      final RechargeReq req = RechargeReq(
        packQty: state.purchaseQty,
        amount: state.totalPayable,
      );
      await ordersService.chargeIpsAcnt(req);
      final PortfolioOverview? refreshedOverview =
          await _refreshBalanceAfterSuccess();

      emit(
        state.copyWith(
          isSubmitting: false,
          overview: refreshedOverview ?? state.overview,
          paymentRes: paymentRes,
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

  String _buildPurchaseRefId() {
    final String? contractId = state.contractRes?.contractId.trim();
    if (contractId != null && contractId.isNotEmpty) {
      return 'ips_pack_purchase_${contractId}_${state.purchaseQty}';
    }

    return 'ips_pack_purchase_${state.purchaseQty}_${DateTime.now().millisecondsSinceEpoch}';
  }

  Future<PortfolioOverview?> _refreshBalanceAfterSuccess() async {
    final AcntBootstrapState? bootstrapState = state.bootstrapState;

    try {
      return await portfolioService.getIpsBalance(
        context: bootstrapState == null
            ? null
            : const PortfolioContextResolver().resolve(
                bootstrapState: bootstrapState,
              ),
      );
    } catch (error, stackTrace) {
      logger.onError(
        'balance_refresh_after_purchase_failed',
        error: error,
        stackTrace: stackTrace,
      );
      return null;
    }
  }
}
