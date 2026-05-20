import 'package:apex_mini_app_sdk/apex_mini_app_sdk.dart';

/// UI state for securities-account opening flow.
class IpsSecAcntState {
  /// Whether a submit/payment action is running.
  final bool isSubmitting;

  /// Account-opening request result.
  final SecAcntRequestResult? requestResult;

  /// Host payment result.
  final MiniAppPaymentRes? paymentRes;

  /// User-facing error message.
  final String? errorMessage;

  /// Creates securities-account opening state.
  const IpsSecAcntState({
    this.isSubmitting = false,
    this.requestResult,
    this.paymentRes,
    this.errorMessage,
  });

  /// Sentinel used to distinguish omitted nullable fields from explicit null.
  static const Object sentinel = Object();

  /// Copies state while allowing explicit null assignment for nullable fields.
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
