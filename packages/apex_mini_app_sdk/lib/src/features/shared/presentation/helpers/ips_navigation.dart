import 'package:mini_app_core/mini_app_core.dart';
import 'package:mini_app_ui/mini_app_ui.dart';
import 'package:flutter/widgets.dart';

import '../../../../host/apex_mini_app_host_context.dart';

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

MiniAppHostController? _usableController(MiniAppHostController? controller) {
  if (_isDisposed(controller)) {
    return null;
  }
  return controller;
}

bool _isDisposed(MiniAppHostController? controller) {
  final Object? candidate = controller;
  return candidate is MiniAppHostControllerLifecycle && candidate.isDisposed;
}

void _reportNavigationResolutionFailure(
  MiniAppNavigationControllerMissingException error,
) {
  ApexMiniAppHostContext.emitError(error, StackTrace.current);
  debugPrint('[mini_app] ERROR $error');
}

class MiniAppNavigationControllerMissingException implements Exception {
  final String route;
  final String action;
  final bool contextMounted;
  final bool localProviderFound;
  final bool localControllerDisposed;
  final bool localControllerUsable;
  final bool registryControllerFound;
  final bool hostControllerFound;
  final bool hostControllerDisposed;
  final bool navigationAttemptedAfterDispose;
  final String reason;

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

class _ResolvedMiniAppNavigation {
  final MiniAppHostController controller;
  final BuildContext context;

  const _ResolvedMiniAppNavigation({
    required this.controller,
    required this.context,
  });
}
