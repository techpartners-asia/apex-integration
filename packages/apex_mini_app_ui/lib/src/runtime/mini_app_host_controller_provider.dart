import 'package:flutter/widgets.dart';

import 'mini_app_host_controller.dart';
import 'mini_app_host_controller_registry.dart';

/// Inherited provider that exposes the active mini-app host controller.
///
/// Screens should resolve navigation through this provider first so nested
/// routes use the controller that owns the visible mini-app subtree.
class MiniAppHostControllerProvider extends InheritedWidget {
  /// Controller associated with this subtree.
  final MiniAppHostController controller;

  /// Creates a controller provider for a mini-app subtree.
  const MiniAppHostControllerProvider({
    super.key,
    required this.controller,
    required super.child,
  });

  /// Returns the active controller or throws when no usable controller exists.
  static MiniAppHostController of(BuildContext context) {
    final MiniAppHostController? controller = maybeActiveOf(context);

    if (controller == null) {
      throw StateError(
        'No MiniAppHostControllerProvider found in the widget tree.',
      );
    }

    return controller;
  }

  /// Returns the controller stored directly in the nearest provider.
  static MiniAppHostController? maybeOf(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<MiniAppHostControllerProvider>()
        ?.controller;
  }

  /// Returns a usable controller from the local provider or active registry.
  static MiniAppHostController? maybeActiveOf(BuildContext context) {
    final MiniAppHostController? preferred = maybeOf(context);
    return MiniAppHostControllerRegistry.resolveActiveController(preferred);
  }

  /// Returns the latest usable controller from the active registry.
  static MiniAppHostController? get activeController {
    return MiniAppHostControllerRegistry.resolveActiveController();
  }

  /// Returns the mounted context currently registered for [controller].
  static BuildContext? activeContextFor(MiniAppHostController controller) {
    return MiniAppHostControllerRegistry.activeContextFor(controller);
  }

  /// Removes all active registrations for [controller].
  static void detachController(MiniAppHostController controller) {
    MiniAppHostControllerRegistry.detachController(controller);
  }

  /// Number of active controller registrations after pruning stale entries.
  @visibleForTesting
  static int get debugActiveControllerCount {
    return MiniAppHostControllerRegistry.debugActiveRegistrationCount;
  }

  /// Clears registry state for isolated tests.
  @visibleForTesting
  static void debugResetActiveControllers() {
    MiniAppHostControllerRegistry.debugReset();
  }

  /// Notifies dependents when the controller instance changes.
  @override
  bool updateShouldNotify(MiniAppHostControllerProvider oldWidget) {
    return controller != oldWidget.controller;
  }
}
