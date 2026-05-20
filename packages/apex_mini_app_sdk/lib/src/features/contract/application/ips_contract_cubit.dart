import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:apex_mini_app_sdk/apex_mini_app_sdk.dart';

/// Cubit for broker contract setup and investment-pack purchase.
class IpsContractCubit extends Cubit<IpsContractState> {
  static const int _accountLoadAttempts = 5;
  static const Duration _accountLoadDelay = Duration(seconds: 1);

  /// Contract API service.
  final ContractService contractService;

  /// Bootstrap service used to wait for IPS account availability.
  final InvestmentBootstrapService bootstrapService;

  /// Portfolio service used for pack pricing and balance refresh.
  final PortfolioService portfolioService;

  /// Orders service used to charge IPS account after payment success.
  final OrdersService ordersService;

  /// Host payment executor.
  final MiniAppPaymentExecutor paymentExecutor;

  /// Contract payload passed from previous flow step.
  final ContractPayload payload;

  /// Localizations used for user-facing errors.
  final SdkLocalizations l10n;

  /// Diagnostic logger.
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

  /// Creates contract, waits for accounts, and loads purchase pricing.
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

  /// Appends a quantity digit from the custom keypad.
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

  /// Removes the last quantity digit from the custom keypad.
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

  /// Pays for packs, creates recharge order, and refreshes balance.
  Future<void> submit() async {
    if (!state.canSubmit) {
      return;
    }

    emit(
      state.copyWith(isSubmitting: true, paymentRes: null, errorMessage: null),
    );

    try {
      final MiniAppPaymentRes paymentRes = await paymentExecutor.execute(
        flow: MiniAppPaymentFlow.ipsRecharge,
        invoiceRequest: CreateInvoiceApiReq(
          amount: state.totalPayable,
          note: 'ips_pack_purchase',
          isTransaction: true,
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
