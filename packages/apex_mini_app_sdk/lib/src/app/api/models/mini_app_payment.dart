import 'package:apex_mini_app_sdk/apex_mini_app_sdk.dart';

/// Domain payment record returned by invoice/payment callback APIs.
class MiniAppPayment {
  /// Backend payment id.
  final int id;

  /// Payment amount.
  final double amount;

  /// Payment note/reference.
  final String? note;

  /// External invoice id used by host/payment provider.
  final String? externalInvoiceId;

  /// Backend UUID value.
  final String? uuid;

  /// Owning user id.
  final int? userId;

  /// Nested user payload, if included.
  final UserEntityDto? user;

  /// Normalized payment status.
  final MiniAppPaymentStatus status;

  /// Parsed creation timestamp.
  final DateTime? createdAt;

  /// Parsed update timestamp.
  final DateTime? updatedAt;

  /// Creates a mini-app payment domain model.
  const MiniAppPayment({
    required this.id,
    required this.amount,
    required this.status,
    this.note,
    this.externalInvoiceId,
    this.uuid,
    this.userId,
    this.user,
    this.createdAt,
    this.updatedAt,
  });

  /// Best invoice identifier to pass into payment callback checks.
  String? get resolvedInvoiceId {
    final String? external = externalInvoiceId?.trim();
    if (external != null && external.isNotEmpty) {
      return external;
    }

    final String? rawUuid = uuid?.trim();
    if (rawUuid != null && rawUuid.isNotEmpty) {
      return rawUuid;
    }

    return id > 0 ? id.toString() : null;
  }
}
