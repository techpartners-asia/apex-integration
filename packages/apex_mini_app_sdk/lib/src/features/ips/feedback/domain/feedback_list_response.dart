import 'feedback_entity.dart';

class FeedbackListResponse {
  final List<FeedbackEntity> items;
  final int total;
  final String? message;

  const FeedbackListResponse({
    required this.items,
    required this.total,
    this.message,
  });
}
