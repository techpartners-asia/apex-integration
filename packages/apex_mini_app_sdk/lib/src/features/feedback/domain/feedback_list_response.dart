import 'package:apex_mini_app_sdk/apex_mini_app_sdk.dart';

/// Paged feedback list response used by the feedback UI.
class FeedbackListResponse {
  /// Feedback entries in the current page.
  final List<FeedbackEntity> items;

  /// Total feedback count reported by the backend.
  final int total;

  /// Optional backend message.
  final String? message;

  /// Creates a feedback list response.
  const FeedbackListResponse({
    required this.items,
    required this.total,
    this.message,
  });
}
