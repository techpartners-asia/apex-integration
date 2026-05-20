/// Null-safe list convenience getters.
extension ListExtensions<T> on List<T>? {
  /// Whether the list is null or empty.
  bool get isNullOrEmpty => this == null || this!.isEmpty;

  /// Whether the list is non-null and contains at least one item.
  bool get isNotNullOrEmpty => !isNullOrEmpty;
}
