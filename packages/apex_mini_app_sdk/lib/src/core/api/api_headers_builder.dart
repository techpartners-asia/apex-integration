import '../token/token_provider.dart';

import 'app_credentials.dart';
import 'api_header_names.dart';

class ApiHeadersBuilder {
  final AppCredentials credentials;
  final TokenProvider tokenProvider;
  final String tokenHeaderName;
  final bool useBearerToken;

  const ApiHeadersBuilder({
    required this.credentials,
    required this.tokenProvider,
    this.tokenHeaderName = ApiHeaderNames.accessToken,
    this.useBearerToken = false,
  });

  Future<Map<String, String>> build({
    Map<String, String> extraHeaders = const <String, String>{},
    String? accessTokenOverride,
  }) async {
    final String? rawAccessToken =
        _normalize(accessTokenOverride) ??
        _normalize(await tokenProvider.getAccessToken());

    return <String, String>{
      ApiHeaderNames.accept: ApiContentTypes.json,
      ApiHeaderNames.appId: credentials.appId,
      ApiHeaderNames.appSecret: credentials.appSecret,
      if (rawAccessToken != null)
        tokenHeaderName: useBearerToken
            ? 'Bearer $rawAccessToken'
            : rawAccessToken,
      ...extraHeaders,
    }..removeWhere((String _, String value) => value.trim().isEmpty);
  }

  String? _normalize(String? value) {
    final String? trimmed = value?.trim();
    if (trimmed == null || trimmed.isEmpty) {
      return null;
    }
    return trimmed;
  }
}
