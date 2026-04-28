part of '../user_entity_dto.dart';

class BankDto {
  final String? accountNumber;
  final String? accountName;
  final String? bankId;
  final String? bankCode;
  final String? bankName;
  final int? id;
  final int? userId;
  final String? createdAt;
  final String? updatedAt;

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
