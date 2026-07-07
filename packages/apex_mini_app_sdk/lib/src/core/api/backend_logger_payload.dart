import 'package:dio/dio.dart';

import 'api_header_names.dart';

/// Builds sanitized request/response payloads for the remote backend logger.
abstract final class BackendLoggerPayload {
  static const Set<String> _sensitiveHeaderKeys = <String>{
    ApiHeaderNames.appSecret,
    ApiHeaderNames.authorization,
    ApiHeaderNames.accessToken,
    ApiHeaderNames.neSession,
    'password',
    'token',
  };

  static const Set<String> _sensitiveFieldKeys = <String>{
    'password',
    'token',
    'appsecret',
    'app_secret',
    'accesstoken',
    'access_token',
    'authorization',
    'adm_session',
    'nesession',
    'ne_session',
  };

  /// Request metadata and body for logger `info`.
  static Map<String, Object?> sanitizeRequest(RequestOptions options) {
    return <String, Object?>{
      'method': options.method,
      'uri': options.uri.toString(),
      'query': _sanitizeValue(options.queryParameters),
      'headers': _sanitizeHeaders(options.headers),
      'body': _sanitizeValue(options.data),
    };
  }

  /// Combined request/response payload for logger `info`.
  static Map<String, Object?> infoForRoundTrip({
    required RequestOptions options,
    required Object? responseData,
    int? statusCode,
    String? errorType,
    String? errorMessage,
  }) {
    return <String, Object?>{
      'request': sanitizeRequest(options),
      'response': <String, Object?>{
        'statusCode': ?statusCode,
        'errorType': ?errorType,
        if (errorMessage != null && errorMessage.trim().isNotEmpty)
          'message': errorMessage.trim(),
        'body': _sanitizeValue(responseData),
      },
    };
  }

  static Map<String, Object?> _sanitizeHeaders(Map<String, dynamic> headers) {
    return headers.map((String key, dynamic value) {
      if (_isSensitiveKey(key)) {
        return MapEntry(key, '[redacted]');
      }
      return MapEntry(key, value?.toString() ?? '');
    });
  }

  static Object? _sanitizeValue(Object? value, {String? key}) {
    if (value == null) {
      return null;
    }

    if (key != null && _isSensitiveKey(key)) {
      return '[redacted]';
    }

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

    if (value is String && value.length > 4000) {
      return '${value.substring(0, 4000)} ... [truncated, total: ${value.length} chars]';
    }

    return value;
  }

  static bool _isSensitiveKey(String key) {
    final String normalized = key.trim().toLowerCase();
    if (_sensitiveFieldKeys.contains(normalized)) {
      return true;
    }
    return _sensitiveHeaderKeys.any(
      (String candidate) => candidate.toLowerCase() == normalized,
    );
  }
}
