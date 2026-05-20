/// Logger abstraction used by the runtime without binding to a logging package.
abstract class MiniAppLogger {
  /// Creates a logger implementation.
  const MiniAppLogger();

  /// Records an error event with optional exception, stack, and structured data.
  void onError(
    String event, {
    Object? error,
    StackTrace? stackTrace,
    Map<String, Object?> data = const <String, Object?>{},
  });

  /// Records an informational event with optional structured data.
  void onInfo(
    String event, {
    Map<String, Object?> data = const <String, Object?>{},
  });
}
