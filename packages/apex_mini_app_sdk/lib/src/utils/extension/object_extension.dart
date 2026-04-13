extension ObjectExtensions on Object? {
  bool get isNullOrEmpty =>
      this == null || this == '' || this == 'NULL' || this == 'null';

  bool get isNotNullOrEmpty => !isNullOrEmpty;

  bool get isNullEmptyOrFalse => this == null || this == '' || this == false;

  bool get isNullEmptyFalseOrZero =>
      this == null || this == '' || this == false || this == 0;

  bool get toBoolFromObj => int.tryParse(this?.toString() ?? '') == 1;

  // String get toStr => isNullOrEmpty ? '' : toString();

  String get toStr {
    final s = this?.toString().trim().toLowerCase();
    return (s == null || s == '' || s == 'null' || s == 'NULL')
        ? ''
        : toString();
  }
}
