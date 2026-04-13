import '../dto/user_entity_dto.dart';

enum MiniAppPaymentStatus { pending, paid, unknown }

class MiniAppPayment {
  final int id;
  final double amount;
  final String? note;
  final String? externalInvoiceId;
  final String? uuid;
  final int? userId;
  final UserEntityDto? user;
  final MiniAppPaymentStatus status;
  final DateTime? createdAt;
  final DateTime? updatedAt;

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
