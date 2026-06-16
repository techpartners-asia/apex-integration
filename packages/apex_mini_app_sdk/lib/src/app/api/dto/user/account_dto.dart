part of '../user_entity_dto.dart';

/// Securities/account section returned inside profile and signup responses.
///
/// This DTO keeps backend fields nullable where older responses may omit them,
/// while exposing helper getters for onboarding decisions such as paid-contract
/// and saved-signature checks.
class AccountDto {
  /// Date when the securities account was created, if the backend provides it.
  final String? accountCreationDate;

  /// Apex account code.
  final String? acntCode;

  /// Raw creation timestamp from the backend.
  final String? createdAt;

  /// Backend account row identifier.
  final int? id;

  /// Total amount invested through the account.
  final num? investAmount;

  /// Whether the user has started or completed invest onboarding.
  final bool? isInvest;

  /// Whether the invest contract flag exists in the legacy backend response.
  final bool? isInvestContract;

  /// Whether the contract/payment requirement has already been paid.
  ///
  /// This is not proof that an actual securities account exists; account-only
  /// actions must still rely on the securities account list/`hasAcnt` state.
  final bool isPaidContract;

  /// KYC status normalized to [KycStatusType] constants.
  final String kycStatus;

  /// Selected investment package code.
  final String? packageCode;

  /// Current profit amount.
  final num? profitAmount;

  /// Current profit percentage.
  final num? profitPercent;

  /// Securities account code.
  final String? scAcntCode;

  /// Signature file identifier used by older profile responses.
  final int? signatureId;

  /// Next goal description returned by backend gamification/account state.
  final String? goal;

  /// Streak value returned by backend gamification/account state.
  final String? streak;

  /// Target goal amount configured by the user.
  final num? targetGoal;

  /// Total account amount.
  final num? totalAmount;

  /// Raw update timestamp from the backend.
  final String? updatedAt;

  /// Owning user identifier.
  final int? userId;

  /// Signature file object returned by newer profile responses.
  final FileEntity? signatureFile;

  /// Raw signature file value when the backend returns a non-object reference.
  final String? signatureFileReference;

  /// Creates a user account DTO.
  const AccountDto({
    this.accountCreationDate,
    this.acntCode,
    this.createdAt,
    this.id,
    this.investAmount,
    this.isInvest,
    this.isInvestContract,
    this.isPaidContract = false,
    this.kycStatus = KycStatusType.unknown,
    this.packageCode,
    this.profitAmount,
    this.profitPercent,
    this.scAcntCode,
    this.goal,
    this.signatureId,
    this.streak,
    this.targetGoal,
    this.totalAmount,
    this.updatedAt,
    this.userId,
    this.signatureFile,
    this.signatureFileReference,
  });

  /// Parses the account object with safe defaults for newer optional fields.
  factory AccountDto.fromJson(Map<String, Object?> json) {
    final Object? rawSignatureFile = json['signature_file'];
    final Map<String, Object?> signatureFile = ApiParser.asObjectMap(
      rawSignatureFile,
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
      isPaidContract: ApiParser.asFlag(json['is_paid_contract']),
      kycStatus: _parseKycStatus(json['kyc_status']),
      packageCode: ApiParser.asNullableString(json['package_code']),
      profitAmount: ApiParser.asNullableDouble(json['profit_amount']),
      profitPercent: ApiParser.asNullableDouble(json['profit_percent']),
      scAcntCode: ApiParser.asNullableString(json['sc_acnt_code']),
      signatureId: ApiParser.asNullableInt(json['signature_id']),
      goal: ApiParser.asNullableString(json['goal']),
      streak: ApiParser.asNullableString(json['streak']),
      targetGoal: ApiParser.asNullableDouble(json['target_goal']),
      totalAmount: ApiParser.asNullableDouble(json['total_amount']),
      updatedAt: ApiParser.asNullableString(json['updated_at']),
      userId: ApiParser.asNullableInt(json['user_id']),
      signatureFile: signatureFile.isEmpty
          ? null
          : FileEntity.fromJson(signatureFile),
      signatureFileReference: _parseSignatureFileReference(
        rawSignatureFile,
        signatureFile,
      ),
    );
  }

