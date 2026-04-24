import 'package:mini_app_sdk/mini_app_sdk.dart';

class CreateFeedbackResponseDto {
  final String? message;
  final FeedbackEntity entity;

  const CreateFeedbackResponseDto({this.message, required this.entity});

  factory CreateFeedbackResponseDto.fromJson(Map<String, Object?> json) {
    ApiActionResultParser.ensureSuccess(json, fallbackErrorMessage: 'Failed to submit feedback.');

    final Map<String, Object?> body = ApiActionResultParser.bodyOf(json);

    return CreateFeedbackResponseDto(
      message: ApiActionResultParser.messageOf(json),
      entity: FeedbackEntity.fromJson(body),
    );
  }
}
