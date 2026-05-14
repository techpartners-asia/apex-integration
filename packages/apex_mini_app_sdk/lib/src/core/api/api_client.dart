import 'dart:convert';

import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:flutter/foundation.dart';

import 'api_config.dart';

class ApiClient {
  final ApiConfig config;
  final Dio dio;
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

class _ApiDebugLogInterceptor extends Interceptor {
  const _ApiDebugLogInterceptor();

  static const JsonEncoder _encoder = JsonEncoder.withIndent('  ');
  static const int _chunkSize = 800;
  static const Set<String> _sensitiveKeys = <String>{
    'authorization',
    'cookie',
    'set-cookie',
    'access_token',
    'refresh_token',
    'token',
    'password',
    'adm_session',
    'session',
    'x-auth-token',
    'x-access-token',
  };

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    _printBlock(' ----- [API REQ] ----- ', <String>[
      '${options.method.toUpperCase()} ${options.uri}',
      // 'ContentType: ${options.contentType ?? options.headers['Content-Type'] ?? '-'}',
      // 'DataType: ${options.data.runtimeType}',
      'Headers: ${_formatValue(options.headers)}',
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

  void _printBlock(String prefix, List<String> lines) {
    final String block = '$prefix\n${lines.join('\n')}';
    for (int index = 0; index < block.length; index += _chunkSize) {
      final int end = index + _chunkSize > block.length
          ? block.length
          : index + _chunkSize;
      debugPrint(block.substring(index, end));
    }
  }

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

  bool _isSensitiveKey(String? key) {
    final String normalized = key?.trim().toLowerCase() ?? '';
    if (normalized.isEmpty) {
      return false;
    }

    return _sensitiveKeys.contains(normalized) ||
        normalized.contains('authorization') ||
        normalized.contains('token') ||
        normalized.contains('cookie') ||
        normalized.contains('password') ||
        normalized.contains('session');
  }
}

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
