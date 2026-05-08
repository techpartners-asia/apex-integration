import 'package:flutter/widgets.dart';

import 'mini_app_host_controller.dart';

class MiniAppHostControllerRegistry {
  static final List<MiniAppHostControllerRegistration> _registrations =
      <MiniAppHostControllerRegistration>[];

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

  static void detach(MiniAppHostControllerRegistration registration) {
    _registrations.remove(registration);
  }

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

  static int get debugActiveRegistrationCount {
    _pruneInactiveRegistrations();
    return _registrations.length;
  }

  static void debugReset() {
    _registrations.clear();
  }

  static void _pruneInactiveRegistrations() {
    _registrations.removeWhere((
      MiniAppHostControllerRegistration registration,
    ) {
      return !registration.context.mounted ||
          _isDisposed(registration.controller);
    });
  }

  static bool _isDisposed(MiniAppHostController controller) {
    final Object candidate = controller;
    if (candidate is MiniAppHostControllerLifecycle) {
      return candidate.isDisposed;
    }
    return false;
  }
}

class MiniAppHostControllerRegistration {
  final MiniAppHostController controller;
  final BuildContext context;

  MiniAppHostControllerRegistration._({
    required this.controller,
    required this.context,
  });
}
