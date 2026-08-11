import 'package:apex_mini_app_sdk/apex_mini_app_sdk.dart';

/// Request body for checking whether the opening-fee payment is required.
class IsPaymentActiveApiReq {
  /// Opening commission amount from the securities account bootstrap state.
  final double commission;

  /// Creates a validated is-payment-active request.
  ///
  /// [commission] must be finite and non-negative.
  IsPaymentActiveApiReq({required num commission})
    : commission = commission.toDouble() {
    if (!this.commission.isFinite || this.commission < 0) {
      throw const ApiIntegrationException(
        'isPaymentActive requires a non-negative commission.',
      );
    }
  }

  /// Converts this request into the backend payload.
  Map<String, Object?> toJson() {
    final num commissionValue = commission == commission.truncateToDouble()
        ? commission.toInt()
        : commission;
    return <String, Object?>{'commission': commissionValue};
  }
}
