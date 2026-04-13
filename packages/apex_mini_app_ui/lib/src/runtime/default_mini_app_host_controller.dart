import 'package:mini_app_core/mini_app_core.dart';
import 'package:flutter/material.dart';

import '../module/ui_mini_app_module.dart';
import '../theme/mini_app_state_colors.dart';
import '../widget/mini_app_host_shell.dart';
import 'mini_app_animated_page_route.dart';
import 'mini_app_host_controller.dart';
import 'mini_app_host_controller_provider.dart';
import 'silent_mini_app_logger.dart';

const double modalBorderRadius = 20.0;
const Color modalBarrierColor = Color(0x8A000000);
const bool modalBarrierDismissible = true;
const bool useRootNavigator = true;
const bool showDragHandle = true;
const bool isScrollControlled = true;
const bool enableDrag = true;
const SilentMiniAppLogger logger = SilentMiniAppLogger();

class DefaultMiniAppHostController implements MiniAppHostController {
  DefaultMiniAppHostController();

  final MiniAppRegistry registry = MiniAppRegistry();
  bool isDisposed = false;

  @override
  void registerModule(UiMiniAppModule module) {
    ensureNotDisposed();
    registry.register(module);
  }

  @override
  void registerModules(Iterable<UiMiniAppModule> modules) {
    ensureNotDisposed();
    registry.registerAll(modules);
  }

  @override
  bool canLaunch(MiniAppLaunchReq req) {
    ensureNotDisposed();
    return resolveLaunchReq(req) != null;
  }

  @override
  Future<MiniAppLaunchRes> launch(BuildContext context, MiniAppLaunchReq req) async {
    ensureNotDisposed();

    final ResolvedLaunch? resolved = resolveLaunchReq(req);
    if (resolved == null) {
      return buildValidationFailure(req);
    }

    if (!context.mounted) {
      return MiniAppLaunchRes(
        status: MiniAppLaunchStatus.cancelled,
        route: resolved.routeSpec.path,
      );
    }

    try {
      resolved.module.onLaunchStarted(req);
      logger.onInfo(
        'mini_app_launch_started',
        data: <String, Object?>{
          'module': resolved.module.displayName,
          'route': resolved.routeSpec.path,
        },
      );

      final Widget page = MiniAppHostControllerProvider(
        controller: this,
        child: MiniAppHostShell(
          child: resolved.module.buildPage(
            context,
            resolved.routeSpec.path,
            req.arguments,
          ),
        ),
      );

      final NavigatorState navigator = Navigator.of(context, rootNavigator: useRootNavigator);

      Object? data = await navigator.push<Object?>(
        MiniAppAnimatedPageRoute<Object?>(
          settings: RouteSettings(name: resolved.routeSpec.path),
          builder: (BuildContext context) => page,
        ),
      );

      final MiniAppLaunchRes res = MiniAppLaunchRes(
        status: MiniAppLaunchStatus.success,
        route: resolved.routeSpec.path,
        data: data,
      );

      logger.onInfo(
        'mini_app_launch_finished',
        data: <String, Object?>{
          'module': resolved.module.displayName,
          'route': resolved.routeSpec.path,
          'status': res.status.name,
        },
      );

      resolved.module.onLaunchFinished(res);

      return res;
    } catch (error, stackTrace) {
      logger.onError(
        'mini_app_launch_failed',
        error: error,
        stackTrace: stackTrace,
        data: <String, Object?>{
          'module': resolved.module.displayName,
          'route': resolved.routeSpec.path,
        },
      );
      final MiniAppLaunchRes failure = MiniAppLaunchRes.failure(
        route: resolved.routeSpec.path,
        errorCode: MiniAppLaunchErrorCode.runtimeError,
        errorMessage: 'Мини апп нээх үед системийн алдаа гарлаа.',
      );
      resolved.module.onLaunchFinished(failure);
      return failure;
    }
  }

