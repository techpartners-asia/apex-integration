import 'package:mini_app_sdk/mini_app_sdk.dart';

class PaymentEntityDto {
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

  factory PaymentEntityDto.fromJson(Map<String, Object?> json) {
    final int? id = ApiParser.asNullableInt(json['id']);
    final double? amount = ApiParser.asNullableDouble(json['amount']);
    final String statusText = ApiParser.asNullableString(json['status'])?.toLowerCase() ?? '';

    if (id == null || amount == null) {
      throw const ApiParsingException(
        'Payment payload requires id and amount.',
      );
    }

    return PaymentEntityDto(
      id: id,
      amount: amount,
      status: switch (statusText) {
        'pending' => MiniAppPaymentStatus.pending,
        'paid' => MiniAppPaymentStatus.paid,
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
