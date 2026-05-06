import 'package:flutter_bloc/flutter_bloc.dart';
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
    required String fallbackRefId,
  }) async {
    if (state.isSubmitting) {
      return state.paymentRes;
    }

    emit(
      state.copyWith(isSubmitting: true, paymentRes: null, errorMessage: null),
    );

    try {
      SecAcntRequestResult? requestResult;
      if (!requiresOpeningPaymentFlow) {
        requestResult = await service.addSecuritiesAcntReq(
          personalInfo: personalInfo,
        );
      }

      final MiniAppPaymentRes paymentRes = await paymentExecutor.execute(
        flow: MiniAppWalletPaymentFlow.secAcntOpening,
        invoiceRequest: CreateInvoiceApiReq(
          amount: payableAmount,
          note: 'sec_acnt_opening_fee',
          refId: _resolveOpeningPaymentRefId(
            requestResult: requestResult,
            fallbackRefId: fallbackRefId,
          ),
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

  String _resolveOpeningPaymentRefId({
    required SecAcntRequestResult? requestResult,
    required String fallbackRefId,
  }) {
    final String? refNo = requestResult?.refNo?.toString().trim();
    if (refNo != null && refNo.isNotEmpty) {
      return refNo;
    }

    final String normalizedFallback = fallbackRefId.trim();
    return normalizedFallback.isEmpty ? 'sec_acnt_opening' : normalizedFallback;
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
