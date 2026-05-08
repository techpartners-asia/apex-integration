import 'package:flutter/material.dart';
import 'package:mini_app_core/mini_app_core.dart';
import 'package:mini_app_ui/mini_app_ui.dart';

import '../../l10n/sdk_localizations.dart';
import '../config/mini_app_sdk_config.dart';
import '../payment/payment.dart';
import '../runtime/mini_app_launch_context.dart';
import '../runtime/mini_app_sdk_runtime.dart';
import 'apex_mini_app_error_screens.dart';
import 'apex_mini_app_host_callbacks.dart';
import 'apex_mini_app_host_config.dart';
import 'apex_mini_app_host_context.dart';

class ApexMiniAppSdk extends StatefulWidget {
  ApexMiniAppSdk({
    super.key,
    required String token,
    required this.walletPaymentHandler,
    String? baseUrl,
    String? techInvestXBaseUrl,
    String? loginSessionBaseUrl,
    String? ipsApiBaseUrl,
    Locale? locale,
    String? entryRoute,
    String? initialRoute,
    Object? initialArguments,
    ApexMiniAppHostUser? user,
    ApexMiniAppHostSession? session,
    String? appId,
    String? appSecret,
    String? defaultSrcFiCode,
    String? defaultFiCode,
    String? language,
    bool? enableDebugLogs,
    this.navigatorKey,
    this.theme,
    this.darkTheme,
    this.builder,
    this.supportedLocales,
    this.localizationsDelegates,
    this.paymentTimeout = MiniAppSdkConfig.defaultPaymentTimeout,
    this.logger = const DebugMiniAppLogger(),
    this.userDataSourceMode = MiniAppUserDataSourceMode.realUser,
    this.onClose,
    this.onCloseWithResult,
    this.onTokenExpired,
    this.onNavigate,
    this.onError,
  }) : hostConfig = ApexMiniAppHostConfig(
         token: token,
         baseUrl: baseUrl,
         techInvestXBaseUrl: techInvestXBaseUrl,
         loginSessionBaseUrl: loginSessionBaseUrl,
         ipsApiBaseUrl: ipsApiBaseUrl,
         locale: locale,
         entryRoute: entryRoute,
         initialRoute: initialRoute,
         initialArguments: initialArguments,
         user: user,
         session: session,
         appId: appId,
         appSecret: appSecret,
         defaultSrcFiCode: defaultSrcFiCode,
         defaultFiCode: defaultFiCode,
         language: language,
         enableDebugLogs: enableDebugLogs,
       );

  const ApexMiniAppSdk.config({
    super.key,
    required this.hostConfig,
    required this.walletPaymentHandler,
    this.navigatorKey,
    this.theme,
    this.darkTheme,
    this.builder,
    this.supportedLocales,
    this.localizationsDelegates,
    this.paymentTimeout = MiniAppSdkConfig.defaultPaymentTimeout,
    this.logger = const DebugMiniAppLogger(),
    this.userDataSourceMode = MiniAppUserDataSourceMode.realUser,
    this.onClose,
    this.onCloseWithResult,
    this.onTokenExpired,
    this.onNavigate,
    this.onError,
  });

  final ApexMiniAppHostConfig hostConfig;
  final MiniAppWalletPaymentHandler walletPaymentHandler;
  final GlobalKey<NavigatorState>? navigatorKey;
  final ThemeData? theme;
  final ThemeData? darkTheme;
  final TransitionBuilder? builder;
  final Iterable<Locale>? supportedLocales;
  final Iterable<LocalizationsDelegate<dynamic>>? localizationsDelegates;
  final Duration paymentTimeout;
  final MiniAppLogger logger;
  final MiniAppUserDataSourceMode userDataSourceMode;
  final ApexMiniAppCloseHook? onClose;
  final ApexMiniAppCloseResultHook? onCloseWithResult;
  final ApexMiniAppTokenExpiredHook? onTokenExpired;
  final ApexMiniAppNavigateHook? onNavigate;
  final ApexMiniAppErrorHook? onError;

  @override
  State<ApexMiniAppSdk> createState() => _ApexMiniAppSdkState();
}

class _ApexMiniAppSdkState extends State<ApexMiniAppSdk> {
  late GlobalKey<NavigatorState> _navigatorKey;
  late ApexMiniAppHostCallbacks _callbacks;
  late ApexMiniAppHostValidationResult _validation;

