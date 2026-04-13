import 'package:mini_app_core/mini_app_core.dart';
import 'package:mini_app_ui/mini_app_ui.dart';
import 'package:flutter/widgets.dart';

import '../config/mini_app_sdk_config.dart';
import '../di/mini_app_sdk_di.dart';
import '../features/ips/router/investx_feature_info.dart';
import 'mini_app_launch_context.dart';

class MiniAppSdk {
  static const String investXDisplayName = InvestXFeatureInfo.displayName;

  final MiniAppSdkConfig config;
  final MiniAppRuntime runtime;

  factory MiniAppSdk({required MiniAppSdkConfig config}) {
    final UiMiniAppModule feature = buildMiniAppFeature(config);
    final MiniAppRuntime runtime = MiniAppRuntime(
      modules: <UiMiniAppModule>[feature],
    );
    return MiniAppSdk._(config: config, runtime: runtime);
  }

  MiniAppSdk._({required this.config, required this.runtime});

  String get miniAppDisplayName => InvestXFeatureInfo.displayName;

  String get initialRoute => InvestXFeatureInfo.initialRoute;

  Future<MiniAppLaunchRes> launch(BuildContext context, MiniAppLaunchReq req) {
    final Object? arguments = req.arguments;
    final MiniAppLaunchReq normalizedReq = arguments is MiniAppLaunchContext
        ? req
        : MiniAppLaunchReq(
            route: req.route,
            arguments: MiniAppLaunchContext(
              userToken: config.userToken,
              arguments: arguments,
            ),
          );
    return runtime.launch(context, normalizedReq);
  }

  Future<MiniAppLaunchRes> launchInvestX(
    BuildContext context, {
    String? userToken,
    Object? arguments,
  }) {
    return launchRoute(
      context,
      route: initialRoute,
      userToken: userToken,
      arguments: arguments,
    );
  }

  Future<MiniAppLaunchRes> launchRoute(
    BuildContext context, {
    String route = InvestXFeatureInfo.initialRoute,
    String? userToken,
    Object? arguments,
  }) {
    return runtime.launch(
      context,
      MiniAppLaunchReq(
        route: route,
        arguments: MiniAppLaunchContext(
          userToken: userToken ?? config.userToken,
          arguments: arguments,
        ),
      ),
    );
  }

  void dispose() {
    runtime.dispose();
  }
}
