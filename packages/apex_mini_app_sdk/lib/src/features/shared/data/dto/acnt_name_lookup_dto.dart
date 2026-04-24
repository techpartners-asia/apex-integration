import 'package:mini_app_sdk/mini_app_sdk.dart';

class AcntNameLookupDto {
  final int? responseCode;
  final String? responseDesc;
  final String? acntName;
  final String? maskedAcntName;

  const AcntNameLookupDto({
    this.responseCode,
    this.responseDesc,
    this.acntName,
    this.maskedAcntName,
  });

  factory AcntNameLookupDto.fromJson(Map<String, Object?> json) {
    final Map<String, Object?> responseData = ApiParser.asObjectMap(
      json['responseData'],
    );
    final Map<String, Object?> source = responseData.isEmpty
        ? json
        : responseData;

    return AcntNameLookupDto(
      responseCode: ApiParser.asNullableInt(json['responseCode']),
      responseDesc: ApiParser.asNullableString(json['responseDesc']),
      acntName: ApiParser.asNullableString(source['acntName']),
      maskedAcntName: ApiParser.asNullableString(source['maskedAcntName']),
    );
  }
}
