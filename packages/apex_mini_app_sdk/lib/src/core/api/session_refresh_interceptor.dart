import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import 'api_client.dart';
import 'api_header_names.dart';

class SessionRefreshInterceptor extends Interceptor {
  final Future<String?> Function() onRefreshSession;
  final ApiClient client;

  SessionRefreshInterceptor({
    required this.onRefreshSession,
    required this.client,
  });

  static const String retryHeader = ApiHeaderNames.retry;

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    final int? status = err.response?.statusCode;
    final bool isAuthError = status == 401 || status == 403;
    final bool alreadyRetried = err.requestOptions.headers.containsKey(
      retryHeader,
    );

    if (!isAuthError || alreadyRetried) {
      handler.next(err);
      return;
    }

    try {
      final String? newToken = await onRefreshSession();
      if (newToken == null || newToken.trim().isEmpty) {
        handler.next(err);
        return;
      }

      final RequestOptions retryOptions = err.requestOptions.copyWith(
        headers: <String, dynamic>{
          ...err.requestOptions.headers,
          ApiHeaderNames.accessToken: newToken,
          retryHeader: '1',
        },
      );

      final Response<dynamic> response = await client.dio.fetch<dynamic>(
        retryOptions,
      );
      handler.resolve(response);
    } catch (refreshError, stackTrace) {
      if (kDebugMode) {
        debugPrint(
          '[mini_app] session_refresh_failed: $refreshError',
        );
        debugPrintStack(stackTrace: stackTrace);
      }
      handler.next(err);
    }
  }
}
