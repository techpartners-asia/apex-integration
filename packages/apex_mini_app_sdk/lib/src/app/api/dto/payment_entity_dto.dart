import 'package:apex_mini_app_sdk/apex_mini_app_sdk.dart';

/// Payment DTO returned by invoice and payment APIs.
class PaymentEntityDto {
  /// Backend payment id.
  final int id;

  /// Payment amount.
  final double amount;

  /// Payment note/reference.
  final String? note;

  /// External invoice id.
  final String? externalInvoiceId;

  /// Backend UUID value.
  final String? uuid;

  /// Owning user id.
  final int? userId;

  /// Nested user payload.
  final UserEntityDto? user;

  /// Normalized payment status.
  final MiniAppPaymentStatus status;

  /// Parsed creation timestamp.
  final DateTime? createdAt;

  /// Parsed update timestamp.
  final DateTime? updatedAt;

  /// Creates a payment entity DTO.
  const PaymentEntityDto({
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

  /// Parses a payment payload and requires id/amount.
  factory PaymentEntityDto.fromJson(Map<String, Object?> json) {
    final int? id = ApiParser.asNullableInt(json['id']);
    final double? amount = ApiParser.asNullableDouble(json['amount']);
    final String statusText =
        ApiParser.asNullableString(json['status'])?.toLowerCase() ?? '';

    if (id == null || amount == null) {
      throw const ApiParsingException(
        'Payment payload requires id and amount.',
      );
    }

    return PaymentEntityDto(
      id: id,
      amount: amount,
      status: switch (statusText) {
        _ => MiniAppPaymentStatus.unknown,
      },
      note: ApiParser.asNullableString(json['note']),
      externalInvoiceId: ApiParser.asNullableString(
        json['external_invoice_id'],
      ),
      uuid: ApiParser.asNullableString(json['uuid']),
      userId: ApiParser.asNullableInt(json['user_id']),
      user: _parseUser(json['user']),
      createdAt: ApiParser.asNullableDateTime(json['created_at']),
      updatedAt: ApiParser.asNullableDateTime(json['updated_at']),
    );
  }

  static UserEntityDto? _parseUser(Object? raw) {
    final Map<String, Object?> json = ApiParser.asObjectMap(raw);
    if (json.isEmpty) {
      return null;
    }
    return UserEntityDto.fromJson(json);
  }

  /// Converts this DTO to the domain payment model.
  MiniAppPayment toDomain() {
    return MiniAppPayment(
      id: id,
      amount: amount,
      status: status,
      note: note,
      externalInvoiceId: externalInvoiceId,
      uuid: uuid,
      userId: userId,
      user: user,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}
