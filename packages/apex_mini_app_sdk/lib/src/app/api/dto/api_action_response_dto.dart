import 'package:apex_mini_app_sdk/apex_mini_app_sdk.dart';

/// Generic action response DTO for endpoints that return message/body only.
class ApiActionResponseDto {
  /// Optional backend message.
  final String? message;

  /// Optional backend body map.
  final Map<String, Object?> body;

  /// Creates a generic action response DTO.
  const ApiActionResponseDto({
    this.message,
    this.body = const <String, Object?>{},
  });

  /// Parses and validates a generic action response.
  factory ApiActionResponseDto.fromJson(
    Map<String, Object?> json, {
    String failureMessage = 'Request failed.',
  }) {
    ApiActionResultParser.ensureSuccess(
      json,
      fallbackErrorMessage: failureMessage,
    );

    return ApiActionResponseDto(
      message: ApiActionResultParser.messageOf(json),
      body: ApiActionResultParser.bodyOf(json),
    );
  }
}
