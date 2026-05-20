import 'package:apex_mini_app_sdk/apex_mini_app_sdk.dart';

/// Response DTO for resolving an account holder name by account code.
class AcntNameLookupDto {
  /// Backend response code.
  final int? responseCode;

  /// Backend response description.
  final String? responseDesc;

  /// Resolved account holder name.
  final String? acntName;

  /// Masked account holder name.
  final String? maskedAcntName;

  /// Creates an account-name lookup DTO.
  const AcntNameLookupDto({
    this.responseCode,
    this.responseDesc,
    this.acntName,
    this.maskedAcntName,
  });

  /// Parses both direct and `responseData`-wrapped lookup payloads.
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
