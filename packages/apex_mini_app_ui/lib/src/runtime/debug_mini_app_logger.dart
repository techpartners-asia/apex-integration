import 'package:flutter/foundation.dart';

import 'mini_app_logger.dart';

/// Logger that prints diagnostics via [debugPrint] in debug builds only.
/// In release builds all calls are no-ops (the [kDebugMode] constant-folds
/// the branches away).
class DebugMiniAppLogger implements MiniAppLogger {
  const DebugMiniAppLogger();

  @override
  void onError(
    String event, {
    Object? error,
    StackTrace? stackTrace,
    Map<String, Object?> data = const <String, Object?>{},
  }) {
    if (kDebugMode) {
      final StringBuffer buffer = StringBuffer('[mini_app] ERROR $event');
      if (error != null) {
        buffer.write(': $error');
      }
      if (data.isNotEmpty) {
        buffer.write(' $data');
      }
      debugPrint(buffer.toString());
      if (stackTrace != null) {
        debugPrintStack(stackTrace: stackTrace);
      }
    }
  }

  @override
  void onInfo(
    String event, {
    Map<String, Object?> data = const <String, Object?>{},
  }) {
    if (kDebugMode) {
      if (data.isNotEmpty) {
        debugPrint('[mini_app] $event $data');
      } else {
        debugPrint('[mini_app] $event');
      }
    }
  }
}
