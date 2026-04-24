import 'package:mini_app_sdk/mini_app_sdk.dart';

class IpsSecAcntState {
  final bool isSubmitting;
  final SecAcntRequestResult? requestResult;
  final MiniAppPaymentRes? paymentRes;
  final String? errorMessage;

  const IpsSecAcntState({
    this.isSubmitting = false,
    this.requestResult,
    this.paymentRes,
    this.errorMessage,
  });

  static const Object sentinel = Object();

  IpsSecAcntState copyWith({
    bool? isSubmitting,
    Object? requestResult = sentinel,
    Object? paymentRes = sentinel,
    Object? errorMessage = sentinel,
  }) {
    return IpsSecAcntState(
      isSubmitting: isSubmitting ?? this.isSubmitting,
      requestResult: requestResult == sentinel
          ? this.requestResult
          : requestResult as SecAcntRequestResult?,
      paymentRes: paymentRes == sentinel
          ? this.paymentRes
          : paymentRes as MiniAppPaymentRes?,
      errorMessage: errorMessage == sentinel
          ? this.errorMessage
          : errorMessage as String?,
    );
  }
}
