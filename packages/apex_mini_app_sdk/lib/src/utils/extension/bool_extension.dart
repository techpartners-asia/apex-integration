/// Null-safe boolean helpers.
extension SafeBoolExtension on bool? {
  /// Returns false when this value is null.
  bool get trueOrFalse => this ?? false;
}
