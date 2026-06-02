import 'package:apex_mini_app_sdk/apex_mini_app_sdk.dart';

/// Runtime backend configuration for all Apex mini-app API clients.
class SdkRuntimeConfig {
  /// TechInvestX base URL used for profile/current-user APIs.
  final String techInvestXUrl;

  /// Login-session API base URL.
  final String loginSessionBaseUrl;

  /// IPS protected API base URL.
  final String ipsApiBaseUrl;

  /// Application credentials sent with API requests.
  final AppCredentials credentials;

  /// Whether built-in backend defaults point to legacy development services.
  final bool devMode;

  /// Optional access token supplied by host/session.
  final String? accessToken;

  /// Default source FI code used when a flow does not provide one.
  final String defaultSrcFiCode;

  /// Default FI code used by account-opening APIs.
  final String defaultFiCode;

  /// Runtime language code.
  final String language;

  /// Whether API clients should log request/response diagnostics.
  final bool enableDebugLogs;

  /// NE session value used by login-session bootstrap.
  final String? neSession;

  /// Creates concrete runtime API configuration.
  SdkRuntimeConfig({
    this.techInvestXUrl = '',
    required this.loginSessionBaseUrl,
    required this.ipsApiBaseUrl,
    required this.credentials,
    this.devMode = false,
    this.accessToken,
    String? defaultSrcFiCode,
    String? defaultFiCode,
    this.language = 'MN',
    this.enableDebugLogs = false,
    this.neSession,
  }) : defaultSrcFiCode =
           defaultSrcFiCode ??
           StaticApiConfig.defaultSrcFiCodeForDevMode(devMode),
       defaultFiCode =
           defaultFiCode ?? StaticApiConfig.defaultFiCodeForDevMode(devMode);

  /// Resolves runtime config from explicit values, host config, and defaults.
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
    bool devMode = false,
  }) {
    StaticApiConfig.configure(devMode: devMode);

    final String resolvedAppId =
        _nonBlank(appId) ?? StaticApiConfig.appIdForDevMode(devMode);
    final String resolvedAppSecret =
        _nonBlank(appSecret) ?? StaticApiConfig.appSecretForDevMode(devMode);

    return SdkRuntimeConfig(
      techInvestXUrl:
          _nonBlank(techInvestXUrl) ??
          _nonBlank(baseUrl) ??
          StaticApiConfig.techInvestXUrlForDevMode(devMode),
      loginSessionBaseUrl:
          _nonBlank(loginSessionBaseUrl) ??
          StaticApiConfig.loginSessionBaseUrlForDevMode(devMode),
      ipsApiBaseUrl:
          _nonBlank(ipsApiBaseUrl) ??
          StaticApiConfig.ipsApiBaseUrlForDevMode(devMode),
      credentials:
          credentials ??
          AppCredentials(
            appId: resolvedAppId,
            appSecret: resolvedAppSecret,
          ),
      devMode: devMode,
      accessToken: _nonBlank(accessToken),
      neSession:
          _nonBlank(neSession) ?? StaticApiConfig.neSessionForDevMode(devMode),
      defaultSrcFiCode:
          _nonBlank(defaultSrcFiCode) ??
          StaticApiConfig.defaultSrcFiCodeForDevMode(devMode),
      defaultFiCode:
          _nonBlank(defaultFiCode) ??
          StaticApiConfig.defaultFiCodeForDevMode(devMode),
      language: _nonBlank(language) ?? StaticApiConfig.defaultLanguage,
      enableDebugLogs: enableDebugLogs ?? false,
    );
  }

  /// Whether both app id and secret are present.
  bool get hasCredentials =>
      credentials.appId.trim().isNotEmpty &&
      credentials.appSecret.trim().isNotEmpty;

  /// Whether profile/current-user APIs can be called.
  bool get canFetchCurrentUser => hasCredentials && techInvestXUrl.isNotEmpty;

  /// Whether protected IPS APIs can be called.
  bool get hasProtectedApi => hasCredentials && ipsApiBaseUrl.isNotEmpty;

  /// Whether login-session bootstrap can be called.
  bool get canBootstrapSession =>
      hasProtectedApi &&
      loginSessionBaseUrl.isNotEmpty &&
      (neSession?.isNotEmpty ?? false);

  /// Backend language flag, where English is `1` and Mongolian/default is `0`.
  int get languageFlag => language.toUpperCase() == 'EN' ? 1 : 0;

  /// Creates an API runtime for current-user/profile APIs.
  ApiRuntime? createCurrentUserRuntime({TokenProvider? tokenProvider}) {
    if (!canFetchCurrentUser) return null;

    return ApiRuntime(
      config: ApiConfig(
        baseUrl: techInvestXUrl,
        credentials: credentials,
        enableDebugLogs: enableDebugLogs,
        backendLoggerBaseUrl: techInvestXUrl,
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

  /// Creates an API runtime for protected IPS APIs.
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
        backendLoggerBaseUrl: techInvestXUrl,
      ),
      tokenProvider: tokenProvider ?? StaticTokenProvider(accessToken),
      onRefreshSession: onRefreshSession,
    );
  }

  /// Creates an API runtime for the login-session endpoint.
  ApiRuntime? createSessionRuntime() {
    if (!canBootstrapSession) return null;

    return ApiRuntime(
      config: ApiConfig(
        baseUrl: loginSessionBaseUrl,
        credentials: credentials,
        enableDebugLogs: enableDebugLogs,
        backendLoggerBaseUrl: techInvestXUrl,
      ),
      tokenProvider: const StaticTokenProvider(null),
    );
  }

  static String? _nonBlank(String? value) {
    final String trimmed = value?.trim() ?? '';
    return trimmed.isEmpty ? null : trimmed;
  }
}
