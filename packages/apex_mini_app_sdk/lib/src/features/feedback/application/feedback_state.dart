import 'package:apex_mini_app_sdk/apex_mini_app_sdk.dart';

/// UI state for feedback list and create-feedback form.
class FeedbackState {
  /// Whether the first page is loading.
  final bool isLoading;

  /// Whether a later page is loading.
  final bool isLoadingMore;

  /// Loaded feedback items.
  final List<FeedbackEntity> items;

  /// Whether create feedback request is running.
  final bool isSubmitting;

  /// Last created feedback item, used as one-shot success feedback.
  final FeedbackEntity? lastCreated;

  /// User-facing error message.
  final String? errorMessage;

  /// Current loaded page.
  final int currentPage;

  /// Total item count reported by backend.
  final int total;

  /// Requested page size.
  final int pageSize;

  /// Creates feedback UI state.
  const FeedbackState({
    this.isLoading = false,
    this.isLoadingMore = false,
    this.items = const <FeedbackEntity>[],
    this.isSubmitting = false,
    this.lastCreated,
    this.errorMessage,
    this.currentPage = 0,
    this.total = 0,
    this.pageSize = 10,
  });

  static const Object _sentinel = Object();

  /// Whether more feedback pages are available.
  bool get hasMore => items.length < total;

  /// Copies state while allowing explicit null assignment for nullable fields.
  FeedbackState copyWith({
    bool? isLoading,
    bool? isLoadingMore,
    List<FeedbackEntity>? items,
    bool? isSubmitting,
    Object? lastCreated = _sentinel,
    Object? errorMessage = _sentinel,
    int? currentPage,
    int? total,
    int? pageSize,
  }) {
    return FeedbackState(
      isLoading: isLoading ?? this.isLoading,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      items: items ?? this.items,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      lastCreated: lastCreated == _sentinel
          ? this.lastCreated
          : lastCreated as FeedbackEntity?,
      errorMessage: errorMessage == _sentinel
          ? this.errorMessage
          : errorMessage as String?,
      currentPage: currentPage ?? this.currentPage,
      total: total ?? this.total,
      pageSize: pageSize ?? this.pageSize,
    );
  }
}
