/// Generic async status used by feature Cubits.
enum LoadableStatus { initial, loading, success, failure }

/// Generic immutable state for simple load/error/data flows.
class LoadableState<T> {
  /// Current load status.
  final LoadableStatus status;

  /// Loaded data.
  final T? data;

  /// User-facing error message.
  final String? errorMessage;

  /// Creates immutable loadable state.
  const LoadableState({
    this.status = LoadableStatus.initial,
    this.data,
    this.errorMessage,
  });

  /// Sentinel used by [copyWith] to distinguish omitted error text from null.
  static const Object sentinel = Object();

  /// Whether no load has started.
  bool get isInitial => status == LoadableStatus.initial;

  /// Whether a load is active.
  bool get isLoading => status == LoadableStatus.loading;

  /// Whether data loaded successfully.
  bool get isSuccess => status == LoadableStatus.success;

  /// Whether loading failed.
  bool get isFailure => status == LoadableStatus.failure;

  /// Copies state while allowing explicit null assignment for [errorMessage].
  LoadableState<T> copyWith({
    LoadableStatus? status,
    T? data,
    Object? errorMessage = sentinel,
  }) {
    return LoadableState<T>(
      status: status ?? this.status,
      data: data ?? this.data,
      errorMessage: errorMessage == sentinel
          ? this.errorMessage
          : errorMessage as String?,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is LoadableState<T> &&
        other.status == status &&
        other.data == data &&
        other.errorMessage == errorMessage;
  }

  @override
  int get hashCode => Object.hash(status, data, errorMessage);
}
