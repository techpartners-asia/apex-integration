import 'package:apex_mini_app_sdk/apex_mini_app_sdk.dart';

/// Response DTO for login-session bootstrap.
class LoginSessionResponseDto {
  /// Protected API access token.
  final String accessToken;

  /// Optional customer token returned by backend.
  final String? customerToken;

  /// Creates a parsed login-session response DTO.
  const LoginSessionResponseDto({
    required this.accessToken,
    this.customerToken,
  });

  /// Parses and validates the login-session response.
  factory LoginSessionResponseDto.fromJson(Map<String, Object?> json) {
    final int responseCode = ApiParser.asNullableInt(json['responseCode']) ?? 1;
    if (responseCode != 0) {
      throw ApiBusinessException(
        responseCode: responseCode,
        message:
            ApiParser.asNullableString(json['responseDesc']) ??
            'Login session bootstrap failed.',
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

  /// Converts this DTO to the session domain model.
  LoginSession toDomain() {
    return LoginSession(accessToken: accessToken, customerToken: customerToken);
  }
}
