import '../failure/mini_app_failure.dart';
import 'mini_app_payment_status.dart';

class MiniAppPaymentRes {
  const MiniAppPaymentRes.success({
    this.message,
    this.transactionId,
    this.paymentReference,
    this.metadata = const <String, Object?>{},
  }) : failure = null,
       status = MiniAppPaymentStatus.success;

  const MiniAppPaymentRes.failed({
    this.message,
    this.transactionId,
    this.paymentReference,
    this.failure,
    this.metadata = const <String, Object?>{},
  }) : status = MiniAppPaymentStatus.failed;

  const MiniAppPaymentRes.cancelled({
    this.message,
    this.transactionId,
    this.paymentReference,
    this.metadata = const <String, Object?>{},
  }) : failure = null,
       status = MiniAppPaymentStatus.cancelled;

  const MiniAppPaymentRes.timedOut({
    this.message,
    this.transactionId,
    this.paymentReference,
    this.metadata = const <String, Object?>{},
  }) : failure = null,
       status = MiniAppPaymentStatus.timedOut;

  const MiniAppPaymentRes.unsupported({
    this.message,
    this.failure,
    this.metadata = const <String, Object?>{},
  }) : transactionId = null,
       paymentReference = null,
       status = MiniAppPaymentStatus.unsupported;

  const MiniAppPaymentRes.pending({
    this.message,
    this.transactionId,
    this.paymentReference,
    this.metadata = const <String, Object?>{},
  }) : failure = null,
       status = MiniAppPaymentStatus.pending;

  const MiniAppPaymentRes.paid({
    this.message,
    this.transactionId,
    this.paymentReference,
    this.metadata = const <String, Object?>{},
  }) : failure = null,
       status = MiniAppPaymentStatus.paid;

  const MiniAppPaymentRes.unknown({
    this.message,
    this.transactionId,
    this.paymentReference,
    this.failure,
    this.metadata = const <String, Object?>{},
  }) : status = MiniAppPaymentStatus.unknown;

  final MiniAppPaymentStatus status;
  final String? message;
  final String? transactionId;
  final String? paymentReference;
  final MiniAppFailure? failure;
  final Map<String, Object?> metadata;

  bool get success =>
      status == MiniAppPaymentStatus.success ||
      status == MiniAppPaymentStatus.paid;
}
