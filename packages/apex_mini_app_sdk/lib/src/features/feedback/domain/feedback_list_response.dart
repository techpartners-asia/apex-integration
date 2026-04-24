import 'package:mini_app_sdk/mini_app_sdk.dart';

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
