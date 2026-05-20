import 'package:apex_mini_app_sdk/apex_mini_app_sdk.dart';

/// Builds common Apex/IPS request headers.
class ApiHeadersBuilder {
  /// App id/secret pair.
  final AppCredentials credentials;

  /// Token source.
  final TokenProvider tokenProvider;

  /// Header key used for the token.
  final String tokenHeaderName;

  /// Whether token value should be prefixed with `Bearer`.
  final bool useBearerToken;

  /// Creates a backend header builder.
  const ApiHeadersBuilder({
    required this.credentials,
    required this.tokenProvider,
    this.tokenHeaderName = ApiHeaderNames.accessToken,
    this.useBearerToken = false,
  });

  /// Builds headers for one request.
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
