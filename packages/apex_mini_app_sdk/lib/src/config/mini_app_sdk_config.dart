import 'dart:ui';

import 'package:apex_mini_app_sdk/apex_mini_app_sdk.dart';

/// Selects which login/session source the mini app should use.
enum MiniAppUserDataSourceMode {
  /// Use the contract login session, usually the `login_session_contract`
  /// value returned by the host/backend session flow.
  contract,

  /// Use the real user login/session values supplied by the host app.
  realUser,
}

/// Internal runtime configuration for the Apex mini app SDK.
///
/// Host-facing values are first validated as `ApexMiniAppHostConfig`, then
/// normalized into this object so the runtime, API layer, payment executor, and
/// feature dependencies all read a single configuration source.
class MiniAppSdkConfig {
  /// Default time allowed for the host wallet/payment callback to complete.
  static const Duration defaultPaymentTimeout = Duration(seconds: 45);

  /// Host token used to initialize the mini app.
  final String? userToken;

  /// Host-provided function that executes wallet/payment requests.
  final MiniAppWalletPaymentHandler walletPaymentHandler;

  /// Timeout applied around host payment handling.
  final Duration paymentTimeout;

  /// Logger used by runtime and navigation diagnostics.
  final MiniAppLogger logger;

  /// Whether built-in backend defaults should target development services.
  final bool devMode;

  /// Session source selection for real-user vs contract-user flows.
  final MiniAppUserDataSourceMode userDataSourceMode;

  /// First mini-app route opened by the runtime.
  final String initialRoute;

  /// Optional payload passed to the first route.
  final Object? initialArguments;

  /// Locale requested by the host app.
  final Locale? locale;

  /// Default backend base URL.
  final String? baseUrl;

  /// Base URL for Tech InvestX APIs.
  final String? techInvestXBaseUrl;

  /// Base URL for login-session APIs.
  final String? loginSessionBaseUrl;

  /// Base URL for IPS/securities APIs.
  final String? ipsApiBaseUrl;

  /// Host application id.
  final String? appId;

  /// Host application secret.
  final String? appSecret;

  /// Access token from host session, when supplied.
  final String? accessToken;

  /// NE session from host session, when supplied.
  final String? neSession;

  /// Default source FI code for securities flows.
  final String? defaultSrcFiCode;

  /// Default FI code for securities flows.
  final String? defaultFiCode;

  /// Normalized language code used by API requests.
  final String? language;

  /// Optional debug logging switch.
  final bool? enableDebugLogs;

  /// Host user snapshot.
  final ApexMiniAppHostUser? hostUser;

  /// Host session snapshot.
  final ApexMiniAppHostSession? hostSession;

  /// Runtime callbacks back into the host app.
  final ApexMiniAppHostCallbacks callbacks;

  /// Creates normalized SDK runtime configuration.
  ///
  /// Host apps normally construct this indirectly through
  /// [MiniAppSdkConfig.fromHostConfig]; tests and lower-level integration code
  /// may construct it directly when they need precise control over runtime
  /// URLs, session source, or callbacks.
  const MiniAppSdkConfig({
    this.userToken,
    required this.walletPaymentHandler,
    this.paymentTimeout = defaultPaymentTimeout,
    this.logger = const DebugMiniAppLogger(),
    this.devMode = false,
    this.userDataSourceMode = MiniAppUserDataSourceMode.realUser,
    this.initialRoute = MiniAppRoutes.investX,
    this.initialArguments,
    this.locale,
    this.baseUrl,
    this.techInvestXBaseUrl,
    this.loginSessionBaseUrl,
    this.ipsApiBaseUrl,
    this.appId,
    this.appSecret,
    this.accessToken,
    this.neSession,
    this.defaultSrcFiCode,
    this.defaultFiCode,
    this.language,
    this.enableDebugLogs,
    this.hostUser,
    this.hostSession,
    this.callbacks = ApexMiniAppHostCallbacks.empty,
  }) : assert(
         paymentTimeout > Duration.zero,
         'paymentTimeout must be greater than zero.',
       );

