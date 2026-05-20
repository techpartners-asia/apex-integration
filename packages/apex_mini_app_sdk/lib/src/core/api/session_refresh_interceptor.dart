import 'package:apex_mini_app_sdk/apex_mini_app_sdk.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

/// Dio interceptor that refreshes session token once for auth failures.
class SessionRefreshInterceptor extends Interceptor {
  /// Callback that returns a refreshed access token.
  final Future<String?> Function() onRefreshSession;

  /// API client used to retry the failed request.
  final ApiClient client;

  /// Creates a session refresh interceptor.
  SessionRefreshInterceptor({
    required this.onRefreshSession,
    required this.client,
  });

  /// Header marker used to prevent infinite retry loops.
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
