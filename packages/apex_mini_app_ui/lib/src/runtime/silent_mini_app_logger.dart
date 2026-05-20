import 'mini_app_logger.dart';

/// Logger implementation that intentionally drops every event.
class SilentMiniAppLogger implements MiniAppLogger {
  /// Creates a no-op logger.
  const SilentMiniAppLogger();

  /// Intentionally drops error events.
  @override
  void onError(
    String event, {
    Object? error,
    StackTrace? stackTrace,
    Map<String, Object?> data = const <String, Object?>{},
  }) {}

  /// Intentionally drops informational events.
  @override
  void onInfo(
    String event, {
    Map<String, Object?> data = const <String, Object?>{},
  }) {}
}
