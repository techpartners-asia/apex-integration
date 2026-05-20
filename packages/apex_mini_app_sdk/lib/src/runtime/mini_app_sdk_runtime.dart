import 'package:flutter/widgets.dart';
import 'package:apex_mini_app_sdk/apex_mini_app_sdk.dart';

import '../host/apex_mini_app_host_context.dart';

/// Internal SDK runtime facade.
///
/// `ApexMiniAppSdk` owns this object. It wires the InvestX feature module into
/// `MiniAppRuntime`, normalizes launch arguments, and keeps host callbacks in
/// sync with the active controller.
class MiniAppSdk {
  /// Display name exposed for logs/tests.
  static const String investXDisplayName = InvestXFeatureInfo.displayName;

  /// Runtime configuration derived from host config.
  final MiniAppSdkConfig config;

  /// Mini-app runtime that owns modules and the host controller.
  final MiniAppRuntime runtime;

  /// Builds the feature graph and runtime controller.
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

  /// Human-readable mini-app display name.
  String get miniAppDisplayName => InvestXFeatureInfo.displayName;

  /// First route opened by the SDK, with a feature default fallback.
  String get initialRoute => config.initialRoute.trim().isEmpty
      ? InvestXFeatureInfo.initialRoute
      : config.initialRoute.trim();

  /// Launches a route and ensures host token/session data is available to it.
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

  /// Convenience method for launching a route from primitive arguments.
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

  /// Validates launch preconditions and delegates to `MiniAppRuntime`.
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

  /// Tears down callbacks, controller registry entries, and runtime resources.
  void dispose() {
    ApexMiniAppHostContext.clearController(runtime.controller);
    MiniAppHostControllerProvider.detachController(runtime.controller);
    ApexMiniAppHostContext.clear(config.callbacks);
    runtime.dispose();
  }
}

/// Removes SDK-internal launch context before reporting arguments to hosts.
Object? _publicLaunchArguments(Object? arguments) {
  return arguments is MiniAppLaunchContext ? arguments.arguments : arguments;
}
