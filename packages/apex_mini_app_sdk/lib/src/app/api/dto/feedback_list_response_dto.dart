import 'package:apex_mini_app_sdk/apex_mini_app_sdk.dart';

/// Response DTO for feedback history.
class FeedbackListResponseDto {
  /// Feedback rows.
  final List<FeedbackEntity> items;

  /// Total rows reported by backend.
  final int total;

  /// Optional backend message.
  final String? message;

  /// Creates a feedback list response DTO.
  const FeedbackListResponseDto({
    required this.items,
    required this.total,
    this.message,
  });

  /// Parses and validates feedback history response.
  factory FeedbackListResponseDto.fromJson(Map<String, Object?> json) {
    ApiActionResultParser.ensureSuccess(
      json,
      fallbackErrorMessage: 'Failed to load feedback history.',
    );

    final Map<String, Object?> body = ApiActionResultParser.bodyOf(json);
    final Map<String, Object?> source = body.isNotEmpty ? body : json;
    final List<FeedbackEntity> items = ApiParser.asObjectMapList(
      source['items'],
    ).map(FeedbackEntity.fromJson).toList(growable: false);

    return FeedbackListResponseDto(
      items: items,
      total: ApiParser.asNullableInt(source['total']) ?? items.length,
      message:
          ApiActionResultParser.messageOf(json) ??
          ApiParser.asNullableString(source['message']),
    );
  }

  /// Converts this DTO to the domain feedback list response.
  FeedbackListResponse toDomain() {
    return FeedbackListResponse(
      items: items,
      total: total,
      message: message,
    );
  }
}
