import 'package:apex_mini_app_sdk/apex_mini_app_sdk.dart';

/// Response DTO for securities account opening fees.
class AccountFeesAmountDto {
  /// Fee amount to add to the opening commission on the payment screen.
  final double amount;

  /// Backend record id.
  final int? id;

  /// Parsed creation timestamp.
  final DateTime? createdAt;

  /// Parsed update timestamp.
  final DateTime? updatedAt;

  /// Creates an account-fees amount DTO.
  const AccountFeesAmountDto({
    required this.amount,
    this.id,
    this.createdAt,
    this.updatedAt,
  });

  /// Parses the `GET /api/v1/user/payment/account-fees-amount` response.
  factory AccountFeesAmountDto.fromJson(Map<String, Object?> json) {
    ApiActionResultParser.ensureSuccess(
      json,
      fallbackErrorMessage: 'Failed to load account fees amount.',
    );

    final Map<String, Object?> body = ApiActionResultParser.bodyOf(json);
    if (body.isEmpty) {
      throw ApiParsingException(
        ApiActionResultParser.messageOf(json) ??
            'account-fees-amount returned success without a body payload.',
      );
    }

    final double? amount = ApiParser.asNullableDouble(body['amount']);
    if (amount == null || !amount.isFinite || amount < 0) {
      throw ApiParsingException(
        'account-fees-amount returned an invalid amount.',
      );
    }

    return AccountFeesAmountDto(
      amount: amount,
      id: ApiParser.asNullableInt(body['id']),
      createdAt: ApiParser.asNullableDateTime(body['created_at']),
      updatedAt: ApiParser.asNullableDateTime(body['updated_at']),
    );
  }
}
