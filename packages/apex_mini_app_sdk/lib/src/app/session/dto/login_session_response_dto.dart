import 'package:mini_app_sdk/mini_app_sdk.dart';

class LoginSessionResponseDto {
  final String accessToken;
  final String? customerToken;

  const LoginSessionResponseDto({
    required this.accessToken,
    this.customerToken,
  });

  factory LoginSessionResponseDto.fromJson(Map<String, Object?> json) {
    final int responseCode = ApiParser.asNullableInt(json['responseCode']) ?? 1;
    if (responseCode != 0) {
      throw ApiBusinessException(
        responseCode: responseCode,
        message: ApiParser.asNullableString(json['responseDesc']) ?? 'Login session bootstrap failed.',
      );
    }

    final String? accessToken = ApiParser.asNullableString(json['accessToken']);
    if (accessToken == null || accessToken.trim().isEmpty) {
      throw const ApiParsingException(
        'getLoginSession returned success without an accessToken.',
      );
    }

    return LoginSessionResponseDto(
      accessToken: accessToken,
      customerToken: ApiParser.asNullableString(json['custToken']),
    );
  }

  LoginSession toDomain() {
    return LoginSession(accessToken: accessToken, customerToken: customerToken);
  }
}
