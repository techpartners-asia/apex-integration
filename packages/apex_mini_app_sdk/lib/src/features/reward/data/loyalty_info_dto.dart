/// DTO for the loyalty-info endpoint response body.
class LoyaltyInfoDto {
  /// Current streak count.
  final int streak;

  /// Card title from the backend.
  final String? title;

  /// Card body content from the backend.
  final String? content;

  /// Creates a loyalty info DTO.
  const LoyaltyInfoDto({
    required this.streak,
    this.title,
    this.content,
  });

  /// Parses the response from `{ "body": { "streak": ..., "title": ..., "content": ... } }`.
  factory LoyaltyInfoDto.fromJson(Map<String, Object?> json) {
    final Object? body = json['body'];
    if (body is! Map<String, Object?>) {
      return const LoyaltyInfoDto(streak: 0);
    }
    return LoyaltyInfoDto(
      streak: (body['streak'] as num?)?.toInt() ?? 0,
      title: body['title'] as String?,
      content: body['content'] as String?,
    );
  }
}
