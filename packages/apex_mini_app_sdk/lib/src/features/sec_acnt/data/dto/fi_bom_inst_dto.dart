import 'package:apex_mini_app_sdk/apex_mini_app_sdk.dart';

/// Financial institution metadata returned by `getFiBomInst`.
class FiBomInstDto {
  /// Financial institution code required by downstream securities APIs.
  final String fiCode;

  /// Primary institution name.
  final String? name;

  /// Secondary/localized institution name.
  final String? name2;

  /// Institution type.
  final String? fiType;

  /// Brief description.
  final String? brief;

  /// Secondary/localized brief description.
  final String? brief2;

  /// Membership flag.
  final int? isMember;

  /// Contact phone.
  final String? phone;

  /// Logo URL/path.
  final String? logo;

  /// Dark-mode logo URL/path.
  final String? logoDark;

  /// Dimmed logo URL/path.
  final String? logoDim;

  /// Dark dimmed logo URL/path.
  final String? logoDimDark;

  /// TAN FI flag.
  final int? isTanFi;

  /// Header color provided by backend.
  final String? headerColor;

  /// Body color provided by backend.
  final String? bodyColor;

  /// Online registration flag.
  final int? useOnlineReg;

  /// Sort order.
  final int? orderNo;

  /// Parent institution code.
  final String? parentCode;

  /// Company code.
  final String? companyCode;

  /// Backend status value.
  final String? status;

  /// Creates a financial institution DTO.
  const FiBomInstDto({
    required this.fiCode,
    this.name,
    this.name2,
    this.fiType,
    this.brief,
    this.brief2,
    this.isMember,
    this.phone,
    this.logo,
    this.logoDark,
    this.logoDim,
    this.logoDimDark,
    this.isTanFi,
    this.headerColor,
    this.bodyColor,
    this.useOnlineReg,
    this.orderNo,
    this.parentCode,
    this.companyCode,
    this.status,
  });

  /// Parses institution JSON and requires `fiCode` for downstream API calls.
  factory FiBomInstDto.fromJson(Map<String, Object?> json) {
    final String? fiCode = ApiParser.asNullableString(json['fiCode']);
    if (fiCode == null) {
      throw const ApiParsingException(
        'FI institution payload requires a non-empty fiCode.',
      );
    }

    return FiBomInstDto(
      fiCode: fiCode,
      name: ApiParser.asNullableString(json['name']),
      name2: ApiParser.asNullableString(json['name2']),
      fiType: ApiParser.asNullableString(json['fiType']),
      brief: ApiParser.asNullableString(json['brief']),
      brief2: ApiParser.asNullableString(json['brief2']),
      isMember: ApiParser.asNullableInt(json['isMember']),
      phone: ApiParser.asNullableString(json['phone']),
      logo: ApiParser.asNullableString(json['logo']),
      logoDark: ApiParser.asNullableString(json['logoDark']),
      logoDim: ApiParser.asNullableString(json['logoDim']),
      logoDimDark: ApiParser.asNullableString(json['logoDimDark']),
      isTanFi: ApiParser.asNullableInt(json['isTanFi']),
      headerColor: ApiParser.asNullableString(json['headerColor']),
      bodyColor: ApiParser.asNullableString(json['bodyColor']),
      useOnlineReg: ApiParser.asNullableInt(json['useOnlineReg']),
      orderNo: ApiParser.asNullableInt(json['orderNo']),
      parentCode: ApiParser.asNullableString(json['parentCode']),
      companyCode: ApiParser.asNullableString(json['companyCode']),
      status: ApiParser.asNullableString(json['status']),
    );
  }

  /// Parses a raw list response into institution DTOs.
  static List<FiBomInstDto> listFromRaw(Object? raw) {
    return ApiParser.asObjectMapList(
      raw,
    ).map(FiBomInstDto.fromJson).toList(growable: false);
  }
}

/// Envelope DTO for the FI institution list response.
class GetFiBomInstResDto {
  /// Parsed FI institutions.
  final List<FiBomInstDto> items;

  /// Backend response code.
  final int responseCode;

  /// Backend response description.
  final String responseDesc;

  /// Creates an FI institution list response DTO.
  const GetFiBomInstResDto({
    required this.items,
    required this.responseCode,
    required this.responseDesc,
  });

  /// Default institution used by the mini app when no explicit selection exists.
  FiBomInstDto get defaultItem => items.first;

  /// Parses the envelope and validates that at least one institution exists.
  factory GetFiBomInstResDto.fromJson(Map<String, Object?> json) {
    final ApiEnvelope<List<FiBomInstDto>> envelope =
        ApiEnvelope<List<FiBomInstDto>>.fromJson(
          json,
          FiBomInstDto.listFromRaw,
        );
    envelope.ensureSuccess();

    final List<FiBomInstDto> items = envelope.responseData;
    if (items.isEmpty) {
      throw const ApiParsingException(
        'FI institution payload requires at least one responseData item.',
      );
    }

    return GetFiBomInstResDto(
      items: List<FiBomInstDto>.unmodifiable(items),
      responseCode: envelope.responseCode,
      responseDesc: envelope.responseDesc,
    );
  }
}
