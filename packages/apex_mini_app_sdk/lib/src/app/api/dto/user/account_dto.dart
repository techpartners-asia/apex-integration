part of '../user_entity_dto.dart';

class AccountDto {
  final String? accountCreationDate;
  final String? acntCode;
  final String? createdAt;
  final int? id;
  final num? investAmount;
  final bool? isInvest;
  final bool? isInvestContract;
  final String kycStatus;
  final String? packageCode;
  final num? profitAmount;
  final num? profitPercent;
  final String? scAcntCode;
  final int? signatureId;
  final String? streak;
  final num? targetGoal;
  final num? totalAmount;
  final String? updatedAt;
  final int? userId;
  final FileEntity? signatureFile;

  const AccountDto({
    this.accountCreationDate,
    this.acntCode,
    this.createdAt,
    this.id,
    this.investAmount,
    this.isInvest,
    this.isInvestContract,
    this.kycStatus = KycStatusType.unknown,
    this.packageCode,
    this.profitAmount,
    this.profitPercent,
    this.scAcntCode,
    this.signatureId,
    this.streak,
    this.targetGoal,
    this.totalAmount,
    this.updatedAt,
    this.userId,
    this.signatureFile,
  });

  factory AccountDto.fromJson(Map<String, Object?> json) {
    final Map<String, Object?> signatureFile = ApiParser.asObjectMap(
      json['signature_file'],
    );

    return AccountDto(
      accountCreationDate: ApiParser.asNullableString(
        json['account_creation_date'],
      ),
      acntCode: ApiParser.asNullableString(json['acnt_code']),
      createdAt: ApiParser.asNullableString(json['created_at']),
      id: ApiParser.asNullableInt(json['id']),
      investAmount: ApiParser.asNullableDouble(json['invest_amount']),
      isInvest: json.containsKey('is_invest')
          ? ApiParser.asFlag(json['is_invest'])
          : null,
      isInvestContract: json.containsKey('is_invest_contract')
          ? ApiParser.asFlag(json['is_invest_contract'])
          : null,
      kycStatus: ApiParser.asNullableString(json['kyc_status']) ?? '',
      packageCode: ApiParser.asNullableString(json['package_code']),
      profitAmount: ApiParser.asNullableDouble(json['profit_amount']),
      profitPercent: ApiParser.asNullableDouble(json['profit_percent']),
      scAcntCode: ApiParser.asNullableString(json['sc_acnt_code']),
      signatureId: ApiParser.asNullableInt(json['signature_id']),
      streak: ApiParser.asNullableString(json['streak']),
      targetGoal: ApiParser.asNullableDouble(json['target_goal']),
      totalAmount: ApiParser.asNullableDouble(json['total_amount']),
      updatedAt: ApiParser.asNullableString(json['updated_at']),
      userId: ApiParser.asNullableInt(json['user_id']),
      signatureFile: signatureFile.isEmpty
          ? null
          : FileEntity.fromJson(signatureFile),
    );
  }

  AccountDto copyWith({
    String? accountCreationDate,
    String? acntCode,
    String? createdAt,
    int? id,
    num? investAmount,
    bool? isInvest,
    bool? isInvestContract,
    String? kycStatus,
    String? packageCode,
    num? profitAmount,
    num? profitPercent,
    String? scAcntCode,
    int? signatureId,
    String? streak,
    num? targetGoal,
    num? totalAmount,
    String? updatedAt,
    int? userId,
    FileEntity? signatureFile,
  }) {
    return AccountDto(
      accountCreationDate: accountCreationDate ?? this.accountCreationDate,
      acntCode: acntCode ?? this.acntCode,
      createdAt: createdAt ?? this.createdAt,
      id: id ?? this.id,
      investAmount: investAmount ?? this.investAmount,
      isInvest: isInvest ?? this.isInvest,
      isInvestContract: isInvestContract ?? this.isInvestContract,
      kycStatus: kycStatus ?? this.kycStatus,
      packageCode: packageCode ?? this.packageCode,
      profitAmount: profitAmount ?? this.profitAmount,
      profitPercent: profitPercent ?? this.profitPercent,
      scAcntCode: scAcntCode ?? this.scAcntCode,
      signatureId: signatureId ?? this.signatureId,
      streak: streak ?? this.streak,
      targetGoal: targetGoal ?? this.targetGoal,
      totalAmount: totalAmount ?? this.totalAmount,
      updatedAt: updatedAt ?? this.updatedAt,
      userId: userId ?? this.userId,
      signatureFile: signatureFile ?? this.signatureFile,
    );
  }
}
