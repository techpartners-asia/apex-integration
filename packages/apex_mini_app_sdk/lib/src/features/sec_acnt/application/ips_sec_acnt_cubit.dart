import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:apex_mini_app_sdk/apex_mini_app_sdk.dart';

/// Cubit for securities-account opening/payment actions.
class IpsSecAcntCubit extends Cubit<IpsSecAcntState> {
  /// Bootstrap service used to submit and refresh securities account state.
  final InvestmentBootstrapService service;

  /// Host-payment executor.
  final MiniAppPaymentExecutor paymentExecutor;

  /// Payments API used for account opening fee lookup.
  final MiniAppPaymentsRepository paymentsRepository;

  /// Localizations used for error/payment messages.
  final SdkLocalizations l10n;

  IpsSecAcntCubit({
    required this.service,
    required this.paymentExecutor,
    required this.paymentsRepository,
    required this.l10n,
  }) : super(const IpsSecAcntState());

  /// Loads the additional account fee added to the opening commission total.
  Future<void> loadAccountFeesAmount() async {
    if (state.isLoadingAccountFees || state.hasLoadedAccountFees) {
      return;
    }

    emit(
      state.copyWith(
        isLoadingAccountFees: true,
        errorMessage: null,
      ),
    );

    try {
      final double amount = await paymentsRepository.getAccountFeesAmount();
      emit(
        state.copyWith(
          isLoadingAccountFees: false,
          hasLoadedAccountFees: true,
          accountFeesAmount: amount,
        ),
      );
    } catch (error) {
      emit(
        state.copyWith(
          isLoadingAccountFees: false,
          errorMessage: formatIpsError(error, l10n),
        ),
      );
    }
  }

  /// Submits account-opening request when needed, then runs opening-fee payment.
  ///
  /// Skips [InvestmentBootstrapService.addSecuritiesAcntReq] when
  /// [bootstrapState.hasAcnt] is already true (short-flow opening fee only).
  Future<MiniAppPaymentRes?> submitOpeningPayment({
    required double payableAmount,
    SecAcntPersonalInfoData? personalInfo,
    required bool requiresOpeningPaymentFlow,
  }) async {
    if (state.isSubmitting) {
      return state.paymentRes;
    }

    emit(
      state.copyWith(isSubmitting: true, paymentRes: null, errorMessage: null),
    );

    try {
      final double invoiceAmount = state.totalPayableAmount(payableAmount);
      final MiniAppPaymentRes paymentRes = await paymentExecutor.execute(
        flow: MiniAppPaymentFlow.secAcntOpening,
        invoiceRequest: CreateInvoiceApiReq(
          amount: invoiceAmount,
          note: 'sec_acnt_opening_fee',
          isTransaction: false,
        ),
      );

      BackendApiLogger.shared(StaticApiConfig.techInvestXUrl).log(
        level: paymentRes.success ? 'info' : 'warn',
        path: 'sec_acnt/submitOpeningPayment',
        msg: 'sec_acnt_opening_payment_result',
        info: <String, Object?>{
          'status': paymentRes.status.name,
          'success': paymentRes.success,
          'transactionId': paymentRes.transactionId,
          'message': paymentRes.message,
          'failureCode': paymentRes.failure?.code,
          'failureMessage': paymentRes.failure?.message,
          'invoiceId': paymentRes.req.invoiceId,
          'paymentRecordId': paymentRes.req.paymentRecordId,
          'amount': paymentRes.req.amount,
          'flow': paymentRes.req.flow.name,
        },
      );

      SecAcntRequestResult? requestResult;
      if (paymentRes.success) {
        if (!requiresOpeningPaymentFlow) {
          requestResult = await service.addSecuritiesAcntReq(
            personalInfo: personalInfo,
          );
        }
      }

      emit(
        state.copyWith(
          isSubmitting: false,
          requestResult: requestResult,
          paymentRes: paymentRes,
          errorMessage: paymentRes.status == MiniAppPaymentStatus.success
              ? null
              : resolvePaymentResultMessage(l10n, paymentRes),
        ),
      );

      return paymentRes;
    } catch (error) {
      emit(
        state.copyWith(
          isSubmitting: false,
          errorMessage: formatIpsError(error, l10n),
        ),
      );
      return null;
    }
  }

  /// Reloads bootstrap/account state after account-opening actions.
  Future<AcntBootstrapState?> refreshBootstrapState({
    AcntBootstrapState? currentState,
  }) async {
    try {
      final AcntBootstrapState refreshed = await BootstrapStateResolver(
        service: service,
      ).load(forceRefresh: true);

      emit(state.copyWith(errorMessage: null));

      return refreshed;
    } catch (error) {
      emit(state.copyWith(errorMessage: formatIpsError(error, l10n)));

      return null;
    }
  }
}