  /// Returns a copy with selected fields replaced.
  AccountDto copyWith({
    String? accountCreationDate,
    String? acntCode,
    String? createdAt,
    int? id,
    num? investAmount,
    bool? isInvest,
    bool? isInvestContract,
    bool? isPaidContract,
    String? kycStatus,
    String? packageCode,
    num? profitAmount,
    num? profitPercent,
    String? scAcntCode,
    String? goal,
    int? signatureId,
    String? streak,
    num? targetGoal,
    num? totalAmount,
    String? updatedAt,
    int? userId,
    FileEntity? signatureFile,
    String? signatureFileReference,
  }) {
    return AccountDto(
      accountCreationDate: accountCreationDate ?? this.accountCreationDate,
      acntCode: acntCode ?? this.acntCode,
      createdAt: createdAt ?? this.createdAt,
      id: id ?? this.id,
      investAmount: investAmount ?? this.investAmount,
      isInvest: isInvest ?? this.isInvest,
      isInvestContract: isInvestContract ?? this.isInvestContract,
      isPaidContract: isPaidContract ?? this.isPaidContract,
      kycStatus: kycStatus ?? this.kycStatus,
      packageCode: packageCode ?? this.packageCode,
      profitAmount: profitAmount ?? this.profitAmount,
      profitPercent: profitPercent ?? this.profitPercent,
      scAcntCode: scAcntCode ?? this.scAcntCode,
      goal: goal ?? this.goal,
      signatureId: signatureId ?? this.signatureId,
      streak: streak ?? this.streak,
      targetGoal: targetGoal ?? this.targetGoal,
      totalAmount: totalAmount ?? this.totalAmount,
      updatedAt: updatedAt ?? this.updatedAt,
      userId: userId ?? this.userId,
      signatureFile: signatureFile ?? this.signatureFile,
      signatureFileReference:
          signatureFileReference ?? this.signatureFileReference,
    );
  }

  /// Whether InvestX contract onboarding is already completed.
  bool get hasInvestContract => isInvestContract == true;

  /// Whether contract/payment onboarding is already completed.
  bool get hasPaidContract => isPaidContract;

  /// Whether the user already has a drawable signature stored.
  bool get hasDrawableSignature => hasSavedSignature;

  /// Whether any known signature source exists in the profile response.
  bool get hasSavedSignature {
    final int? signatureFileId = signatureFile?.id;
    return (signatureId != null && signatureId! > 0) ||
        (signatureFileId != null && signatureFileId > 0) ||
        _hasText(signatureFile?.physicalPath) ||
        _hasText(signatureFile?.fileName) ||
        _hasText(signatureFileReference);
  }

  /// Returns true when a nullable backend string contains visible text.
  bool _hasText(String? value) => value?.trim().isNotEmpty ?? false;

  /// Normalizes unsupported/missing KYC values to [KycStatusType.unknown].
  static String _parseKycStatus(Object? value) {
    final String? status = ApiParser.asNullableString(value);
    return switch (status) {
      KycStatusType.pending ||
      KycStatusType.verified ||
      KycStatusType.rejected => status!,
      _ => KycStatusType.unknown,
    };
  }

  /// Preserves non-empty `signature_file` payloads even when their shape varies.
  static String? _parseSignatureFileReference(
    Object? rawValue,
    Map<String, Object?> signatureFile,
  ) {
    if (signatureFile.isNotEmpty) {
      return signatureFile.toString();
    }
    if (rawValue is Iterable && rawValue.isEmpty) {
      return null;
    }
    return ApiParser.asNullableString(rawValue);
  }
}
