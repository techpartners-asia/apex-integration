import '../../../core/api/api_action_result_parser.dart';
import '../../../features/ips/feedback/domain/feedback_entity.dart';

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
