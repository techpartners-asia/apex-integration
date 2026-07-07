import 'package:apex_mini_app_sdk/apex_mini_app_sdk.dart';
import 'package:dio/dio.dart';

import '../../host/apex_mini_app_host_context.dart';

/// Guarded HTTP request executor used by repositories and backend API clients.
class ApiExecutor {
  /// Dio client wrapper.
  final ApiClient client;

  /// Builds app/token headers per request.
  final ApiHeadersBuilder headersBuilder;

  /// Creates an API executor for JSON backend requests.
  const ApiExecutor({required this.client, required this.headersBuilder});

  /// Sends a JSON POST and parses a JSON object response.
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

  /// Sends a GET and returns the raw response body as a string.
  Future<String> getString(
    String path, {
    ReqContext context = const ReqContext(),
  }) async {
    return _runGuarded(
      path,
      context: context,
      action: () async =>
          (await get(path, context: context)).data?.toString() ?? '',
    );
  }

  /// Sends a GET and parses a JSON object response.
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

  /// Sends a GET and parses a JSON list response.
  Future<List<Object?>> getJsonList(
    String path, {
    Map<String, Object?> queryParameters = const <String, Object?>{},
    ReqContext context = const ReqContext(),
  }) async {
    return _runGuarded(
      path,
      context: context,
      action: () async => asJsonList(
        (await get(
          path,
          queryParameters: queryParameters,
          context: context,
        )).data,
      ),
    );
  }

  /// Sends a JSON PUT and parses a JSON object response.
  Future<Map<String, Object?>> putJson(
    String path, {
    required Map<String, Object?> body,
    ReqContext context = const ReqContext(),
  }) async {
    return _runGuarded(
      path,
      context: context,
      action: () async {
        final Object? data = (await put(
          path,
          body: body,
          context: context,
          contentType: Headers.jsonContentType,
        )).data;
        if (data == null || data is String && data.trim().isEmpty) {
          return const <String, Object?>{};
        }
        return asJsonMap(data);
      },
    );
  }

  /// Sends multipart/form data through PUT and parses a JSON object response.
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

  /// Sends a JSON POST and parses a typed API envelope response.
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

  /// Sends a raw POST using built headers.
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
      options: Options(
        headers: headers,
        contentType: contentType,
        extra: _loggerExtra(context),
      ),
    );
  }

  /// Sends a raw PUT using built headers.
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
      options: Options(
        headers: headers,
        contentType: contentType,
        extra: _loggerExtra(context),
      ),
    );
  }

  /// Sends a raw GET using built headers.
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
      options: Options(headers: headers, extra: _loggerExtra(context)),
    );
  }

  Map<String, Object?> _loggerExtra(ReqContext context) {
    final String? operName = context.operName?.trim();
    if (operName == null || operName.isEmpty) {
      return const <String, Object?>{};
    }
    return <String, Object?>{
      BackendLoggerRequestExtra.operName: operName,
    };
  }

  /// Parses [raw] as a JSON object.
  Map<String, Object?> asJsonMap(Object? raw) {
    if (raw is! Map) {
      throw const ApiParsingException('Expected JSON object response.');
    }
    return raw.map(
      (Object? key, Object? value) => MapEntry(key.toString(), value),
    );
  }

  /// Parses [raw] as a JSON array, also supporting envelope `body` arrays.
  List<Object?> asJsonList(Object? raw) {
    final Object? value;

    if (raw is Map<String, Object?>) {
      value = raw['body'];
    } else {
      value = raw;
    }

    if (value is! List) {
      throw const ApiParsingException('Expected JSON array response.');
    }

    return value.cast<Object?>().toList(growable: false);
  }

  /// Maps Dio failures into SDK API exceptions and host-visible callbacks.
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
      final ApiUnauthorizedException exception = ApiUnauthorizedException(
        serverMessage ?? 'Authentication failed for $operName.',
        cause: error,
        stackTrace: stackTrace,
      );
      ApexMiniAppHostContext.emitTokenExpired();
      ApexMiniAppHostContext.emitError(exception, stackTrace);
      return exception;
    }
    if (error.type == DioExceptionType.connectionTimeout ||
        error.type == DioExceptionType.sendTimeout ||
        error.type == DioExceptionType.receiveTimeout) {
      final ApiNetworkException exception = ApiNetworkException(
        'Req timed out for $operName.',
        cause: error,
        stackTrace: stackTrace,
      );
      ApexMiniAppHostContext.emitError(exception, stackTrace);
      return exception;
    }

    if (statusCode != null) {
      if (serverMessage != null && serverMessage.isNotEmpty) {
        final ApiBusinessException exception = ApiBusinessException(
          responseCode: _businessCodeFrom(error.response?.data) ?? statusCode,
          message: serverMessage,
          cause: error,
          stackTrace: stackTrace,
        );
        if (statusCode >= 500 && statusCode != 504) {
          ApexMiniAppHostContext.emitError(exception, stackTrace);
        }
        return exception;
      }

      final ApiNetworkException exception = ApiNetworkException(
        'HTTP $statusCode for $operName.',
        cause: error,
        stackTrace: stackTrace,
      );
      if (statusCode >= 500 && statusCode != 504) {
        ApexMiniAppHostContext.emitError(exception, stackTrace);
      }
      return exception;
    }

    final ApiNetworkException exception = ApiNetworkException(
      'Network req failed for $operName.',
      cause: error,
      stackTrace: stackTrace,
    );
    ApexMiniAppHostContext.emitError(exception, stackTrace);
    return exception;
  }

  /// Extracts a readable backend error message from varied response shapes.
  String? extractServerMessage(Object? raw) {
    return ApiResponseMessageParser.extract(raw);
  }

  int? _businessCodeFrom(Object? raw) {
    if (raw is! Map) {
      return null;
    }

    return ApiParser.asNullableInt(raw['code']);
  }

  /// Runs [action] and normalizes known network/parsing/runtime failures.
  Future<T> _runGuarded<T>(
    String path, {
    required ReqContext context,
    required Future<T> Function() action,
  }) async {
    try {
      return await action();
    } on DioException catch (error, stackTrace) {
      throw mapDioException(path, context, error, stackTrace);
    } on ApiParsingException catch (error, stackTrace) {
      ApexMiniAppHostContext.emitError(error, stackTrace);
      rethrow;
    } on ApiException {
      rethrow;
    } catch (error, stackTrace) {
      final ApiUnknownException exception = ApiUnknownException(
        'Unexpected error during ${context.operName ?? path}.',
        cause: error,
        stackTrace: stackTrace,
      );
      ApexMiniAppHostContext.emitError(exception, stackTrace);
      throw exception;
    }
  }
}
