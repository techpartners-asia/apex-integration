import 'package:mini_app_sdk/mini_app_sdk.dart';

class ApiActionResponseDto {
  final String? message;
  final Map<String, Object?> body;

  const ApiActionResponseDto({this.message, this.body = const <String, Object?>{}});

  factory ApiActionResponseDto.fromJson(Map<String, Object?> json, {String failureMessage = 'Request failed.'}) {
    ApiActionResultParser.ensureSuccess(json, fallbackErrorMessage: failureMessage);

    return ApiActionResponseDto(
      message: ApiActionResultParser.messageOf(json),
      body: ApiActionResultParser.bodyOf(json),
    );
  }
}
