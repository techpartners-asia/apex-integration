import '../../../core/api/api_action_result_parser.dart';

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
