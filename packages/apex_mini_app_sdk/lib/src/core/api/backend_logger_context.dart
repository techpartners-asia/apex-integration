/// Optional context appended to backend logger messages (for example user id).
class BackendLoggerContext {
  BackendLoggerContext._();

  static String? Function()? _resolveMessageSuffix;

  /// Configures an optional suffix such as `userId: 184`.
  static void configure({String? Function()? resolveMessageSuffix}) {
    _resolveMessageSuffix = resolveMessageSuffix;
  }

  /// Resets global context (for tests).
  static void resetForTesting() {
    _resolveMessageSuffix = null;
  }

  /// Returns the configured suffix, if any.
  static String? messageSuffix() => _resolveMessageSuffix?.call();
}
