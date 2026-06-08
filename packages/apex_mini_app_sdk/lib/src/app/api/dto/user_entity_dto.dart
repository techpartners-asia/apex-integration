import 'package:apex_mini_app_sdk/apex_mini_app_sdk.dart';

part 'user/account_dto.dart';

part 'user/bank_dto.dart';

part 'user/file_entity.dart';

part 'user/region_dto.dart';

part 'user/user_value_types.dart';

/// Current user DTO returned by signup, bootstrap, and profile info APIs.
///
/// The parser accepts both direct user payloads and the nested bootstrap shape
/// where the backend wraps user data under `body.user`. Feature code uses this
/// DTO as the source of truth for session identity, bank/personal info, account
/// onboarding status, and display metadata.
class UserEntityDto {
  /// Host/backend token resolved during signup/bootstrap.
  String? token;

  /// Securities/invest account state nested under `account`.
  final AccountDto? account;

  /// Saved user bank account information.
  final BankDto? bank;

  /// User identifier.
  final int? id;

  /// Mongolian registration number.
  final String? registerNo;

  /// User first name.
  final String? firstName;

  /// User last name.
  final String? lastName;

  /// Primary phone number.
  final String? phone;

  /// Secondary phone number.
  final String? phoneAddition;

  /// User email address.
  final String? email;

  /// User gender value.
  final String? gender;

  /// External integration identifier.
  final String? integrationId;

  /// Current department/employer metadata.
  final String? currentDepartment;

  /// Current position/employment metadata.
  final String? currentPosition;

  /// Profile image metadata.
  final FileEntity? image;

  /// Profile image identifier.
  final int? imageId;

  /// Source platform normalized to [PlatformType].
  final String platform;

  /// Region object returned by profile APIs.
  final RegionDto? region;

  /// Region identifier.
  final int? regionId;

  /// Residential address.
  final String? residenceAddress;

  /// Residential country.
  final String? residenceCountry;

  /// Parsed creation timestamp.
  final DateTime? createdAt;

  /// Parsed update timestamp.
  final DateTime? updatedAt;

  /// Optional access token when included by backend responses.
  final String? accessToken;

  /// ADM/session token used by downstream Apex APIs.
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

  /// Parses direct and nested user response payloads.
  factory UserEntityDto.fromJson(
    Map<String, Object?> json, {
    String failureMessage = 'Request failed.',
  }) {
    ApiActionResultParser.ensureSuccess(
      json,
      fallbackErrorMessage: failureMessage,
    );

    final Map<String, Object?> payload = ApiParser.asObjectMap(json['body']);
    final Map<String, Object?> nestedUser = ApiParser.asObjectMap(
      payload['user'],
    );
    final Map<String, Object?> source = nestedUser.isNotEmpty
        ? nestedUser
        : payload.isNotEmpty
        ? payload
        : json;
    final Map<String, Object?> image = ApiParser.asObjectMap(source['image']);
    final Map<String, Object?> region = ApiParser.asObjectMap(source['region']);
    final Map<String, Object?> account = _accountJsonFrom(source);
    final Map<String, Object?> bank = _bankJsonFrom(source);
    final String? resolvedToken =
        ApiParser.asNullableString(payload['token']) ??
        ApiParser.asNullableString(json['token']);

    return UserEntityDto(
      account: AccountDto.fromJson(account),
      bank: BankDto.fromJson(bank),
      id: ApiParser.asNullableInt(source['id']),
      registerNo: ApiParser.asNullableString(source['rd']),
      token: resolvedToken,
      firstName: ApiParser.asNullableString(source['first_name']),
      lastName: ApiParser.asNullableString(source['last_name']),
      phone:
          ApiParser.asNullableString(source['phone']) ??
          ApiParser.asNullableString(source['phone_number']),
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
      platform: _parsePlatform(source['platform']),
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

  /// Builds the account map from nested and flat signup/profile fields.
  static Map<String, Object?> _accountJsonFrom(Map<String, Object?> source) {
    final Map<String, Object?> account = <String, Object?>{
      ...ApiParser.asObjectMap(source['account']),
    };
    for (final String key in const <String>[
      'is_invest',
      'is_invest_contract',
      'is_paid_contract',
      'kyc_status',
      'package_code',
      'signature_id',
      'signature_file',
    ]) {
      if (source.containsKey(key) && !account.containsKey(key)) {
        account[key] = source[key];
      }
    }
    return account;
  }

  /// Builds the bank map from nested and flat signup/profile fields.
  static Map<String, Object?> _bankJsonFrom(Map<String, Object?> source) {
    final Map<String, Object?> bank = <String, Object?>{
      ...ApiParser.asObjectMap(source['bank']),
    };
    for (final String key in const <String>[
      'account_number',
      'account_name',
      'bank_id',
      'bank_code',
      'bank_name',
      'user_id',
      'created_at',
      'updated_at',
    ]) {
      if (source.containsKey(key) && !bank.containsKey(key)) {
        bank[key] = source[key];
      }
    }
    if (source.containsKey('iban') && !bank.containsKey('account_number')) {
      bank['account_number'] = source['iban'];
    }
    return bank;
  }

  /// Normalizes unknown platform values.
  static String _parsePlatform(Object? value) {
    final String? platform = ApiParser.asNullableString(value);
    return switch (platform) {
      PlatformType.tino || PlatformType.grape => platform!,
      _ => PlatformType.unknown,
    };
  }

  /// Best display name for headers/profile cards.
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

  /// Non-null user id convenience for APIs that require an integer.
  int get userId => id.isNotNullOrEmpty ? id! : 0;

  /// Returns a copy with selected fields replaced.
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
