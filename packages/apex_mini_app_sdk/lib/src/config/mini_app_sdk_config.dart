import 'dart:ui';

import 'package:mini_app_ui/mini_app_ui.dart';

import '../host/apex_mini_app_host_callbacks.dart';
import '../host/apex_mini_app_host_config.dart';
import '../payment/payment.dart';
import '../routes/mini_app_routes.dart';

enum MiniAppUserDataSourceMode {
  contract,
  realUser,
}

class MiniAppSdkConfig {
  static const Duration defaultPaymentTimeout = Duration(seconds: 45);

  final String? userToken;
  final MiniAppWalletPaymentHandler walletPaymentHandler;
  final Duration paymentTimeout;
  final MiniAppLogger logger;
  final MiniAppUserDataSourceMode userDataSourceMode;
  final String initialRoute;
  final Object? initialArguments;
  final Locale? locale;
  final String? baseUrl;
  final String? techInvestXBaseUrl;
  final String? loginSessionBaseUrl;
  final String? ipsApiBaseUrl;
  final String? appId;
  final String? appSecret;
  final String? accessToken;
  final String? neSession;
  final String? defaultSrcFiCode;
  final String? defaultFiCode;
  final String? language;
  final bool? enableDebugLogs;
  final ApexMiniAppHostUser? hostUser;
  final ApexMiniAppHostSession? hostSession;
  final ApexMiniAppHostCallbacks callbacks;

  const MiniAppSdkConfig({
    this.userToken,
    required this.walletPaymentHandler,
    this.paymentTimeout = defaultPaymentTimeout,
    this.logger = const DebugMiniAppLogger(),
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

  MiniAppSdkConfig copyWith({
    String? userToken,
    MiniAppWalletPaymentHandler? walletPaymentHandler,
    Duration? paymentTimeout,
    MiniAppLogger? logger,
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

  static String? _languageFromLocale(Locale? locale) {
    final String languageCode = locale?.languageCode.trim().toLowerCase() ?? '';
    if (languageCode.isEmpty) {
      return null;
    }
    return languageCode == 'en' ? 'EN' : 'MN';
  }

  static String? _normalized(String? value) {
    final String trimmed = value?.trim() ?? '';
    return trimmed.isEmpty ? null : trimmed;
  }
}
