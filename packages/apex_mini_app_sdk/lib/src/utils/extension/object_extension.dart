/// Null-safe object helpers for loosely typed backend values.
extension ObjectExtensions on Object? {
  /// Whether the object is null, empty string, or a literal null marker.
  bool get isNullOrEmpty =>
      this == null || this == '' || this == 'NULL' || this == 'null';

  /// Whether the object contains a meaningful value.
  bool get isNotNullOrEmpty => !isNullOrEmpty;

  /// Whether the object is null, empty, or false.
  bool get isNullEmptyOrFalse => this == null || this == '' || this == false;

  /// Whether the object is null, empty, false, or zero.
  bool get isNullEmptyFalseOrZero =>
      this == null || this == '' || this == false || this == 0;

  /// Converts numeric-like `1` values to true.
  bool get toBoolFromObj => int.tryParse(this?.toString() ?? '') == 1;

  // String get toStr => isNullOrEmpty ? '' : toString();

  /// Returns a trimmed string while treating null markers as empty.
  String get toStr {
    final s = this?.toString().trim().toLowerCase();
    return (s == null || s == '' || s == 'null' || s == 'NULL')
        ? ''
        : toString();
  }
}
