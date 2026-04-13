import 'package:dio/dio.dart';
import '../exception/api_exception.dart';

import 'api_client.dart';
import 'api_envelope.dart';
import 'api_headers_builder.dart';
import 'req_context.dart';

class ApiExecutor {
  final ApiClient client;
  final ApiHeadersBuilder headersBuilder;

  const ApiExecutor({required this.client, required this.headersBuilder});

  Future<Map<String, Object?>> postJson(
    String path, {
    required Map<String, Object?> body,
    ReqContext context = const ReqContext(),
  }) async {
    return _runGuarded(
      path,
      context: context,
      action: () async => asJsonMap(
        (await post(
          path,
          body: body,
          context: context,
          contentType: Headers.jsonContentType,
        )).data,
      ),
    );
  }

  Future<Map<String, Object?>> getJson(
    String path, {
    Map<String, Object?> queryParameters = const <String, Object?>{},
    ReqContext context = const ReqContext(),
  }) async {
    return _runGuarded(
      path,
      context: context,
      action: () async => asJsonMap(
        (await get(
          path,
          queryParameters: queryParameters,
          context: context,
        )).data,
      ),
    );
  }

  Future<Map<String, Object?>> putJson(
    String path, {
    required Map<String, Object?> body,
    ReqContext context = const ReqContext(),
  }) async {
    return _runGuarded(
      path,
      context: context,
      action: () async => asJsonMap(
        (await put(
          path,
          body: body,
          context: context,
          contentType: Headers.jsonContentType,
        )).data,
      ),
    );
  }

  Future<Map<String, Object?>> putFormData(
    String path, {
    required FormData body,
    ReqContext context = const ReqContext(),
  }) async {
    return _runGuarded(
      path,
      context: context,
      action: () async => asJsonMap(
        (await put(path, body: body, context: context)).data,
      ),
    );
  }

  Future<ApiEnvelope<T>> postEnvelope<T>(
    String path, {
    required Map<String, Object?> body,
    required T Function(Object? raw) mapper,
    ReqContext context = const ReqContext(),
  }) async {
    return _runGuarded(
      path,
      context: context,
      action: () async {
        final Map<String, Object?> json = asJsonMap(
          (await post(
            path,
            body: body,
            context: context,
            contentType: Headers.jsonContentType,
          )).data,
        );
        final ApiEnvelope<T> envelope = ApiEnvelope<T>.fromJson(json, mapper);
        envelope.ensureSuccess();
        return envelope;
      },
    );
  }

  Future<Response<dynamic>> post(
    String path, {
    required Object body,
    required ReqContext context,
    String? contentType,
  }) async {
    final Map<String, String> headers = await headersBuilder.build(
      extraHeaders: context.extraHeaders,
      accessTokenOverride: context.accessTokenOverride,
    );
    return client.dio.post<dynamic>(
      path,
      data: body,
      options: Options(headers: headers, contentType: contentType),
    );
  }

  Future<Response<dynamic>> put(
    String path, {
    required Object body,
    required ReqContext context,
    String? contentType,
  }) async {
    final Map<String, String> headers = await headersBuilder.build(
      extraHeaders: context.extraHeaders,
      accessTokenOverride: context.accessTokenOverride,
    );
    return client.dio.put<dynamic>(
      path,
      data: body,
      options: Options(headers: headers, contentType: contentType),
    );
  }

  Future<Response<dynamic>> get(
    String path, {
    required ReqContext context,
    Map<String, Object?> queryParameters = const <String, Object?>{},
  }) async {
    final Map<String, String> headers = await headersBuilder.build(
      extraHeaders: context.extraHeaders,
      accessTokenOverride: context.accessTokenOverride,
    );
    return client.dio.get<dynamic>(
      path,
      queryParameters: queryParameters,
      options: Options(headers: headers),
    );
  }

  Map<String, Object?> asJsonMap(Object? raw) {
    if (raw is! Map) {
      throw const ApiParsingException('Expected JSON object response.');
    }
    return raw.map(
      (Object? key, Object? value) => MapEntry(key.toString(), value),
    );
  }

  ApiException mapDioException(
    String path,
    ReqContext context,
    DioException error,
    StackTrace stackTrace,
  ) {
    final int? statusCode = error.response?.statusCode;
    final String operName = context.operName ?? path;
    final String? serverMessage = extractServerMessage(error.response?.data);

    if (statusCode == 401 || statusCode == 403) {
      return ApiUnauthorizedException(
        serverMessage ?? 'Authentication failed for $operName.',
        cause: error,
        stackTrace: stackTrace,
      );
    }
    if (error.type == DioExceptionType.connectionTimeout ||
        error.type == DioExceptionType.sendTimeout ||
        error.type == DioExceptionType.receiveTimeout) {
      return ApiNetworkException(
        'Req timed out for $operName.',
        cause: error,
        stackTrace: stackTrace,
      );
    }

    if (statusCode != null) {
      if (serverMessage != null && serverMessage.isNotEmpty) {
        return ApiBusinessException(
          responseCode: statusCode,
          message: serverMessage,
          cause: error,
          stackTrace: stackTrace,
        );
      }

      return ApiNetworkException(
        'HTTP $statusCode for $operName.',
        cause: error,
        stackTrace: stackTrace,
      );
    }

    return ApiNetworkException(
      'Network req failed for $operName.',
      cause: error,
      stackTrace: stackTrace,
    );
  }

  String? extractServerMessage(Object? raw) {
    return _extractServerMessage(raw);
  }

  String? _extractServerMessage(Object? raw, {int depth = 0}) {
    if (depth > 3) {
      return null;
    }

    if (raw is String) {
      return _normalizeServerMessage(raw);
    }

    if (raw is Iterable) {
      for (final Object? item in raw) {
        final String? message = _extractServerMessage(item, depth: depth + 1);
        if (message != null) {
          return message;
        }
      }
      return null;
    }

    if (raw is Map) {
      final Map<String, Object?> json = raw.map(
        (Object? key, Object? value) => MapEntry(key.toString(), value),
      );

      const List<String> messageKeys = <String>[
        'responseDesc',
        'message',
        'errorMessage',
        'error_description',
        'error',
        'detail',
        'title',
        'body',
        'errors',
      ];

      for (final String key in messageKeys) {
        final String? message = _extractServerMessage(
          json[key],
          depth: depth + 1,
        );
        if (message != null) {
          return message;
        }
      }
    }

    return null;
  }

  String? _normalizeServerMessage(String? raw) {
    final String value = raw?.trim() ?? '';
    if (value.isEmpty) {
      return null;
    }
    return value.length > 200 ? '${value.substring(0, 200)}…' : value;
  }

  Future<T> _runGuarded<T>(
    String path, {
    required ReqContext context,
    required Future<T> Function() action,
  }) async {
    try {
      return await action();
    } on DioException catch (error, stackTrace) {
      throw mapDioException(path, context, error, stackTrace);
    } on ApiException {
      rethrow;
    } catch (error, stackTrace) {
      throw ApiUnknownException(
        'Unexpected error during ${context.operName ?? path}.',
        cause: error,
        stackTrace: stackTrace,
      );
    }
  }
}
