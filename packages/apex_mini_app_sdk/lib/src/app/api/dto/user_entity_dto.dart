import 'package:mini_app_sdk/mini_app_sdk.dart';

class KycStatusType {
  static const pending = 'pending';
  static const verified = 'verified';
  static const rejected = 'rejected';
  static const unknown = 'unknown';
}

class PlatformType {
  static const tino = 'tino';
  static const grape = 'grape';
  static const unknown = 'unknown';
}

class UserEntityDto {
  String? token;
  final AccountDto? account;
  final BankDto? bank;
  final int? id;
  final String? registerNo;
  final String? firstName;
  final String? lastName;
  final String? phone;
  final String? phoneAddition;
  final String? email;
  final String? gender;
  final String? integrationId;
  final String? currentDepartment;
  final String? currentPosition;
  final FileEntity? image;
  final int? imageId;
  final String platform;
  final RegionDto? region;
  final int? regionId;
  final String? residenceAddress;
  final String? residenceCountry;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  final String? accessToken;
  String? admSession;

  UserEntityDto({
    this.token,
    this.account,
    this.bank,
    this.id,
    this.registerNo,
    this.firstName,
    this.lastName,
    this.phone,
    this.phoneAddition,
    this.email,
    this.gender,
    this.integrationId,
    this.currentDepartment,
    this.currentPosition,
    this.image,
    this.imageId,
    this.platform = PlatformType.unknown,
    this.region,
    this.regionId,
    this.residenceAddress,
    this.residenceCountry,
    this.createdAt,
    this.updatedAt,
    this.accessToken,
    this.admSession,
  });

  factory UserEntityDto.fromJson(Map<String, Object?> json) {
    final Map<String, Object?> payload = ApiParser.asObjectMap(json['body']);
    final Map<String, Object?> nestedUser = ApiParser.asObjectMap(
      payload['user'],
    );
    final bool isBootstrapUserPayload = nestedUser.isNotEmpty;
    final Map<String, Object?> source = nestedUser.isNotEmpty
        ? nestedUser
        : payload.isNotEmpty
        ? payload
        : json;
    final Map<String, Object?> image = ApiParser.asObjectMap(source['image']);
    final Map<String, Object?> region = ApiParser.asObjectMap(source['region']);
    final String? resolvedToken = ApiParser.asNullableString(payload['token']) ?? ApiParser.asNullableString(json['token']);

    return UserEntityDto(
      account: AccountDto.fromJson(ApiParser.asObjectMap(source['account'])),
      bank: BankDto.fromJson(ApiParser.asObjectMap(source['bank'])),
      id: ApiParser.asNullableInt(source['id']),
      registerNo: isBootstrapUserPayload ? _asRequiredBootstrapText(source['rd']) : ApiParser.asNullableString(source['rd']),
      token: resolvedToken,
      firstName: isBootstrapUserPayload ? _asRequiredBootstrapText(source['first_name']) : ApiParser.asNullableString(source['first_name']),
      lastName: isBootstrapUserPayload ? _asRequiredBootstrapText(source['last_name']) : ApiParser.asNullableString(source['last_name']),
      phone: isBootstrapUserPayload ? _asRequiredBootstrapText(source['phone']) : ApiParser.asNullableString(source['phone']),
      phoneAddition: ApiParser.asNullableString(source['phone_addition']),
      email: ApiParser.asNullableString(source['email']),
      gender: ApiParser.asNullableString(source['gender']),
      integrationId: ApiParser.asNullableString(source['integration_id']),
      currentDepartment: ApiParser.asNullableString(
        source['current_department'],
      ),
      currentPosition: ApiParser.asNullableString(source['current_position']),
      image: image.isEmpty ? null : FileEntity.fromJson(image),
      imageId: ApiParser.asNullableInt(source['image_id']),
      platform: ApiParser.asNullableString(source['platform']) ?? '',
      region: region.isEmpty ? null : RegionDto.fromJson(region),
      regionId: ApiParser.asNullableInt(source['region_id']),
      residenceAddress: ApiParser.asNullableString(source['residence_address']),
      residenceCountry: ApiParser.asNullableString(source['residence_country']),
      createdAt: ApiParser.asNullableDateTime(source['created_at']),
      updatedAt: ApiParser.asNullableDateTime(source['updated_at']),
      admSession: resolvedToken ?? ApiParser.asNullableString(source['adm_session']) ?? ApiParser.asNullableString(source['admSession']),
    );
  }

  static String _asRequiredBootstrapText(Object? value) {
    return value?.toString().trim() ?? '';
  }

  String get displayName {
    final String fullName = '${firstName ?? ''} ${lastName ?? ''}'.trim();
    if (fullName.isNotEmpty) {
      return fullName;
    }
    if (registerNo.isNotNullOrEmpty) {
      return registerNo!;
    }

    return phone ?? '';
  }

  int get userId => id.isNotNullOrEmpty ? id! : 0;

