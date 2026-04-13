import 'mini_app_logger.dart';

class SilentMiniAppLogger implements MiniAppLogger {
  const SilentMiniAppLogger();

  @override
  void onError(
    String event, {
    Object? error,
    StackTrace? stackTrace,
    Map<String, Object?> data = const <String, Object?>{},
  }) {}

  @override
  void onInfo(
    String event, {
    Map<String, Object?> data = const <String, Object?>{},
  }) {}
}
