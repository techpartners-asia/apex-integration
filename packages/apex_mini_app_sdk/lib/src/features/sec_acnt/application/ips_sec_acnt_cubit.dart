import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:apex_mini_app_sdk/apex_mini_app_sdk.dart';

/// Cubit for securities-account opening/payment actions.
class IpsSecAcntCubit extends Cubit<IpsSecAcntState> {
  /// Bootstrap service used to submit and refresh securities account state.
  final InvestmentBootstrapService service;

  /// Host-payment executor.
  final MiniAppPaymentExecutor paymentExecutor;

  /// Localizations used for error/payment messages.
  final SdkLocalizations l10n;

  IpsSecAcntCubit({
    required this.service,
    required this.paymentExecutor,
    required this.l10n,
  }) : super(const IpsSecAcntState());

  /// Submits account-opening request, then runs opening-fee payment.
  Future<MiniAppPaymentRes?> submitOpeningPayment({
    required double payableAmount,
    SecAcntPersonalInfoData? personalInfo,
  }) async {
    if (state.isSubmitting) {
      return state.paymentRes;
    }

    emit(
      state.copyWith(isSubmitting: true, paymentRes: null, errorMessage: null),
    );

    try {
      final SecAcntRequestResult requestResult = await service
          .addSecuritiesAcntReq(personalInfo: personalInfo);

      final MiniAppPaymentRes paymentRes = await paymentExecutor.execute(
        flow: MiniAppPaymentFlow.secAcntOpening,
        invoiceRequest: CreateInvoiceApiReq(
          amount: payableAmount,
          note: 'sec_acnt_opening_fee',
          isTransaction: false,
        ),
      );

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
