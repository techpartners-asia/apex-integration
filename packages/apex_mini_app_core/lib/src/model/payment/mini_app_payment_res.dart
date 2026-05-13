import 'package:mini_app_core/mini_app_core.dart';

class MiniAppPaymentRes {
  final MiniAppPaymentStatus status;
  final String? message;
  final String? transactionId;
  final MiniAppFailure? failure;
  final MiniAppPaymentReq req;

  const MiniAppPaymentRes.success({
    this.message,
    this.transactionId,
    required this.req,
  }) : failure = null,
       status = MiniAppPaymentStatus.success;

  const MiniAppPaymentRes.failed({
    this.message,
    this.transactionId,
    this.failure,
    required this.req,
  }) : status = MiniAppPaymentStatus.failed;

  const MiniAppPaymentRes.unknown({
    this.message,
    this.transactionId,
    required this.req,
  }) : failure = null,
       status = MiniAppPaymentStatus.unknown;

  bool get success => status == MiniAppPaymentStatus.success;
}
