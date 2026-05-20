import 'dart:async';

import 'package:flutter/material.dart';
import 'package:apex_mini_app_sdk/apex_mini_app_sdk.dart';

import 'apex_mini_app_error_screens.dart';
import 'apex_mini_app_host_context.dart';

/// Public widget used by a host app to embed the Apex mini app.
///
/// This widget owns the SDK runtime, navigator key, host callbacks, controller
/// binding, and safe close behavior. Host apps should prefer this entry point
/// over constructing lower-level runtime classes directly.
class ApexMiniAppSdk extends StatefulWidget {
  /// Creates the mini app from individual host parameters.
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

  /// Creates the mini app from a prebuilt host config object.
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

  /// Validated host configuration used to construct the runtime.
  final ApexMiniAppHostConfig hostConfig;

  /// Host payment handler called when the mini app delegates wallet payment.
  final MiniAppWalletPaymentHandler walletPaymentHandler;

  /// Optional navigator key for the mini-app navigator.
  final GlobalKey<NavigatorState>? navigatorKey;

  /// Optional host-provided light theme.
  final ThemeData? theme;

  /// Optional host-provided dark theme.
  final ThemeData? darkTheme;

  /// Optional app builder passed through to `MiniAppPlatformApp`.
  final TransitionBuilder? builder;

  /// Optional locale list. Defaults to SDK localizations.
  final Iterable<Locale>? supportedLocales;

  /// Optional localization delegates. Defaults to SDK delegates.
  final Iterable<LocalizationsDelegate<dynamic>>? localizationsDelegates;

  /// Max duration allowed for host payment handling.
  final Duration paymentTimeout;

  /// Runtime logger used by navigation and SDK internals.
  final MiniAppLogger logger;

  /// Selects real-user or contract-user session source.
  final MiniAppUserDataSourceMode userDataSourceMode;

  /// Called when the mini app requests close without a result.
  final ApexMiniAppCloseHook? onClose;

  /// Called when the mini app closes and returns a result.
  final ApexMiniAppCloseResultHook? onCloseWithResult;

  /// Called when the SDK detects an expired/missing token flow.
  final ApexMiniAppTokenExpiredHook? onTokenExpired;

  /// Called when internal mini-app navigation changes routes.
  final ApexMiniAppNavigateHook? onNavigate;

  /// Called when an SDK-visible error occurs.
  final ApexMiniAppErrorHook? onError;

  @override
  State<ApexMiniAppSdk> createState() => _ApexMiniAppSdkState();
}

/// Owns the active SDK runtime and bridges lifecycle events to the host.
class _ApexMiniAppSdkState extends State<ApexMiniAppSdk> {
  /// Navigator key used by the isolated mini-app platform app.
  late GlobalKey<NavigatorState> _navigatorKey;

  /// Current callback bundle bound into [ApexMiniAppHostContext].
  late ApexMiniAppHostCallbacks _callbacks;

  /// Most recent host configuration validation result.
  late ApexMiniAppHostValidationResult _validation;

  /// Active SDK runtime.
  MiniAppSdk? _sdk;

  /// Old runtimes retained briefly during widget reconfiguration.
  final List<MiniAppSdk> _retiredSdks = <MiniAppSdk>[];

  /// Error captured while constructing the runtime.
  Object? _initializationError;

  /// Signature used to avoid duplicate initial-route launch callbacks.
  String? _preparedLaunchSignature;

  /// Whether host close callbacks have already been emitted.
  bool _closeEmitted = false;

  /// Guard that prevents concurrent safe-close flows.
  bool _isClosingMiniApp = false;

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
        safeClose: _closeMiniAppSafely,
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

  /// Determines whether host/runtime inputs changed enough to rebuild the SDK.
  bool _mustReconfigure(ApexMiniAppSdk oldWidget) {
    return !_hasSameRuntimeHostConfig(
          oldWidget.hostConfig,
          widget.hostConfig,
        ) ||
        oldWidget.paymentTimeout != widget.paymentTimeout ||
        oldWidget.userDataSourceMode != widget.userDataSourceMode;
  }

  /// Compares only config fields that affect runtime construction.
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

