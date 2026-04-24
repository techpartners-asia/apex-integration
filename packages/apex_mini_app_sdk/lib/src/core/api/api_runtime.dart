import 'package:dio/dio.dart';
import 'package:mini_app_sdk/mini_app_sdk.dart';

class ApiRuntime {
  final ApiConfig config;
  final TokenProvider tokenProvider;
  final ApiClient client;
  final ApiHeadersBuilder headersBuilder;
  final ApiExecutor executor;

  ApiRuntime._({
    required this.config,
    required this.tokenProvider,
    required this.client,
    required this.headersBuilder,
    required this.executor,
  });

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
