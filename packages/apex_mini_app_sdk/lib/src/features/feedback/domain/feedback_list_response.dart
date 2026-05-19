import 'package:apex_mini_app_sdk/apex_mini_app_sdk_internal.dart';

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
