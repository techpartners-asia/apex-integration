import '../../../../../core/api/api_action_result_parser.dart';
import '../../domain/models/ips_models.dart';

class ActionResDto {
  final String? message;

  const ActionResDto({this.message});

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

  ActionRes toDomain() => ActionRes(message: message);
}
