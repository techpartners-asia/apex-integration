import 'package:apex_mini_app_sdk/apex_mini_app_sdk.dart';
import 'package:dio/dio.dart';

/// Fully wired API runtime for one backend base URL.
class ApiRuntime {
  /// Runtime configuration.
  final ApiConfig config;

  /// Token source used by header builder.
  final TokenProvider tokenProvider;

  /// Dio-backed HTTP client.
  final ApiClient client;

  /// Header builder for every request.
  final ApiHeadersBuilder headersBuilder;

  /// Guarded request executor.
  final ApiExecutor executor;

  ApiRuntime._({
    required this.config,
    required this.tokenProvider,
    required this.client,
    required this.headersBuilder,
    required this.executor,
  });

  /// Creates a client, headers builder, optional refresh interceptor, and executor.
  factory ApiRuntime({
    required ApiConfig config,
    required TokenProvider tokenProvider,
    Future<String?> Function()? onRefreshSession,
    String tokenHeaderName = ApiHeaderNames.accessToken,
    bool useBearerToken = false,
    Dio? dio,
  }) {
    final ApiClient client = ApiClient(config: config, dio: dio);
    final ApiHeadersBuilder headersBuilder = ApiHeadersBuilder(
      credentials: config.credentials,
      tokenProvider: tokenProvider,
      tokenHeaderName: tokenHeaderName,
      useBearerToken: useBearerToken,
    );

    if (onRefreshSession != null) {
      client.dio.interceptors.add(
        SessionRefreshInterceptor(
          onRefreshSession: onRefreshSession,
          client: client,
        ),
      );
    }

    client.attachDebugLoggingInterceptor();

    return ApiRuntime._(
      config: config,
      tokenProvider: tokenProvider,
      client: client,
      headersBuilder: headersBuilder,
      executor: ApiExecutor(client: client, headersBuilder: headersBuilder),
    );
  }
}
