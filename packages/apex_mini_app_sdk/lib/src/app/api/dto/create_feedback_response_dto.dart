import 'package:apex_mini_app_sdk/apex_mini_app_sdk.dart';

/// Response DTO for feedback creation.
class CreateFeedbackResponseDto {
  /// Optional backend message.
  final String? message;

  /// Created feedback entity.
  final FeedbackEntity entity;

  /// Creates a feedback creation response DTO.
  const CreateFeedbackResponseDto({this.message, required this.entity});

  /// Parses and validates the feedback creation response.
  factory CreateFeedbackResponseDto.fromJson(Map<String, Object?> json) {
    ApiActionResultParser.ensureSuccess(
      json,
      fallbackErrorMessage: 'Failed to submit feedback.',
    );

    final Map<String, Object?> body = ApiActionResultParser.bodyOf(json);

    return CreateFeedbackResponseDto(
      message: ApiActionResultParser.messageOf(json),
      entity: FeedbackEntity.fromJson(body),
    );
  }
}