  /// Creates a modified config while preserving unspecified fields.
  MiniAppSdkConfig copyWith({
    String? userToken,
    MiniAppWalletPaymentHandler? walletPaymentHandler,
    Duration? paymentTimeout,
    MiniAppLogger? logger,
    bool? devMode,
    MiniAppUserDataSourceMode? userDataSourceMode,
    String? initialRoute,
    Object? initialArguments,
    Locale? locale,
    String? baseUrl,
    String? techInvestXBaseUrl,
    String? loginSessionBaseUrl,
    String? ipsApiBaseUrl,
    String? appId,
    String? appSecret,
    String? accessToken,
    String? neSession,
    String? defaultSrcFiCode,
    String? defaultFiCode,
    String? language,
    bool? enableDebugLogs,
    ApexMiniAppHostUser? hostUser,
    ApexMiniAppHostSession? hostSession,
    ApexMiniAppHostCallbacks? callbacks,
  }) {
    return MiniAppSdkConfig(
      userToken: userToken ?? this.userToken,
      walletPaymentHandler: walletPaymentHandler ?? this.walletPaymentHandler,
      paymentTimeout: paymentTimeout ?? this.paymentTimeout,
      logger: logger ?? this.logger,
      devMode: devMode ?? this.devMode,
      userDataSourceMode: userDataSourceMode ?? this.userDataSourceMode,
      initialRoute: initialRoute ?? this.initialRoute,
      initialArguments: initialArguments ?? this.initialArguments,
      locale: locale ?? this.locale,
      baseUrl: baseUrl ?? this.baseUrl,
      techInvestXBaseUrl: techInvestXBaseUrl ?? this.techInvestXBaseUrl,
      loginSessionBaseUrl: loginSessionBaseUrl ?? this.loginSessionBaseUrl,
      ipsApiBaseUrl: ipsApiBaseUrl ?? this.ipsApiBaseUrl,
      appId: appId ?? this.appId,
      appSecret: appSecret ?? this.appSecret,
      accessToken: accessToken ?? this.accessToken,
      neSession: neSession ?? this.neSession,
      defaultSrcFiCode: defaultSrcFiCode ?? this.defaultSrcFiCode,
      defaultFiCode: defaultFiCode ?? this.defaultFiCode,
      language: language ?? this.language,
      enableDebugLogs: enableDebugLogs ?? this.enableDebugLogs,
      hostUser: hostUser ?? this.hostUser,
      hostSession: hostSession ?? this.hostSession,
      callbacks: callbacks ?? this.callbacks,
    );
  }

  /// Converts validated host-facing configuration into runtime configuration.
  factory MiniAppSdkConfig.fromHostConfig({
    required ApexMiniAppHostConfig hostConfig,
    required MiniAppWalletPaymentHandler walletPaymentHandler,
    Duration paymentTimeout = defaultPaymentTimeout,
    MiniAppLogger logger = const DebugMiniAppLogger(),
    MiniAppUserDataSourceMode userDataSourceMode =
        MiniAppUserDataSourceMode.realUser,
    ApexMiniAppHostCallbacks callbacks = ApexMiniAppHostCallbacks.empty,
  }) {
    return MiniAppSdkConfig(
      userToken: hostConfig.normalizedToken,
      walletPaymentHandler: walletPaymentHandler,
      paymentTimeout: paymentTimeout,
      logger: logger,
      devMode: hostConfig.devMode,
      userDataSourceMode: userDataSourceMode,
      initialRoute: hostConfig.normalizedInitialRoute,
      initialArguments: hostConfig.initialArguments,
      locale: hostConfig.locale,
      baseUrl: hostConfig.baseUrl,
      techInvestXBaseUrl: hostConfig.techInvestXBaseUrl,
      loginSessionBaseUrl: hostConfig.loginSessionBaseUrl,
      ipsApiBaseUrl: hostConfig.ipsApiBaseUrl,
      appId: hostConfig.appId,
      appSecret: hostConfig.appSecret,
      accessToken: hostConfig.session?.accessToken,
      neSession: hostConfig.session?.neSession,
      defaultSrcFiCode: hostConfig.defaultSrcFiCode,
      defaultFiCode: hostConfig.defaultFiCode,
      language:
          _normalized(hostConfig.language) ??
          _languageFromLocale(hostConfig.locale),
      enableDebugLogs: hostConfig.enableDebugLogs,
      hostUser: hostConfig.user,
      hostSession: hostConfig.session,
      callbacks: callbacks,
    );
  }

  /// Maps Flutter locale into the backend language code expected by Apex APIs.
  static String? _languageFromLocale(Locale? locale) {
    final String languageCode = locale?.languageCode.trim().toLowerCase() ?? '';
    if (languageCode.isEmpty) {
      return null;
    }
    return languageCode == 'en' ? 'EN' : 'MN';
  }

  /// Returns a trimmed non-empty string or `null`.
  static String? _normalized(String? value) {
    final String trimmed = value?.trim() ?? '';
    return trimmed.isEmpty ? null : trimmed;
  }
}
