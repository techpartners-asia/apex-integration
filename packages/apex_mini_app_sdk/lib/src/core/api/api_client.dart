import 'dart:convert';

import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:flutter/foundation.dart';

import 'api_config.dart';

/// Dio client wrapper that applies base options, cookies, and debug logging.
class ApiClient {
  /// HTTP configuration for this client.
  final ApiConfig config;

  /// Underlying Dio instance.
  final Dio dio;

  /// Cookie jar shared by Dio cookie manager.
  final CookieJar cookieJar;

  ApiClient({required this.config, Dio? dio, CookieJar? cookieJar})
    : dio = dio ?? Dio(),
      cookieJar = cookieJar ?? CookieJar() {
    this.dio.options = BaseOptions(
      baseUrl: config.baseUrl,
      connectTimeout: config.connectTimeout,
      sendTimeout: config.sendTimeout,
      receiveTimeout: config.receiveTimeout,
      responseType: ResponseType.json,
    );
    this.dio.interceptors.add(CookieManager(this.cookieJar));
  }

  /// Adds debug request/response logging once in debug builds.
  void attachDebugLoggingInterceptor() {
    if (!kDebugMode) {
      return;
    }
    final bool alreadyAttached = dio.interceptors.any(
      (Interceptor interceptor) => interceptor is _ApiDebugLogInterceptor,
    );
    if (!alreadyAttached) {
      dio.interceptors.add(const _ApiDebugLogInterceptor());
    }
  }
}

/// Debug-only Dio interceptor that prints sanitized request/response data.
class _ApiDebugLogInterceptor extends Interceptor {
  /// Creates the debug log interceptor.
  const _ApiDebugLogInterceptor();

  /// Pretty JSON encoder used for map/list payloads.
  static const JsonEncoder _encoder = JsonEncoder.withIndent('  ');

  /// Max debug-print chunk size to avoid truncation by the console.
  static const int _chunkSize = 800;

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    _printBlock(' ----- [API REQ] ----- ', <String>[
      '${options.method.toUpperCase()} ${options.uri}',
      // 'ContentType: ${options.contentType ?? options.headers['Content-Type'] ?? '-'}',
      // 'DataType: ${options.data.runtimeType}',
      // 'Headers: ${_formatValue(options.headers)}',
      // 'Query: ${_formatValue(options.queryParameters)}',
      'Body: ${_formatValue(options.data)}',
    ]);
    handler.next(options);
  }

  @override
  void onResponse(
    Response<dynamic> response,
    ResponseInterceptorHandler handler,
  ) {
    _printBlock(' ----- [API RES] ----- ', <String>[
      '${response.statusCode ?? '-'} ${response.requestOptions.method.toUpperCase()} ${response.requestOptions.uri}',
      // 'Headers: ${_formatValue(response.headers.map)}',
      'Body: ${_formatValue(response.data)}',
    ]);
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    _printBlock(' ----- [API ERR] ----- ', <String>[
      '${err.requestOptions.method.toUpperCase()} ${err.requestOptions.uri}',
      // 'ContentType: ${err.requestOptions.contentType ?? err.requestOptions.headers['Content-Type'] ?? '-'}',
      // 'DataType: ${err.requestOptions.data.runtimeType}',
      // 'Type: ${err.type}',
      // 'Status: ${err.response?.statusCode ?? '-'}',
      // 'Headers: ${_formatValue(err.response?.headers.map)}',
      'Body: ${_formatValue(err.response?.data)}',
      if (err.message case final String message when message.trim().isNotEmpty)
        'Message: $message',
      if (err.stackTrace case final StackTrace stackTrace)
        'StackTrace: $stackTrace',
    ]);
    handler.next(err);
  }

  /// Prints a multi-line log block in chunks.
  void _printBlock(String prefix, List<String> lines) {
    final String block = '$prefix\n${lines.join('\n')}';
    for (int index = 0; index < block.length; index += _chunkSize) {
      final int end = index + _chunkSize > block.length
          ? block.length
          : index + _chunkSize;
      debugPrint(block.substring(index, end));
    }
  }

  /// Sanitizes, truncates, and stringifies arbitrary request/response values.
  String _formatValue(Object? value) {
    final Object? sanitized = _truncateLongFields(_sanitizeValue(value));
    if (sanitized == null) {
      return 'null';
    }

    if (sanitized is String) {
      return sanitized;
    }

    try {
      return _encoder.convert(sanitized);
    } catch (_) {
      return sanitized.toString();
    }
  }

  /// Redacts sensitive values and converts [FormData] to safe metadata.
  Object? _sanitizeValue(Object? value, {String? key}) {

    if (value is FormData) {
      return <String, Object?>{
        'fields': value.fields
            .map(
              (MapEntry<String, String> entry) => MapEntry(
                entry.key,
                _sanitizeValue(entry.value, key: entry.key),
              ),
            )
            .toList(growable: false),
        'files': value.files
            .map(
              (MapEntry<String, MultipartFile> entry) => <String, Object?>{
                'field': entry.key,
                'filename': entry.value.filename,
                'length': entry.value.length,
              },
            )
            .toList(growable: false),
      };
    }

    if (value is Map) {
      return value.map(
        (Object? mapKey, Object? mapValue) => MapEntry(
          mapKey.toString(),
          _sanitizeValue(mapValue, key: mapKey.toString()),
        ),
      );
    }

    if (value is Iterable) {
      return value
          .map((Object? item) => _sanitizeValue(item))
          .toList(growable: false);
    }

    return value;
  }
}

/// Truncates large values before debug logging.
dynamic _truncateLongFields(dynamic value, {int maxStringLength = 500}) {
  if (value == null) return null;

  if (value is String) {
    final trimmed = value.trimLeft();
    final isMarkup =
        trimmed.startsWith('<!DOCTYPE html') ||
        trimmed.startsWith('<html') ||
        trimmed.startsWith('<?xml') ||
        trimmed.startsWith('<svg');

    final limit = isMarkup ? 400 : maxStringLength;

    if (value.length <= limit) return value;

    return '${value.substring(0, limit)} ... [truncated, total: ${value.length} chars]';
  }

  if (value is List) {
    return value
        .map(
          (item) => _truncateLongFields(item, maxStringLength: maxStringLength),
        )
        .toList();
  }

  if (value is Map) {
    return value.map(
      (key, val) => MapEntry(
        key,
        _truncateLongFields(val, maxStringLength: maxStringLength),
      ),
    );
  }

  return value;
}
