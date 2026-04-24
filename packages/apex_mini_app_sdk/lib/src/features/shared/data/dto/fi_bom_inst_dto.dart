import 'package:mini_app_sdk/mini_app_sdk.dart';

class FiBomInstDto {
  final String fiCode;
  final String? name;
  final String? name2;
  final String? fiType;
  final String? brief;
  final String? brief2;
  final int? isMember;
  final String? phone;
  final String? logo;
  final String? logoDark;
  final String? logoDim;
  final String? logoDimDark;
  final int? isTanFi;
  final String? headerColor;
  final String? bodyColor;
  final int? useOnlineReg;
  final int? orderNo;
  final String? parentCode;
  final String? companyCode;
  final String? status;

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

  static List<FiBomInstDto> listFromRaw(Object? raw) {
    return ApiParser.asObjectMapList(
      raw,
    ).map(FiBomInstDto.fromJson).toList(growable: false);
  }
}

class GetFiBomInstResDto {
  final List<FiBomInstDto> items;
  final int responseCode;
  final String responseDesc;

  const GetFiBomInstResDto({
    required this.items,
    required this.responseCode,
    required this.responseDesc,
  });

  FiBomInstDto get defaultItem => items.first;

  factory GetFiBomInstResDto.fromJson(Map<String, Object?> json) {
    final ApiEnvelope<List<FiBomInstDto>> envelope = ApiEnvelope<List<FiBomInstDto>>.fromJson(
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
