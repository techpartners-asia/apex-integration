enum LoadableStatus { initial, loading, success, failure }

class LoadableState<T> {
  final LoadableStatus status;
  final T? data;
  final String? errorMessage;

  const LoadableState({
    this.status = LoadableStatus.initial,
    this.data,
    this.errorMessage,
  });

  static const Object sentinel = Object();

  bool get isInitial => status == LoadableStatus.initial;

  bool get isLoading => status == LoadableStatus.loading;

  bool get isSuccess => status == LoadableStatus.success;

  bool get isFailure => status == LoadableStatus.failure;

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
