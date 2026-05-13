import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:mini_app_sdk/apex_mini_app_sdk.dart';
import 'package:mini_app_ui/mini_app_ui.dart';

import 'example_app_tokens.dart';
import '../host/example_host_context.dart';
import '../host/example_wallet_payment_handler.dart';
import 'launcher_home_page.dart';

class MiniAppExampleApp extends StatefulWidget {
  final MiniAppWalletPaymentHandler? walletPaymentHandler;
  final ApexMiniAppHostConfig? hostConfig;
  final MiniAppSdkConfig? sdkConfig;

  const MiniAppExampleApp({
    super.key,
    this.walletPaymentHandler,
    this.hostConfig,
    this.sdkConfig,
  });

  @override
  State<MiniAppExampleApp> createState() => MiniAppExampleAppState();
}

class MiniAppExampleAppState extends State<MiniAppExampleApp> {
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  final GlobalKey<NavigatorState> miniAppNavigatorKey = GlobalKey<NavigatorState>();
  final ValueNotifier<List<String>> hostEvents = ValueNotifier<List<String>>(<String>[]);
  late final ApexMiniAppHostConfig hostConfig;
  late final MiniAppWalletPaymentHandler walletPaymentHandler;
  late final MiniAppUserDataSourceMode userDataSourceMode;
  bool _miniAppRouteOpen = false;

  @override
  void initState() {
    super.initState();

    walletPaymentHandler =
        widget.walletPaymentHandler ??
        widget.sdkConfig?.walletPaymentHandler ??
        buildExampleWalletPaymentHandler(
          navigatorKey,
          onResult: (MiniAppPaymentRes result) {
            recordHostEvent('payment status: ${result.status}');
          },
        );
    hostConfig = widget.hostConfig ?? _hostConfigFromSdkConfig(widget.sdkConfig) ?? exampleHostConfig;
    userDataSourceMode = widget.sdkConfig?.userDataSourceMode ?? MiniAppUserDataSourceMode.realUser;
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = MiniAppTypography.apply(
      ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: ExampleAppTokens.primary,
          secondary: ExampleAppTokens.secondary,
        ),
        scaffoldBackgroundColor: ExampleAppTokens.scaffoldBackground,
        useMaterial3: true,
      ),
    );

    return MiniAppPlatformApp(
      navigatorKey: navigatorKey,
      title: 'Mini App SDK Example',
      locale: const Locale('mn'),
      localizationsDelegates: SdkLocalizations.localizationsDelegates,
      supportedLocales: SdkLocalizations.supportedLocales,
      theme: theme,
      home: LauncherHomePage(
        hostConfig: hostConfig,
        hostEvents: hostEvents,
        onLaunchMiniApp: openMiniApp,
      ),
    );
  }

  @override
  void dispose() {
    hostEvents.dispose();
    super.dispose();
  }

  ApexMiniAppHostConfig? _hostConfigFromSdkConfig(MiniAppSdkConfig? config) {
    if (config == null) {
      return null;
    }

    return ApexMiniAppHostConfig(
      token: config.userToken ?? '',
      baseUrl: config.baseUrl,
      techInvestXBaseUrl: config.techInvestXBaseUrl,
      loginSessionBaseUrl: config.loginSessionBaseUrl,
      ipsApiBaseUrl: config.ipsApiBaseUrl,
      locale: config.locale,
      initialRoute: config.initialRoute,
      initialArguments: config.initialArguments,
      user: config.hostUser,
      session: config.hostSession,
      appId: config.appId,
      appSecret: config.appSecret,
      defaultSrcFiCode: config.defaultSrcFiCode,
      defaultFiCode: config.defaultFiCode,
      language: config.language,
      enableDebugLogs: config.enableDebugLogs,
    );
  }

  void openMiniApp() {
    if (_miniAppRouteOpen) {
      return;
    }

    final NavigatorState? navigator = navigatorKey.currentState;
    if (navigator == null) {
      recordHostEvent('open failed: host navigator unavailable');
      return;
    }

    _miniAppRouteOpen = true;
    recordHostEvent('open: ${hostConfig.normalizedInitialRoute}');

    navigator
        .push<void>(
          MaterialPageRoute<void>(
            settings: const RouteSettings(name: 'apex-mini-app'),
            builder: (BuildContext context) => ApexMiniAppSdk.config(
              hostConfig: hostConfig,
              walletPaymentHandler: walletPaymentHandler,
              navigatorKey: miniAppNavigatorKey,
              userDataSourceMode: userDataSourceMode,
              onClose: closeMiniApp,
              onCloseWithResult: (Object? result) {
                recordHostEvent('closed result: $result');
              },
              onTokenExpired: () => recordHostEvent('token expired'),
              onNavigate: (String? route, Object? arguments) {
                recordHostEvent('navigate: ${route ?? '-'}');
              },
              onError: (Object error, StackTrace? stackTrace) {
                recordHostEvent('error: $error');
              },
            ),
          ),
        )
        .whenComplete(() {
          _miniAppRouteOpen = false;
        });
  }

  void closeMiniApp() {
    recordHostEvent('closed');
    if (!_miniAppRouteOpen) {
      return;
    }

    final NavigatorState? navigator = navigatorKey.currentState;
    if (navigator == null || !navigator.canPop()) {
      _miniAppRouteOpen = false;
      return;
    }

    _miniAppRouteOpen = false;
    navigator.pop();
  }

  void recordHostEvent(String message) {
    if (!mounted) {
      return;
    }

    void writeEvent() {
      if (!mounted) {
        return;
      }

      final DateTime now = DateTime.now();
      final String timestamp =
          '${now.hour.toString().padLeft(2, '0')}:'
          '${now.minute.toString().padLeft(2, '0')}:'
          '${now.second.toString().padLeft(2, '0')}';

      hostEvents.value = <String>[
        '$timestamp  $message',
        ...hostEvents.value.take(5),
      ];
    }

    final SchedulerPhase phase = WidgetsBinding.instance.schedulerPhase;

    if (phase == SchedulerPhase.persistentCallbacks || phase == SchedulerPhase.transientCallbacks || phase == SchedulerPhase.midFrameMicrotasks) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        writeEvent();
      });
      return;
    }

    writeEvent();
  }
}