  @override
  Future<MiniAppLaunchRes> replace(BuildContext context, MiniAppLaunchReq req) async {
    ensureNotDisposed();

    final ResolvedLaunch? resolved = resolveLaunchReq(req);
    if (resolved == null) {
      return buildValidationFailure(req);
    }

    if (!context.mounted) {
      return MiniAppLaunchRes(
        status: MiniAppLaunchStatus.cancelled,
        route: resolved.routeSpec.path,
      );
    }

    try {
      resolved.module.onLaunchStarted(req);
      logger.onInfo(
        'mini_app_launch_replaced',
        data: <String, Object?>{
          'module': resolved.module.displayName,
          'route': resolved.routeSpec.path,
        },
      );

      final Widget page = MiniAppHostControllerProvider(
        controller: this,
        child: MiniAppHostShell(
          child: resolved.module.buildPage(
            context,
            resolved.routeSpec.path,
            req.arguments,
          ),
        ),
      );
      final NavigatorState navigator = Navigator.of(
        context,
        rootNavigator: useRootNavigator,
      );
      final Object? data = await navigator.pushReplacement<Object?, Object?>(
        MiniAppAnimatedPageRoute<Object?>(
          settings: RouteSettings(name: resolved.routeSpec.path),
          builder: (BuildContext context) => page,
        ),
      );

      final MiniAppLaunchRes res = MiniAppLaunchRes(
        status: MiniAppLaunchStatus.success,
        route: resolved.routeSpec.path,
        data: data,
      );

      resolved.module.onLaunchFinished(res);

      return res;
    } catch (error, stackTrace) {
      logger.onError(
        'mini_app_launch_replace_failed',
        error: error,
        stackTrace: stackTrace,
        data: <String, Object?>{
          'module': resolved.module.displayName,
          'route': resolved.routeSpec.path,
        },
      );

      final MiniAppLaunchRes failure = MiniAppLaunchRes.failure(
        route: resolved.routeSpec.path,
        errorCode: MiniAppLaunchErrorCode.runtimeError,
        errorMessage: 'Мини апп нээх үед системийн алдаа гарлаа.',
      );
      resolved.module.onLaunchFinished(failure);
      return failure;
    }
  }

  ResolvedLaunch? resolveLaunchReq(MiniAppLaunchReq req) {
    final MiniAppModule? baseModule = registry.findByRoute(req.route);
    if (baseModule is! UiMiniAppModule) {
      return null;
    }

    final String route = req.route?.trim() ?? '';
    MiniAppRouteSpec? matchedSpec;
    for (final MiniAppRouteSpec spec in baseModule.routes) {
      if (spec.path == route) {
        matchedSpec = spec;
        break;
      }
    }

    if (matchedSpec == null) {
      return null;
    }

    return ResolvedLaunch(module: baseModule, routeSpec: matchedSpec);
  }

  MiniAppLaunchRes buildValidationFailure(MiniAppLaunchReq req) {
    final MiniAppModule? module = registry.findByRoute(req.route);
    if (module == null) {
      return MiniAppLaunchRes.failure(
        route: req.route,
        errorCode: MiniAppLaunchErrorCode.routeNotFound,
        errorMessage: 'No mini app route is registered for "${req.route}".',
      );
    }

    final bool routeAllowed = module.routes.any(
      (MiniAppRouteSpec spec) => spec.path == req.route,
    );
    if (!routeAllowed) {
      return MiniAppLaunchRes.failure(
        route: req.route,
        errorCode: MiniAppLaunchErrorCode.routeNotFound,
        errorMessage: 'Route "${req.route}" is not declared in module "${module.displayName}".',
      );
    }

    return MiniAppLaunchRes.failure(
      route: req.route,
      errorCode: MiniAppLaunchErrorCode.runtimeError,
      errorMessage: 'Module "${module.displayName}" is not a UI module.',
    );
  }

  void ensureNotDisposed() {
    if (isDisposed) {
      throw StateError('DefaultMiniAppHostController has already been disposed.');
    }
  }

  @override
  void dispose() {
    isDisposed = true;
  }
}

class ResolvedLaunch {
  final UiMiniAppModule module;
  final MiniAppRouteSpec routeSpec;

  ResolvedLaunch({required this.module, required this.routeSpec});
}