  /// Validates host config, binds callbacks, and builds the SDK runtime.
  void _configure() {
    _closeEmitted = false;
    _isClosingMiniApp = false;
    _initializationError = null;
    _callbacks = _buildCallbacks();
    _validation = widget.hostConfig.validate();
    ApexMiniAppHostContext.bind(
      nextCallbacks: _callbacks,
      safeClose: _closeMiniAppSafely,
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

  /// Creates the callback bundle stored in the static host context.
  ApexMiniAppHostCallbacks _buildCallbacks() {
    return ApexMiniAppHostCallbacks(
      onClose: _emitClose,
      onTokenExpired: _handleTokenExpired,
      onNavigate: widget.onNavigate,
      onError: _emitHostError,
    );
  }

  /// Forwards mini-app payment requests to the host-supplied payment handler.
  Future<MiniAppPaymentRes> _handleWalletPayment(MiniAppPaymentReq request) {
    return widget.walletPaymentHandler(request);
  }

  /// Disposes the currently active SDK runtime.
  void _disposeSdk() {
    _sdk?.dispose();
    _sdk = null;
    _preparedLaunchSignature = null;
  }

  /// Moves the current SDK into a retired list until final disposal.
  ///
  /// This avoids clearing a still-visible old runtime during widget update
  /// frames while the replacement runtime is being prepared.
  void _retireSdk() {
    final MiniAppSdk? sdk = _sdk;
    if (sdk != null) {
      _retiredSdks.add(sdk);
    }
    _sdk = null;
    _preparedLaunchSignature = null;
  }

  /// Disposes active and retired SDK runtimes.
  void _disposeAllSdks() {
    _disposeSdk();
    for (final MiniAppSdk sdk in _retiredSdks) {
      sdk.dispose();
    }
    _retiredSdks.clear();
  }

  /// Starts the safe close flow without awaiting from synchronous callbacks.
  void _emitClose(Object? result) {
    unawaited(_closeMiniAppSafely(null, result));
  }

  /// Clears mini-app overlays/routes before notifying the host that the mini
  /// app has closed.
  Future<void> _closeMiniAppSafely(
    BuildContext? context,
    Object? result,
  ) async {
    if (_closeEmitted) {
      return;
    }
    if (_isClosingMiniApp) {
      return;
    }

    _isClosingMiniApp = true;
    try {
      await _dismissAllMiniAppOverlays(context);
    } catch (error, stackTrace) {
      debugPrint('Failed to dismiss mini app overlays: $error');
      debugPrintStack(stackTrace: stackTrace);
    }

    await Future<void>.delayed(const Duration(milliseconds: 100));

    if (_closeEmitted) {
      _isClosingMiniApp = false;
      return;
    }

    _closeEmitted = true;
    try {
      widget.onClose?.call();
      widget.onCloseWithResult?.call(result);
    } finally {
      _isClosingMiniApp = false;
    }
  }

  /// Dismisses SDK-owned transient UI so dialogs do not remain over the host.
  Future<void> _dismissAllMiniAppOverlays(BuildContext? context) async {
    MiniAppToast.hide();
    final Set<ScaffoldMessengerState> messengers =
        _resolveMiniAppScaffoldMessengers(context);
    _clearMiniAppScaffoldMessengers(messengers);
    await _dismissMiniAppNavigatorRoutes();
    _clearMiniAppScaffoldMessengers(messengers);
  }

  /// Finds scaffold messengers from the active context and navigator context.
  Set<ScaffoldMessengerState> _resolveMiniAppScaffoldMessengers(
    BuildContext? context,
  ) {
    final Set<ScaffoldMessengerState> messengers = <ScaffoldMessengerState>{};

    if (context != null && context.mounted) {
      final ScaffoldMessengerState? messenger = ScaffoldMessenger.maybeOf(
        context,
      );
      if (messenger != null) {
        messengers.add(messenger);
      }
    }

    final BuildContext? navigatorContext = _navigatorKey.currentContext;
    if (navigatorContext != null && navigatorContext.mounted) {
      final ScaffoldMessengerState? messenger = ScaffoldMessenger.maybeOf(
        navigatorContext,
      );
      if (messenger != null) {
        messengers.add(messenger);
      }
    }

    return messengers;
  }

  /// Removes snackbars and material banners from known mini-app messengers.
  void _clearMiniAppScaffoldMessengers(
    Set<ScaffoldMessengerState> messengers,
  ) {
    for (final ScaffoldMessengerState messenger in messengers) {
      messenger
        ..clearSnackBars()
        ..clearMaterialBanners();
    }
  }

  /// Pops mini-app navigator routes such as dialogs, sheets, and pushed pages.
  Future<void> _dismissMiniAppNavigatorRoutes() async {
    final NavigatorState? navigator = _navigatorKey.currentState;
    if (navigator == null || !navigator.mounted) {
      return;
    }

    var popCount = 0;
    while (navigator.mounted && navigator.canPop() && popCount < 20) {
      navigator.pop();
      popCount += 1;
      await Future<void>.delayed(const Duration(milliseconds: 50));
    }
  }

  /// Emits an error to the host if the host provided an error callback.
  void _emitHostError(Object error, [StackTrace? stackTrace]) {
    widget.onError?.call(error, stackTrace);
  }

  /// Handles token expiration by delegating to the host or showing fallback UI.
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

  /// Builds the platform app wrapper that isolates SDK theme/navigation.
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

  /// Selects the startup fallback screen for invalid host parameters.
  Widget _buildValidationScreen(ApexMiniAppHostValidationResult validation) {
    if (validation.isMissingToken) {
      return const ApexMiniAppMissingTokenScreen();
    }
    return ApexMiniAppInvalidParamsScreen(validation: validation);
  }

  /// Builds the first visible mini-app page under the active controller scope.
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

  /// Runs one-time launch callbacks for the initial route.
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

  /// Removes SDK-internal launch context before reporting arguments to hosts.
  Object? _publicLaunchArguments(Object? arguments) {
    return arguments is MiniAppLaunchContext ? arguments.arguments : arguments;
  }

  /// Creates the default SDK theme when the host does not provide one.
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
