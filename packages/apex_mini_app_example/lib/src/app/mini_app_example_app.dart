import 'package:mini_app_sdk/mini_app_sdk.dart';
import 'package:flutter/material.dart';

import 'example_app_tokens.dart';
import '../host/example_host_context.dart';
import '../host/example_wallet_payment_handler.dart';
import 'launcher_home_page.dart';

class MiniAppExampleApp extends StatefulWidget {
  final MiniAppWalletPaymentHandler? walletPaymentHandler;
  final MiniAppSdkConfig? sdkConfig;

  const MiniAppExampleApp({
    super.key,
    this.walletPaymentHandler,
    this.sdkConfig,
  });

  @override
  State<MiniAppExampleApp> createState() => MiniAppExampleAppState();
}

class MiniAppExampleAppState extends State<MiniAppExampleApp> {
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  late final MiniAppSdkConfig sdkConfig;
  late final MiniAppSdk sdk;

  @override
  void initState() {
    super.initState();

    if (widget.sdkConfig != null) {
      sdkConfig = widget.sdkConfig!;
    } else {
      sdkConfig = buildExampleMiniAppSdkConfig(walletPaymentHandler: widget.walletPaymentHandler ?? buildExampleWalletPaymentHandler(navigatorKey));
    }

    sdk = MiniAppSdk(config: sdkConfig);
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = MiniAppTypography.apply(
      ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: ExampleAppTokens.primary,
          secondary: ExampleAppTokens.secondary,
        ),
        scaffoldBackgroundColor: DesignTokens.softSurface,
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
      home: LauncherHomePage(sdk: sdk),
    );
  }

  @override
  void dispose() {
    sdk.dispose();
    super.dispose();
  }
}
