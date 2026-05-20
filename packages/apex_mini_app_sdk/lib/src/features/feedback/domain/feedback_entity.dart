import 'package:apex_mini_app_sdk/apex_mini_app_sdk.dart';

/// Backend feedback status values.
class FeedbackStatus {
  /// Feedback has been submitted and is waiting for action.
  static const pending = 'pending';

  /// Feedback has been resolved by support.
  static const resolved = 'resolved';

  /// Feedback ticket is closed.
  static const closed = 'closed';
}

/// Support feedback item shown in the feedback list.
class FeedbackEntity {
  /// Feedback identifier.
  final int id;

  /// Feedback title.
  final String title;

  /// Feedback body text.
  final String description;

  /// Backend status value.
  final String status;

  /// Raw creation timestamp.
  final String createdAt;

  /// Raw update timestamp.
  final String updatedAt;

  /// Owning user identifier.
  final int userId;

  /// Creates a support feedback domain item.
  const FeedbackEntity({
    required this.id,
    required this.title,
    required this.description,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    required this.userId,
  });

  /// Parses feedback JSON with empty defaults for missing backend values.
  factory FeedbackEntity.fromJson(Map<String, Object?> json) {
    return FeedbackEntity(
      id: ApiParser.asNullableInt(json['id']) ?? 0,
      title: ApiParser.asNullableString(json['title']) ?? '',
      description: ApiParser.asNullableString(json['description']) ?? '',
      status: ApiParser.asNullableString(json['status']) ?? '',
      createdAt: ApiParser.asNullableString(json['created_at']) ?? '',
      updatedAt: ApiParser.asNullableString(json['updated_at']) ?? '',
      userId: ApiParser.asNullableInt(json['user_id']) ?? 0,
    );
  }
}
