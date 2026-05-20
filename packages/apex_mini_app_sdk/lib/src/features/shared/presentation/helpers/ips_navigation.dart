import 'package:apex_mini_app_sdk/apex_mini_app_sdk.dart';
import 'package:flutter/widgets.dart';

import '../../../../host/apex_mini_app_host_context.dart';

/// Pushes an IPS mini-app route using the active host controller.
///
/// This helper centralizes controller resolution so screens do not accidentally
/// navigate with a stale/disposed controller captured by an old `BuildContext`.
/// [route] is the target mini-app path; [arguments] is the optional route
/// payload.
Future<void> launchIpsRoute(
  BuildContext context, {
  required String route,
  Object? arguments,
}) async {
  final _ResolvedMiniAppNavigation? resolved = _resolveMiniAppNavigation(
    context,
    route: route,
    action: 'launch',
  );
  if (resolved == null) {
    return;
  }

  await resolved.controller.launch(
    resolved.context,
    MiniAppLaunchReq(route: route, arguments: arguments),
  );
}

/// Replaces the current IPS mini-app route using the active host controller.
///
/// [route] is the target mini-app path; [arguments] is the optional route
/// payload.
Future<void> replaceIpsRoute(
  BuildContext context, {
  required String route,
  Object? arguments,
}) async {
  final _ResolvedMiniAppNavigation? resolved = _resolveMiniAppNavigation(
    context,
    route: route,
    action: 'replace',
  );
  if (resolved == null) {
    return;
  }

  await resolved.controller.replace(
    resolved.context,
    MiniAppLaunchReq(route: route, arguments: arguments),
  );
}

/// Returns whether a usable navigation controller is available for [context].
bool isIpsNavigationControllerAvailable(BuildContext context) {
  if (!context.mounted) {
    return false;
  }

  final MiniAppHostController? localController =
      MiniAppHostControllerProvider.maybeOf(context);
  if (_usableController(localController) != null) {
    return true;
  }

  final MiniAppHostController? registryController =
      MiniAppHostControllerProvider.activeController;
  if (_usableController(registryController) != null) {
    return true;
  }

  final MiniAppHostController? hostController =
      ApexMiniAppHostContext.activeController;
  return _usableController(hostController) != null;
}

/// Resolves navigation dependencies in priority order:
/// local provider, active registry, then host active controller.
_ResolvedMiniAppNavigation? _resolveMiniAppNavigation(
  BuildContext context, {
  required String route,
  required String action,
}) {
  final bool contextMounted = context.mounted;
  final MiniAppHostController? localController = contextMounted
      ? MiniAppHostControllerProvider.maybeOf(context)
      : null;
  final MiniAppHostController? usableLocalController = _usableController(
    localController,
  );
  final MiniAppHostController? registryController = _usableController(
    MiniAppHostControllerProvider.activeController,
  );
  final MiniAppHostController? rawHostController =
      ApexMiniAppHostContext.activeController;
  final MiniAppHostController? hostController = _usableController(
    rawHostController,
  );
  final MiniAppHostController? controller =
      usableLocalController ?? registryController ?? hostController;
  final bool localControllerDisposed = _isDisposed(localController);
  final bool hostControllerDisposed = _isDisposed(rawHostController);
  final bool navigationAttemptedAfterDispose =
      contextMounted &&
      localControllerDisposed &&
      registryController == null &&
      hostController == null;

  if (controller == null) {
    _reportNavigationResolutionFailure(
      MiniAppNavigationControllerMissingException(
        route: route,
        action: action,
        contextMounted: contextMounted,
        localProviderFound: localController != null,
        localControllerDisposed: localControllerDisposed,
        localControllerUsable: usableLocalController != null,
        registryControllerFound: registryController != null,
        hostControllerFound: hostController != null,
        hostControllerDisposed: hostControllerDisposed,
        navigationAttemptedAfterDispose: navigationAttemptedAfterDispose,
      ),
    );
    return null;
  }

  final BuildContext? activeContext =
      MiniAppHostControllerProvider.activeContextFor(controller);
  final BuildContext launchContext = activeContext ?? context;
  if (!launchContext.mounted) {
    _reportNavigationResolutionFailure(
      MiniAppNavigationControllerMissingException(
        route: route,
        action: action,
        contextMounted: contextMounted,
        localProviderFound: localController != null,
        localControllerDisposed: localControllerDisposed,
        localControllerUsable: usableLocalController != null,
        registryControllerFound: registryController != null,
        hostControllerFound: hostController != null,
        hostControllerDisposed: hostControllerDisposed,
        navigationAttemptedAfterDispose: navigationAttemptedAfterDispose,
        reason: 'mini_app_navigation_context_unmounted',
      ),
    );
    return null;
  }

  return _ResolvedMiniAppNavigation(
    controller: controller,
    context: launchContext,
  );
}

