import 'package:flutter/widgets.dart';

import 'mini_app_host_controller.dart';

/// Process-local registry of mounted mini-app controller scopes.
///
/// The registry is a fallback for callbacks whose `BuildContext` no longer has
/// a direct provider lookup path, for example delayed/native callbacks.
class MiniAppHostControllerRegistry {
  static final List<MiniAppHostControllerRegistration> _registrations =
      <MiniAppHostControllerRegistration>[];

  /// Registers a controller/context pair while a scope is mounted.
  static MiniAppHostControllerRegistration attach({
    required MiniAppHostController controller,
    required BuildContext context,
  }) {
    final MiniAppHostControllerRegistration registration =
        MiniAppHostControllerRegistration._(
          controller: controller,
          context: context,
        );
    _registrations.add(registration);
    return registration;
  }

  /// Removes one exact registration.
  static void detach(MiniAppHostControllerRegistration registration) {
    _registrations.remove(registration);
  }

  /// Removes every registration owned by [controller].
  static void detachController(MiniAppHostController controller) {
    _registrations.removeWhere((
      MiniAppHostControllerRegistration registration,
    ) {
      return identical(registration.controller, controller);
    });
  }

  /// Resolves a usable controller, preferring the local provider controller.
  ///
  /// Disposed controllers and unmounted contexts are pruned before returning.
  static MiniAppHostController? resolveActiveController([
    MiniAppHostController? preferred,
  ]) {
    _pruneInactiveRegistrations();

    if (preferred != null && !_isDisposed(preferred)) {
      return preferred;
    }

    for (final MiniAppHostControllerRegistration registration
        in _registrations.reversed) {
      final MiniAppHostController controller = registration.controller;
      if (!_isDisposed(controller) && registration.context.mounted) {
        return controller;
      }
    }

    return null;
  }

  /// Returns a mounted context that belongs to [controller].
  static BuildContext? activeContextFor(MiniAppHostController controller) {
    _pruneInactiveRegistrations();

    for (final MiniAppHostControllerRegistration registration
        in _registrations.reversed) {
      if (identical(registration.controller, controller) &&
          registration.context.mounted &&
          !_isDisposed(registration.controller)) {
        return registration.context;
      }
    }

    return null;
  }

  /// Active registration count used by regression tests.
  static int get debugActiveRegistrationCount {
    _pruneInactiveRegistrations();
    return _registrations.length;
  }

  /// Clears all registrations for isolated tests.
  static void debugReset() {
    _registrations.clear();
  }

  /// Removes unmounted or disposed registrations.
  static void _pruneInactiveRegistrations() {
    _registrations.removeWhere((
      MiniAppHostControllerRegistration registration,
    ) {
      return !registration.context.mounted ||
          _isDisposed(registration.controller);
    });
  }

  /// Checks whether the controller exposes lifecycle state and is disposed.
  static bool _isDisposed(MiniAppHostController controller) {
    final Object candidate = controller;
    if (candidate is MiniAppHostControllerLifecycle) {
      return candidate.isDisposed;
    }
    return false;
  }
}

/// One controller/context registration created by a scope.
class MiniAppHostControllerRegistration {
  /// Registered controller.
  final MiniAppHostController controller;

  /// Scope context used as a safe fallback launch context.
  final BuildContext context;

  MiniAppHostControllerRegistration._({
    required this.controller,
    required this.context,
  });
}
