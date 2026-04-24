import 'package:flutter_test/flutter_test.dart';
import 'package:mini_app_sdk/mini_app_sdk.dart';

void main() {
  const credentials = AppCredentials(appId: 'app-id', appSecret: 'app-secret');

  test('build adds bearer authorization header from trimmed token', () async {
    final builder = ApiHeadersBuilder(
      credentials: credentials,
      tokenProvider: const StaticTokenProvider('  token-value  '),
      tokenHeaderName: ApiHeaderNames.authorization,
      useBearerToken: true,
    );

    final headers = await builder.build();

    expect(headers[ApiHeaderNames.authorization], 'Bearer token-value');
  });

  test(
    'build skips invalid bearer authorization header for blank token',
    () async {
      final builder = ApiHeadersBuilder(
        credentials: credentials,
        tokenProvider: const StaticTokenProvider('   '),
        tokenHeaderName: ApiHeaderNames.authorization,
        useBearerToken: true,
      );

      final headers = await builder.build();

      expect(headers.containsKey(ApiHeaderNames.authorization), isFalse);
    },
  );

  test('build does not force content type headers', () async {
    final builder = ApiHeadersBuilder(
      credentials: credentials,
      tokenProvider: const StaticTokenProvider('token-value'),
      tokenHeaderName: ApiHeaderNames.authorization,
      useBearerToken: true,
    );

    final headers = await builder.build();

    expect(headers.containsKey(ApiHeaderNames.contentType), isFalse);
    expect(headers[ApiHeaderNames.accept], ApiContentTypes.json);
  });
}
