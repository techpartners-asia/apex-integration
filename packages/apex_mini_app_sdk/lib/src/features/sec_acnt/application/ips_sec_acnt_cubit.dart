import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mini_app_sdk/apex_mini_app_sdk.dart';
import 'package:mini_app_sdk/mini_app_sdk.dart';

class IpsSecAcntCubit extends Cubit<IpsSecAcntState> {
  final InvestmentBootstrapService service;
  final MiniAppPaymentExecutor paymentExecutor;
  final SdkLocalizations l10n;

  IpsSecAcntCubit({
    required this.service,
    required this.paymentExecutor,
    required this.l10n,
  }) : super(const IpsSecAcntState());

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
      final MiniAppPaymentRes paymentRes = await paymentExecutor.execute(
        flow: MiniAppPaymentFlow.secAcntOpening,
        invoiceRequest: CreateInvoiceApiReq(
          amount: payableAmount,
          note: 'sec_acnt_opening_fee',
          isTransaction: false,
        ),
      );

      SecAcntRequestResult? requestResult;
      if (paymentRes.success) {
        if (!requiresOpeningPaymentFlow) {
          requestResult = await service.addSecuritiesAcntReq(personalInfo: personalInfo);
        }
      }

      emit(
        state.copyWith(
          isSubmitting: false,
          requestResult: requestResult,
          paymentRes: paymentRes,
          errorMessage: paymentRes.status == MiniAppPaymentStatus.success ? null : resolvePaymentResultMessage(l10n, paymentRes),
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
