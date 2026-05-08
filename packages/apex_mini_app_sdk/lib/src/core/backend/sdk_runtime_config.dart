import 'package:mini_app_sdk/mini_app_sdk.dart';

class SdkRuntimeConfig {
  final String techInvestXUrl;
  final String loginSessionBaseUrl;
  final String ipsApiBaseUrl;
  final AppCredentials credentials;
  final String? accessToken;
  final String defaultSrcFiCode;
  final String defaultFiCode;
  final String language;
  final bool enableDebugLogs;
  final String? neSession;

  const SdkRuntimeConfig({
    this.techInvestXUrl = '',
    required this.loginSessionBaseUrl,
    required this.ipsApiBaseUrl,
    required this.credentials,
    this.accessToken,
    this.defaultSrcFiCode = '181',
    this.defaultFiCode = '181',
    this.language = 'MN',
    this.enableDebugLogs = false,
    this.neSession,
  });

  factory SdkRuntimeConfig.fromConfig({
    String? baseUrl,
    String? techInvestXUrl,
    String? loginSessionBaseUrl,
    String? ipsApiBaseUrl,
    AppCredentials? credentials,
    String? appId,
    String? appSecret,
    String? accessToken,
    String? neSession,
    String? defaultSrcFiCode,
    String? defaultFiCode,
    String? language,
    bool? enableDebugLogs,
  }) {
    final String resolvedAppId = _nonBlank(appId) ?? StaticApiConfig.appId;
    final String resolvedAppSecret =
        _nonBlank(appSecret) ?? StaticApiConfig.appSecret;

    return SdkRuntimeConfig(
      techInvestXUrl:
          _nonBlank(techInvestXUrl) ??
          _nonBlank(baseUrl) ??
          StaticApiConfig.techInvestXUrl,
      loginSessionBaseUrl:
          _nonBlank(loginSessionBaseUrl) ?? StaticApiConfig.loginSessionBaseUrl,
      ipsApiBaseUrl: _nonBlank(ipsApiBaseUrl) ?? StaticApiConfig.ipsApiBaseUrl,
      credentials:
          credentials ??
          AppCredentials(
            appId: resolvedAppId,
            appSecret: resolvedAppSecret,
          ),
      accessToken: _nonBlank(accessToken),
      neSession: _nonBlank(neSession) ?? StaticApiConfig.neSession,
      defaultSrcFiCode:
          _nonBlank(defaultSrcFiCode) ?? StaticApiConfig.defaultSrcFiCode,
      defaultFiCode: _nonBlank(defaultFiCode) ?? StaticApiConfig.defaultFiCode,
      language: _nonBlank(language) ?? StaticApiConfig.defaultLanguage,
      enableDebugLogs: enableDebugLogs ?? false,
    );
  }

  bool get hasCredentials =>
      credentials.appId.trim().isNotEmpty &&
      credentials.appSecret.trim().isNotEmpty;

  bool get canFetchCurrentUser => hasCredentials && techInvestXUrl.isNotEmpty;

  bool get hasProtectedApi => hasCredentials && ipsApiBaseUrl.isNotEmpty;

  bool get canBootstrapSession =>
      hasProtectedApi &&
      loginSessionBaseUrl.isNotEmpty &&
      (neSession?.isNotEmpty ?? false);

  int get languageFlag => language.toUpperCase() == 'EN' ? 1 : 0;

  ApiRuntime? createCurrentUserRuntime({TokenProvider? tokenProvider}) {
    if (!canFetchCurrentUser) return null;

    return ApiRuntime(
      config: ApiConfig(
        baseUrl: techInvestXUrl,
        credentials: credentials,
        enableDebugLogs: enableDebugLogs,
      ),
      tokenProvider: tokenProvider ?? StaticTokenProvider(accessToken),
      tokenHeaderName: ApiHeaderNames.authorization,
      useBearerToken: true,
    );
  }

  /// Alias for [createCurrentUserRuntime] — uses the same TechInvestX
  /// base URL with Bearer auth.
  ApiRuntime? createTechInvestXProtectedRuntime({
    TokenProvider? tokenProvider,
  }) => createCurrentUserRuntime(tokenProvider: tokenProvider);

  ApiRuntime? createProtectedRuntime({
    TokenProvider? tokenProvider,
    Future<String?> Function()? onRefreshSession,
  }) {
    if (!hasProtectedApi) {
      return null;
    }
    return ApiRuntime(
      config: ApiConfig(
        baseUrl: ipsApiBaseUrl,
        credentials: credentials,
        enableDebugLogs: enableDebugLogs,
      ),
      tokenProvider: tokenProvider ?? StaticTokenProvider(accessToken),
      onRefreshSession: onRefreshSession,
    );
  }

  ApiRuntime? createSessionRuntime() {
    if (!canBootstrapSession) return null;

    return ApiRuntime(
      config: ApiConfig(
        baseUrl: loginSessionBaseUrl,
        credentials: credentials,
        enableDebugLogs: enableDebugLogs,
      ),
      tokenProvider: const StaticTokenProvider(null),
    );
  }

  static String? _nonBlank(String? value) {
    final String trimmed = value?.trim() ?? '';
    return trimmed.isEmpty ? null : trimmed;
  }
}
