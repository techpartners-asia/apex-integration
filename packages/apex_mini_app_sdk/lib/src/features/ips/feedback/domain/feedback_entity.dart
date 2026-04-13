import '../../../../core/api/api_parser.dart';

class FeedbackStatus {
  static const pending = 'pending';
  static const resolved = 'resolved';
  static const closed = 'closed';
}

class FeedbackEntity {
  final int id;
  final String title;
  final String description;
  final String status;
  final String createdAt;
  final String updatedAt;
  final int userId;

  const FeedbackEntity({
    required this.id,
    required this.title,
    required this.description,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    required this.userId,
  });

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
