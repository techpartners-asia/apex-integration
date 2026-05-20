import 'package:apex_mini_app_core/apex_mini_app_core.dart';

/// Result returned by the host wallet/payment callback.
class MiniAppPaymentRes {
  /// Final payment status.
  final MiniAppPaymentStatus status;

  /// Optional user-facing or diagnostic message.
  final String? message;

  /// Optional transaction identifier returned by the host wallet.
  final String? transactionId;

  /// Optional structured failure data when [status] is failed.
  final MiniAppFailure? failure;

  /// Original payment request that produced this response.
  final MiniAppPaymentReq req;

  /// Successful payment response.
  const MiniAppPaymentRes.success({
    this.message,
    this.transactionId,
    required this.req,
  }) : failure = null,
       status = MiniAppPaymentStatus.success;

  /// Failed payment response.
  const MiniAppPaymentRes.failed({
    this.message,
    this.transactionId,
    this.failure,
    required this.req,
  }) : status = MiniAppPaymentStatus.failed;

  /// Indeterminate payment response when host/payment status cannot be known.
  const MiniAppPaymentRes.unknown({
    this.message,
    this.transactionId,
    required this.req,
  }) : failure = null,
       status = MiniAppPaymentStatus.unknown;

  /// Convenience flag for successful payment.
  bool get success => status == MiniAppPaymentStatus.success;
}
