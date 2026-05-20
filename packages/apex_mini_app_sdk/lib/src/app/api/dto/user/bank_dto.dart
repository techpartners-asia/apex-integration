part of '../user_entity_dto.dart';

/// Bank account section returned in profile/signup user payloads.
///
/// The same shape is reused for saved user bank data and selected bank details
/// in onboarding flows.
class BankDto {
  /// Bank account number or IBAN.
  final String? accountNumber;

  /// Account holder name.
  final String? accountName;

  /// Bank identifier as a string because some API responses return it as text.
  final String? bankId;

  /// Backend bank code.
  final String? bankCode;

  /// Human-readable bank name.
  final String? bankName;

  /// Numeric backend row identifier.
  final int? id;

  /// Owning user identifier.
  final int? userId;

  /// Raw creation timestamp.
  final String? createdAt;

  /// Raw update timestamp.
  final String? updatedAt;

  /// Creates a user bank DTO.
  const BankDto({
    this.accountNumber,
    this.accountName,
    this.bankId,
    this.bankCode,
    this.bankName,
    this.id,
    this.userId,
    this.createdAt,
    this.updatedAt,
  });

  /// Parses backend bank JSON with fallback support for `bank_id`/`id`.
  factory BankDto.fromJson(Map<String, Object?> json) => BankDto(
    accountNumber: ApiParser.asNullableString(json['account_number']),
    accountName: ApiParser.asNullableString(json['account_name']),
    bankId:
        ApiParser.asNullableString(json['bank_id']) ??
        ApiParser.asNullableString(json['id']),
    bankCode: ApiParser.asNullableString(json['bank_code']),
    bankName: ApiParser.asNullableString(json['bank_name']),
    id: ApiParser.asNullableInt(json['id']),
    userId: ApiParser.asNullableInt(json['user_id']),
    createdAt: ApiParser.asNullableString(json['created_at']),
    updatedAt: ApiParser.asNullableString(json['updated_at']),
  );

  /// Returns a copy with selected fields replaced.
  BankDto copyWith({
    String? accountNumber,
    String? accountName,
    String? bankId,
    String? bankCode,
    String? bankName,
    int? id,
    int? userId,
    String? createdAt,
    String? updatedAt,
  }) {
    return BankDto(
      accountNumber: accountNumber ?? this.accountNumber,
      accountName: accountName ?? this.accountName,
      bankId: bankId ?? this.bankId,
      bankCode: bankCode ?? this.bankCode,
      bankName: bankName ?? this.bankName,
      id: id ?? this.id,
      userId: userId ?? this.userId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
