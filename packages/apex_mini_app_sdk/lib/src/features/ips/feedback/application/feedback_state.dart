import '../domain/feedback_entity.dart';

class FeedbackState {
  final bool isLoading;
  final bool isLoadingMore;
  final List<FeedbackEntity> items;
  final bool isSubmitting;
  final FeedbackEntity? lastCreated;
  final String? errorMessage;
  final int currentPage;
  final int total;
  final int pageSize;

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

  bool get hasMore => items.length < total;

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