  UserEntityDto copyWith({
    String? token,
    AccountDto? account,
    BankDto? bank,
    int? id,
    String? registerNo,
    String? firstName,
    String? lastName,
    String? phone,
    String? phoneAddition,
    String? platform,
    String? email,
    String? gender,
    String? integrationId,
    String? currentDepartment,
    String? currentPosition,
    FileEntity? image,
    int? imageId,
    String? platformType,
    RegionDto? region,
    int? regionId,
    String? residenceAddress,
    String? residenceCountry,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? accessToken,
    String? admSession,
  }) {
    return UserEntityDto(
      token: token ?? this.token,
      account: account ?? this.account,
      bank: bank ?? this.bank,
      id: id ?? this.id,
      registerNo: registerNo ?? this.registerNo,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      phone: phone ?? this.phone,
      phoneAddition: phoneAddition ?? this.phoneAddition,
      email: email ?? this.email,
      gender: gender ?? this.gender,
      integrationId: integrationId ?? this.integrationId,
      currentDepartment: currentDepartment ?? this.currentDepartment,
      currentPosition: currentPosition ?? this.currentPosition,
      image: image ?? this.image,
      imageId: imageId ?? this.imageId,
      platform: platformType ?? this.platform,
      region: region ?? this.region,
      regionId: regionId ?? this.regionId,
      residenceAddress: residenceAddress ?? this.residenceAddress,
      residenceCountry: residenceCountry ?? this.residenceCountry,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      accessToken: accessToken ?? this.accessToken,
      admSession: admSession ?? this.admSession,
    );
  }
}

class FileEntity {
  final int? id;
  final String? fileName;
  final String? originalName;
  final String? physicalPath;
  final String? extention;
  final num? fileSize;
  final String? createdAt;
  final String? updatedAt;

  const FileEntity({
    this.id,
    this.fileName,
    this.originalName,
    this.physicalPath,
    this.extention,
    this.fileSize,
    this.createdAt,
    this.updatedAt,
  });

  factory FileEntity.fromJson(Map<String, Object?> json) {
    return FileEntity(
      id: ApiParser.asNullableInt(json['id']),
      fileName: ApiParser.asNullableString(json['file_name']),
      originalName: ApiParser.asNullableString(json['original_name']),
      physicalPath: ApiParser.asNullableString(json['physical_path']),
      extention: ApiParser.asNullableString(json['extention']),
      fileSize: ApiParser.asNullableDouble(json['file_size']),
      createdAt: ApiParser.asNullableString(json['created_at']),
      updatedAt: ApiParser.asNullableString(json['updated_at']),
    );
  }

  FileEntity copyWith({
    int? id,
    String? fileName,
    String? originalName,
    String? physicalPath,
    String? extention,
    num? fileSize,
    String? createdAt,
    String? updatedAt,
  }) {
    return FileEntity(
      id: id ?? this.id,
      fileName: fileName ?? this.fileName,
      originalName: originalName ?? this.originalName,
      physicalPath: physicalPath ?? this.physicalPath,
      extention: extention ?? this.extention,
      fileSize: fileSize ?? this.fileSize,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

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
    final Map<String, Object?> signatureFile = ApiParser.asObjectMap(json['signature_file']);

    return AccountDto(
      accountCreationDate: ApiParser.asNullableString(json['account_creation_date']),
      acntCode: ApiParser.asNullableString(json['acnt_code']),
      createdAt: ApiParser.asNullableString(json['created_at']),
      id: ApiParser.asNullableInt(json['id']),
      investAmount: ApiParser.asNullableDouble(json['invest_amount']),
      isInvest: json.containsKey('is_invest') ? ApiParser.asFlag(json['is_invest']) : null,
      isInvestContract: json.containsKey('is_invest_contract') ? ApiParser.asFlag(json['is_invest_contract']) : null,
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
      signatureFile: signatureFile.isEmpty ? null : FileEntity.fromJson(signatureFile),
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
    bankId: ApiParser.asNullableString(json['bank_id']) ?? ApiParser.asNullableString(json['id']),
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

class RegionDto {
  final String? alpha2;
  final String? createdAt;
  final int? id;
  final String? name;
  final String? updatedAt;

  const RegionDto({
    this.alpha2,
    this.createdAt,
    this.id,
    this.name,
    this.updatedAt,
  });

  factory RegionDto.fromJson(Map<String, Object?> json) {
    return RegionDto(
      alpha2: ApiParser.asNullableString(json['alpha2']),
      createdAt: ApiParser.asNullableString(json['created_at']),
      id: ApiParser.asNullableInt(json['id']),
      name: ApiParser.asNullableString(json['name']),
      updatedAt: ApiParser.asNullableString(json['updated_at']),
    );
  }

  RegionDto copyWith({
    String? alpha2,
    String? createdAt,
    int? id,
    String? name,
    String? updatedAt,
  }) {
    return RegionDto(
      alpha2: alpha2 ?? this.alpha2,
      createdAt: createdAt ?? this.createdAt,
      id: id ?? this.id,
      name: name ?? this.name,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
