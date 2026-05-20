import 'package:apex_mini_app_sdk/apex_mini_app_sdk.dart';

/// DTO for generic backend action responses.
class ActionResDto {
  /// Optional success message returned by the backend.
  final String? message;

  /// Creates a generic action response DTO.
  const ActionResDto({this.message});

  /// Parses and validates a backend action response.
  factory ActionResDto.fromJson(
    Map<String, Object?> json, {
    String failureMessage = 'Request failed.',
  }) {
    ApiActionResultParser.ensureSuccess(
      json,
      fallbackErrorMessage: failureMessage,
    );

    return ActionResDto(message: ApiActionResultParser.messageOf(json));
  }

  /// Converts this DTO to the domain action result.
  ActionRes toDomain() => ActionRes(message: message);
}
