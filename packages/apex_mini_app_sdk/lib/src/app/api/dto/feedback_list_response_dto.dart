import 'package:mini_app_sdk/mini_app_sdk.dart';

class FeedbackListResponseDto {
  final List<FeedbackEntity> items;
  final int total;
  final String? message;

  const FeedbackListResponseDto({
    required this.items,
    required this.total,
    this.message,
  });

  factory FeedbackListResponseDto.fromJson(Map<String, Object?> json) {
    ApiActionResultParser.ensureSuccess(json, fallbackErrorMessage: 'Failed to load feedback history.');

    final Map<String, Object?> body = ApiActionResultParser.bodyOf(json);
    final Map<String, Object?> source = body.isNotEmpty ? body : json;
    final List<FeedbackEntity> items = ApiParser.asObjectMapList(source['items']).map(FeedbackEntity.fromJson).toList(growable: false);

    return FeedbackListResponseDto(
      items: items,
      total: ApiParser.asNullableInt(source['total']) ?? items.length,
      message: ApiActionResultParser.messageOf(json) ?? ApiParser.asNullableString(source['message']),
    );
  }

  FeedbackListResponse toDomain() {
    return FeedbackListResponse(
      items: items,
      total: total,
      message: message,
    );
  }
}
