abstract class MiniAppLogger {
  const MiniAppLogger();

  void onError(
    String event, {
    Object? error,
    StackTrace? stackTrace,
    Map<String, Object?> data = const <String, Object?>{},
  });

  void onInfo(
    String event, {
    Map<String, Object?> data = const <String, Object?>{},
  });
}