  MiniAppSdk? _sdk;
  final List<MiniAppSdk> _retiredSdks = <MiniAppSdk>[];
  Object? _initializationError;
  String? _preparedLaunchSignature;
  bool _closeEmitted = false;

  @override
  void initState() {
    super.initState();
    _navigatorKey = widget.navigatorKey ?? GlobalKey<NavigatorState>();
    _configure();
  }

  @override
  void didUpdateWidget(covariant ApexMiniAppSdk oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.navigatorKey != widget.navigatorKey) {
      _navigatorKey = widget.navigatorKey ?? GlobalKey<NavigatorState>();
    }

    if (_mustReconfigure(oldWidget)) {
      _retireSdk();
      _configure();
    } else {
      _callbacks = _buildCallbacks();
      ApexMiniAppHostContext.bind(
        nextCallbacks: _callbacks,
      );
    }
  }

  @override
  void dispose() {
    _emitClose(null);
    _disposeAllSdks();
    ApexMiniAppHostContext.clear(_callbacks);
    super.dispose();
  }

  bool _mustReconfigure(ApexMiniAppSdk oldWidget) {
    return !_hasSameRuntimeHostConfig(
          oldWidget.hostConfig,
          widget.hostConfig,
        ) ||
        oldWidget.paymentTimeout != widget.paymentTimeout ||
        oldWidget.userDataSourceMode != widget.userDataSourceMode;
  }

  bool _hasSameRuntimeHostConfig(
    ApexMiniAppHostConfig previous,
    ApexMiniAppHostConfig next,
  ) {
    return previous.token == next.token &&
        previous.baseUrl == next.baseUrl &&
        previous.techInvestXBaseUrl == next.techInvestXBaseUrl &&
        previous.loginSessionBaseUrl == next.loginSessionBaseUrl &&
        previous.ipsApiBaseUrl == next.ipsApiBaseUrl &&
        previous.user == next.user &&
        previous.session == next.session &&
        previous.appId == next.appId &&
        previous.appSecret == next.appSecret &&
        previous.defaultSrcFiCode == next.defaultSrcFiCode &&
        previous.defaultFiCode == next.defaultFiCode &&
        previous.language == next.language &&
        previous.enableDebugLogs == next.enableDebugLogs;
  }

  void _configure() {
    _closeEmitted = false;
    _initializationError = null;
    _callbacks = _buildCallbacks();
    _validation = widget.hostConfig.validate();
    ApexMiniAppHostContext.bind(
      nextCallbacks: _callbacks,
    );

    if (!_validation.isValid) {
      _emitHostError(ApexMiniAppHostParameterException(_validation));
      return;
    }

    try {
      _sdk = MiniAppSdk(
        config: MiniAppSdkConfig.fromHostConfig(
          hostConfig: widget.hostConfig,
          walletPaymentHandler: _handleWalletPayment,
          paymentTimeout: widget.paymentTimeout,
          logger: widget.logger,
          userDataSourceMode: widget.userDataSourceMode,
          callbacks: _callbacks,
        ),
      );
    } catch (error, stackTrace) {
      _sdk = null;
      _initializationError = error;
      _emitHostError(error, stackTrace);
    }
  }

  ApexMiniAppHostCallbacks _buildCallbacks() {
    return ApexMiniAppHostCallbacks(
      onClose: _emitClose,
      onTokenExpired: _handleTokenExpired,
      onNavigate: widget.onNavigate,
      onError: _emitHostError,
    );
  }

  Future<MiniAppPaymentRes> _handleWalletPayment(
    MiniAppWalletPaymentRequest request,
  ) {
    return widget.walletPaymentHandler(request);
  }

  void _disposeSdk() {
    _sdk?.dispose();
    _sdk = null;
    _preparedLaunchSignature = null;
  }

  void _retireSdk() {
    final MiniAppSdk? sdk = _sdk;
    if (sdk != null) {
      _retiredSdks.add(sdk);
    }
    _sdk = null;
    _preparedLaunchSignature = null;
  }

  void _disposeAllSdks() {
    _disposeSdk();
    for (final MiniAppSdk sdk in _retiredSdks) {
      sdk.dispose();
    }
    _retiredSdks.clear();
  }

  void _emitClose(Object? result) {
    if (_closeEmitted) {
      return;
    }
    _closeEmitted = true;
    widget.onClose?.call();
    widget.onCloseWithResult?.call(result);
  }

  void _emitHostError(Object error, [StackTrace? stackTrace]) {
    widget.onError?.call(error, stackTrace);
  }

  void _handleTokenExpired() {
    final ApexMiniAppTokenExpiredHook? hook = widget.onTokenExpired;
    if (hook != null) {
      hook();
      return;
    }

    final NavigatorState? navigator = _navigatorKey.currentState;
    if (navigator == null) {
      return;
    }

    navigator.pushAndRemoveUntil<void>(
      MaterialPageRoute<void>(
        builder: (_) => ApexMiniAppSessionExpiredScreen(
          onClose: () => _emitClose(null),
        ),
      ),
      (Route<dynamic> route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final ApexMiniAppHostValidationResult validation = _validation;
    if (!validation.isValid) {
      return _buildApp(home: _buildValidationScreen(validation));
    }

    final MiniAppSdk? sdk = _sdk;
    if (sdk == null) {
      return _buildApp(
        home: ApexMiniAppInitializationFailureScreen(
          message: _initializationError?.toString(),
          onClose: () => _emitClose(null),
        ),
      );
    }

    ApexMiniAppHostContext.bindController(sdk.runtime.controller);
    return _buildApp(
      home: Builder(
        builder: (BuildContext context) => _buildInitialPage(context, sdk),
      ),
    );
  }

  Widget _buildApp({required Widget home}) {
    return MiniAppPlatformApp(
      navigatorKey: _navigatorKey,
      title: 'Apex Mini App',
      locale: widget.hostConfig.locale,
      localizationsDelegates:
          widget.localizationsDelegates ??
          SdkLocalizations.localizationsDelegates,
      supportedLocales:
          widget.supportedLocales ?? SdkLocalizations.supportedLocales,
      theme: widget.theme ?? _defaultTheme(Brightness.light),
      darkTheme: widget.darkTheme ?? _defaultTheme(Brightness.dark),
      builder: widget.builder,
      home: home,
    );
  }

  Widget _buildValidationScreen(ApexMiniAppHostValidationResult validation) {
    if (validation.isMissingToken) {
      return const ApexMiniAppMissingTokenScreen();
    }
    return ApexMiniAppInvalidParamsScreen(validation: validation);
  }

  Widget _buildInitialPage(BuildContext context, MiniAppSdk sdk) {
    ApexMiniAppHostContext.bindController(sdk.runtime.controller);
    final UiMiniAppModule module = sdk.runtime.modules.first;
    final MiniAppLaunchContext launchContext = MiniAppLaunchContext(
      userToken: sdk.config.userToken,
      hostUser: sdk.config.hostUser,
      hostSession: sdk.config.hostSession,
      arguments: sdk.config.initialArguments,
    );
    final String route = sdk.initialRoute;
    final MiniAppLaunchReq req = MiniAppLaunchReq(
      route: route,
      arguments: launchContext,
    );

    _prepareInitialLaunch(module, req);

    return MiniAppHostControllerScope(
      controller: sdk.runtime.controller,
      child: PopScope<Object?>(
        canPop: false,
        onPopInvokedWithResult: (bool didPop, Object? result) {
          if (!didPop) {
            _emitClose(result);
          }
        },
        child: MiniAppHostShell(
          child: Builder(
            builder: (BuildContext pageContext) {
              return module.buildPage(pageContext, route, launchContext);
            },
          ),
        ),
      ),
    );
  }

  void _prepareInitialLaunch(UiMiniAppModule module, MiniAppLaunchReq req) {
    final Object? arguments = req.arguments;
    final Object? publicArguments = _publicLaunchArguments(arguments);
    final String? userToken = arguments is MiniAppLaunchContext
        ? arguments.userToken
        : widget.hostConfig.normalizedToken;
    final String signature =
        '${req.route}|$userToken|${identityHashCode(publicArguments)}';
    if (_preparedLaunchSignature == signature) {
      return;
    }

    module.onLaunchStarted(req);
    ApexMiniAppHostContext.emitNavigate(
      req.route,
      _publicLaunchArguments(req.arguments),
    );
    _preparedLaunchSignature = signature;
  }

  Object? _publicLaunchArguments(Object? arguments) {
    return arguments is MiniAppLaunchContext ? arguments.arguments : arguments;
  }

  ThemeData _defaultTheme(Brightness brightness) {
    final ColorScheme colorScheme = ColorScheme.fromSeed(
      seedColor: const Color(0xFFDD4F80),
      brightness: brightness,
    );

    return MiniAppTypography.apply(
      ThemeData(
        colorScheme: colorScheme,
        useMaterial3: true,
      ),
    );
  }
}
