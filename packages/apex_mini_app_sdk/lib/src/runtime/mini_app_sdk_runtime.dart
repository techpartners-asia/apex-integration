import 'package:mini_app_core/mini_app_core.dart';
import 'package:mini_app_ui/mini_app_ui.dart';
import 'package:flutter/widgets.dart';

import '../config/mini_app_sdk_config.dart';
import '../di/mini_app_sdk_di.dart';
import '../features/router/investx_feature_info.dart';
import '../host/apex_mini_app_host_context.dart';
import 'mini_app_launch_context.dart';

class MiniAppSdk {
  static const String investXDisplayName = InvestXFeatureInfo.displayName;

  final MiniAppSdkConfig config;
  final MiniAppRuntime runtime;

  factory MiniAppSdk({required MiniAppSdkConfig config}) {
    ApexMiniAppHostContext.bind(
      nextCallbacks: config.callbacks,
    );
    final UiMiniAppModule feature = buildMiniAppFeature(config);
    final MiniAppRuntime runtime = MiniAppRuntime(
      modules: <UiMiniAppModule>[feature],
      onNavigate: (String? routeName, Object? arguments) {
        ApexMiniAppHostContext.emitNavigate(
          routeName,
          _publicLaunchArguments(arguments),
        );
      },
      onError: ApexMiniAppHostContext.emitError,
    );
    ApexMiniAppHostContext.bindController(runtime.controller);
    return MiniAppSdk._(config: config, runtime: runtime);
  }

  MiniAppSdk._({required this.config, required this.runtime});

  String get miniAppDisplayName => InvestXFeatureInfo.displayName;

  String get initialRoute => config.initialRoute.trim().isEmpty
      ? InvestXFeatureInfo.initialRoute
      : config.initialRoute.trim();

  Future<MiniAppLaunchRes> launch(BuildContext context, MiniAppLaunchReq req) {
    final Object? arguments = req.arguments;
    final MiniAppLaunchReq normalizedReq = arguments is MiniAppLaunchContext
        ? req
        : MiniAppLaunchReq(
            route: req.route,
            arguments: MiniAppLaunchContext(
              userToken: config.userToken,
              hostUser: config.hostUser,
              hostSession: config.hostSession,
              arguments: arguments,
            ),
          );
    return _launchGuarded(context, normalizedReq);
  }

  Future<MiniAppLaunchRes> launchRoute(
    BuildContext context, {
    String? route,
    String? userToken,
    Object? arguments,
  }) {
    return _launchGuarded(
      context,
      MiniAppLaunchReq(
        route: route ?? initialRoute,
        arguments: MiniAppLaunchContext(
          userToken: userToken ?? config.userToken,
          hostUser: config.hostUser,
          hostSession: config.hostSession,
          arguments: arguments,
        ),
      ),
    );
  }

  Future<MiniAppLaunchRes> _launchGuarded(
    BuildContext context,
    MiniAppLaunchReq req,
  ) async {
    final Object? arguments = req.arguments;
    final String? userToken = arguments is MiniAppLaunchContext
        ? arguments.userToken
        : config.userToken;

    if ((userToken ?? '').trim().isEmpty) {
      final MiniAppLaunchRes failure = MiniAppLaunchRes.failure(
        route: req.route,
        errorCode: MiniAppLaunchErrorCode.invalidReq,
        errorMessage: 'Apex mini app requires a non-empty host token.',
      );
      ApexMiniAppHostContext.emitError(failure);
      return failure;
    }

    final MiniAppLaunchRes res = await runtime.launch(context, req);
    if (res.status == MiniAppLaunchStatus.success) {
      ApexMiniAppHostContext.emitClose(res.data);
    }
    return res;
  }

  void dispose() {
    ApexMiniAppHostContext.clearController(runtime.controller);
    ApexMiniAppHostContext.clear(config.callbacks);
    runtime.dispose();
  }
}

Object? _publicLaunchArguments(Object? arguments) {
  return arguments is MiniAppLaunchContext ? arguments.arguments : arguments;
}