/// Returns [controller] only when it is not disposed.
MiniAppHostController? _usableController(MiniAppHostController? controller) {
  if (_isDisposed(controller)) {
    return null;
  }
  return controller;
}

/// Checks the optional lifecycle interface without requiring every controller
/// implementation to expose disposal state.
bool _isDisposed(MiniAppHostController? controller) {
  final Object? candidate = controller;
  return candidate is MiniAppHostControllerLifecycle && candidate.isDisposed;
}

/// Emits a host-visible diagnostic instead of crashing or silently ignoring the
/// navigation request.
void _reportNavigationResolutionFailure(
  MiniAppNavigationControllerMissingException error,
) {
  ApexMiniAppHostContext.emitError(error, StackTrace.current);
  debugPrint('[mini_app] ERROR $error');
}

/// Diagnostic error emitted when internal navigation cannot find a usable
/// controller/context.
class MiniAppNavigationControllerMissingException implements Exception {
  /// Route that navigation attempted to open.
  final String route;

  /// Navigation action, usually `launch` or `replace`.
  final String action;

  /// Whether the caller context was still mounted.
  final bool contextMounted;

  /// Whether a local provider existed in the caller context.
  final bool localProviderFound;

  /// Whether the local provider controller was already disposed.
  final bool localControllerDisposed;

  /// Whether the local provider controller was usable.
  final bool localControllerUsable;

  /// Whether registry fallback returned a usable controller.
  final bool registryControllerFound;

  /// Whether host-context fallback returned a usable controller.
  final bool hostControllerFound;

  /// Whether host-context fallback existed but was disposed.
  final bool hostControllerDisposed;

  /// Whether this looks like delayed navigation after runtime disposal.
  final bool navigationAttemptedAfterDispose;

  /// Machine-readable failure reason.
  final String reason;

  /// Creates a diagnostic exception for unresolved mini-app navigation.
  const MiniAppNavigationControllerMissingException({
    required this.route,
    required this.action,
    required this.contextMounted,
    required this.localProviderFound,
    required this.localControllerDisposed,
    required this.localControllerUsable,
    required this.registryControllerFound,
    required this.hostControllerFound,
    this.hostControllerDisposed = false,
    this.navigationAttemptedAfterDispose = false,
    this.reason = 'mini_app_navigation_controller_missing',
  });

  @override
  String toString() {
    return '$reason('
        'action: $action, '
        'route: $route, '
        'contextMounted: $contextMounted, '
        'localProviderFound: $localProviderFound, '
        'localControllerDisposed: $localControllerDisposed, '
        'localControllerUsable: $localControllerUsable, '
        'registryControllerFound: $registryControllerFound, '
        'hostControllerFound: $hostControllerFound, '
        'hostControllerDisposed: $hostControllerDisposed, '
        'navigationAttemptedAfterDispose: $navigationAttemptedAfterDispose'
        ')';
  }
}

/// Resolved controller/context pair used to perform mini-app navigation.
class _ResolvedMiniAppNavigation {
  /// Usable active controller.
  final MiniAppHostController controller;

  /// Mounted context associated with that controller.
  final BuildContext context;

  const _ResolvedMiniAppNavigation({
    required this.controller,
    required this.context,
  });
}
