import 'package:apex_mini_app_core/apex_mini_app_core.dart';
import 'package:flutter/material.dart';

import '../module/ui_mini_app_module.dart';
import '../widget/mini_app_host_shell.dart';
import 'mini_app_animated_page_route.dart';
import 'mini_app_host_controller.dart';
import 'mini_app_host_controller_scope.dart';
import 'silent_mini_app_logger.dart';

/// Default modal corner radius used by mini-app sheets.
const double modalBorderRadius = 20.0;

/// Default modal scrim color.
const Color modalBarrierColor = Color(0x8A000000);

/// Whether mini-app modal barriers are dismissible by default.
const bool modalBarrierDismissible = true;

/// Whether mini-app sheets use the root navigator by default.
const bool useRootNavigator = false;

/// Whether mini-app sheets show a drag handle by default.
const bool showDragHandle = true;

/// Whether mini-app sheets are scroll controlled by default.
const bool isScrollControlled = true;

/// Whether mini-app sheets can be dragged by default.
const bool enableDrag = true;

/// Default silent logger for lower-level UI runtime paths.
const SilentMiniAppLogger logger = SilentMiniAppLogger();

/// Default route/navigation controller for UI mini-app modules.
///
/// It owns the module registry and pushes/replaces Flutter routes under
/// `MiniAppHostControllerScope` so newly opened pages keep the same active
/// controller as the current mini-app runtime.
class DefaultMiniAppHostController
    implements MiniAppHostController, MiniAppHostControllerLifecycle {
  /// Creates a default mini-app host controller.
  DefaultMiniAppHostController({
    this.onNavigate,
    this.onError,
  });

  /// Registry used to resolve launch requests to UI modules.
  final MiniAppRegistry registry = MiniAppRegistry();

  /// Optional navigation observer callback.
  final void Function(String? routeName, Object? arguments)? onNavigate;

  /// Optional runtime error callback.
  final void Function(Object error, StackTrace? stackTrace)? onError;

  /// Whether this controller has been disposed.
  @override
  bool isDisposed = false;

  /// Registers one module and its routes.
  @override
  void registerModule(UiMiniAppModule module) {
    ensureNotDisposed();
    registry.register(module);
  }

  /// Registers multiple modules and their routes.
  @override
  void registerModules(Iterable<UiMiniAppModule> modules) {
    ensureNotDisposed();
    registry.registerAll(modules);
  }

  /// Checks whether a launch request maps to a registered route.
  @override
  bool canLaunch(MiniAppLaunchReq req) {
    if (isDisposed) {
      return false;
    }
    
    return resolveLaunchReq(req) != null;
  }

  /// Pushes a mini-app page for [req].
  @override
  Future<MiniAppLaunchRes> launch(
    BuildContext context,
    MiniAppLaunchReq req,
  ) async {
    if (isDisposed) {
      return buildDisposedFailure(req);
    }

    final ResolvedLaunch? resolved = resolveLaunchReq(req);
    if (resolved == null) {
      final MiniAppLaunchRes failure = buildValidationFailure(req);
      onError?.call(failure, null);
      return failure;
    }

    if (!context.mounted) {
      return MiniAppLaunchRes(
        status: MiniAppLaunchStatus.cancelled,
        route: resolved.routeSpec.path,
      );
    }

    try {
      resolved.module.onLaunchStarted(req);
      onNavigate?.call(resolved.routeSpec.path, req.arguments);
      logger.onInfo(
        'mini_app_launch_started',
        data: <String, Object?>{
          'module': resolved.module.displayName,
          'route': resolved.routeSpec.path,
        },
      );

      final NavigatorState navigator = Navigator.of(
        context,
        rootNavigator: useRootNavigator,
      );

      Object? data = await navigator.push<Object?>(
        MiniAppAnimatedPageRoute<Object?>(
          settings: RouteSettings(name: resolved.routeSpec.path),
          builder: (_) => MiniAppHostControllerScope(
            controller: this,
            child: MiniAppHostShell(
              child: Builder(
                builder: (BuildContext pageContext) {
                  return resolved.module.buildPage(
                    pageContext,
                    resolved.routeSpec.path,
                    req.arguments,
                  );
                },
              ),
            ),
          ),
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
      onError?.call(error, stackTrace);
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

  /// Replaces the current mini-app page with the route from [req].
  @override
  Future<MiniAppLaunchRes> replace(
    BuildContext context,
    MiniAppLaunchReq req,
  ) async {
    if (isDisposed) {
      return buildDisposedFailure(req);
    }

    final ResolvedLaunch? resolved = resolveLaunchReq(req);
    if (resolved == null) {
      final MiniAppLaunchRes failure = buildValidationFailure(req);
      onError?.call(failure, null);
      return failure;
    }

    if (!context.mounted) {
      return MiniAppLaunchRes(
        status: MiniAppLaunchStatus.cancelled,
        route: resolved.routeSpec.path,
      );
    }

    try {
      resolved.module.onLaunchStarted(req);
      onNavigate?.call(resolved.routeSpec.path, req.arguments);
      logger.onInfo(
        'mini_app_launch_replaced',
        data: <String, Object?>{
          'module': resolved.module.displayName,
          'route': resolved.routeSpec.path,
        },
      );

      final NavigatorState navigator = Navigator.of(
        context,
        rootNavigator: useRootNavigator,
      );
      final Object? data = await navigator.pushReplacement<Object?, Object?>(
        MiniAppAnimatedPageRoute<Object?>(
          settings: RouteSettings(name: resolved.routeSpec.path),
          builder: (_) => MiniAppHostControllerScope(
            controller: this,
            child: MiniAppHostShell(
              child: Builder(
                builder: (BuildContext pageContext) {
                  return resolved.module.buildPage(
                    pageContext,
                    resolved.routeSpec.path,
                    req.arguments,
                  );
                },
              ),
            ),
          ),
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
      onError?.call(error, stackTrace);
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

  /// Resolves the requested route to a UI module and route spec.
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

  /// Builds a structured failure for invalid or unregistered routes.
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
        errorMessage:
            'Route "${req.route}" is not declared in module "${module.displayName}".',
      );
    }

    return MiniAppLaunchRes.failure(
      route: req.route,
      errorCode: MiniAppLaunchErrorCode.runtimeError,
      errorMessage: 'Module "${module.displayName}" is not a UI module.',
    );
  }

  /// Builds a structured failure when navigation is attempted after disposal.
  MiniAppLaunchRes buildDisposedFailure(MiniAppLaunchReq req) {
    final MiniAppLaunchRes failure = MiniAppLaunchRes.failure(
      route: req.route,
      errorCode: MiniAppLaunchErrorCode.runtimeError,
      errorMessage: 'Mini app runtime is no longer active.',
    );
    onError?.call(failure, null);
    return failure;
  }

  /// Throws when callers try to mutate the controller after disposal.
  void ensureNotDisposed() {
    if (isDisposed) {
      throw StateError(
        'DefaultMiniAppHostController has already been disposed.',
      );
    }
  }

  /// Marks this controller unusable.
  @override
  void dispose() {
    isDisposed = true;
  }
}

/// Result of resolving a launch request.
class ResolvedLaunch {
  /// UI module that owns the route.
  final UiMiniAppModule module;

  /// Exact route specification matched from [module].
  final MiniAppRouteSpec routeSpec;

  /// Creates a resolved launch result.
  ResolvedLaunch({required this.module, required this.routeSpec});
}
