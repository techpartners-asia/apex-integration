import 'package:mini_app_sdk/mini_app_sdk.dart';

part 'user/account_dto.dart';
part 'user/bank_dto.dart';
part 'user/file_entity.dart';
part 'user/region_dto.dart';
part 'user/user_value_types.dart';

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
    final String? resolvedToken =
        ApiParser.asNullableString(payload['token']) ??
        ApiParser.asNullableString(json['token']);

    return UserEntityDto(
      account: AccountDto.fromJson(ApiParser.asObjectMap(source['account'])),
      bank: BankDto.fromJson(ApiParser.asObjectMap(source['bank'])),
      id: ApiParser.asNullableInt(source['id']),
      registerNo: isBootstrapUserPayload
          ? _asRequiredBootstrapText(source['rd'])
          : ApiParser.asNullableString(source['rd']),
      token: resolvedToken,
      firstName: isBootstrapUserPayload
          ? _asRequiredBootstrapText(source['first_name'])
          : ApiParser.asNullableString(source['first_name']),
      lastName: isBootstrapUserPayload
          ? _asRequiredBootstrapText(source['last_name'])
          : ApiParser.asNullableString(source['last_name']),
      phone: isBootstrapUserPayload
          ? _asRequiredBootstrapText(source['phone'])
          : ApiParser.asNullableString(source['phone']),
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
      admSession:
          resolvedToken ??
          ApiParser.asNullableString(source['adm_session']) ??
          ApiParser.asNullableString(source['admSession']),
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
