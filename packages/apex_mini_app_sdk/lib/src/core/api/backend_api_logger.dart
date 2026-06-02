import 'dart:async';

import 'package:dio/dio.dart';

import 'api_endpoints.dart';
import 'backend_logger_request_extra.dart';

/// Remote logger that posts API diagnostics to the Apex admin backend.
class BackendApiLogger {
  /// Creates a logger that posts to [baseUrl].
  BackendApiLogger({
    required String baseUrl,
    Dio? dio,
    Duration connectTimeout = const Duration(seconds: 5),
    Duration sendTimeout = const Duration(seconds: 5),
    Duration receiveTimeout = const Duration(seconds: 5),
  }) : _dio =
           dio ??
           Dio(
             BaseOptions(
               baseUrl: baseUrl,
               connectTimeout: connectTimeout,
               sendTimeout: sendTimeout,
               receiveTimeout: receiveTimeout,
               headers: const <String, String>{
                 Headers.contentTypeHeader: Headers.jsonContentType,
               },
             ),
           );

  final Dio _dio;

  static final Map<String, BackendApiLogger> _instances =
      <String, BackendApiLogger>{};

  /// Returns a shared logger for [baseUrl].
  factory BackendApiLogger.shared(String baseUrl) {
    return _instances.putIfAbsent(
      baseUrl,
      () => BackendApiLogger(baseUrl: baseUrl),
    );
  }

  /// Clears cached loggers (for tests).
  static void resetForTesting() {
    _instances.clear();
  }

  /// Sends one log entry without blocking the caller.
  void log({
    required String level,
    required String path,
    required String msg,
    required Map<String, Object?> info,
  }) {
    unawaited(
      _dio
          .post<void>(
            ApiEndpoints.loggerCreate,
            data: <String, Object?>{
              'level': level,
              'path': path,
              'msg': msg,
              'info': info,
            },
            options: Options(
              extra: const <String, Object?>{
                BackendLoggerRequestExtra.skip: true,
              },
            ),
          )
          .then((_) {}, onError: (_) {}),
    );
  }
}
