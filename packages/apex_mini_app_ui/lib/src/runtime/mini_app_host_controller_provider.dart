import 'package:flutter/widgets.dart';

import 'mini_app_host_controller.dart';
import 'mini_app_host_controller_registry.dart';

class MiniAppHostControllerProvider extends InheritedWidget {
  final MiniAppHostController controller;

  const MiniAppHostControllerProvider({
    super.key,
    required this.controller,
    required super.child,
  });

  static MiniAppHostController of(BuildContext context) {
    final MiniAppHostController? controller = maybeActiveOf(context);

    if (controller == null) {
      throw StateError(
        'No MiniAppHostControllerProvider found in the widget tree.',
      );
    }

    return controller;
  }

  static MiniAppHostController? maybeOf(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<MiniAppHostControllerProvider>()
        ?.controller;
  }

  static MiniAppHostController? maybeActiveOf(BuildContext context) {
    final MiniAppHostController? preferred = maybeOf(context);
    return MiniAppHostControllerRegistry.resolveActiveController(preferred);
  }

  static MiniAppHostController? get activeController {
    return MiniAppHostControllerRegistry.resolveActiveController();
  }

  static BuildContext? activeContextFor(MiniAppHostController controller) {
    return MiniAppHostControllerRegistry.activeContextFor(controller);
  }

  @visibleForTesting
  static int get debugActiveControllerCount {
    return MiniAppHostControllerRegistry.debugActiveRegistrationCount;
  }

  @visibleForTesting
  static void debugResetActiveControllers() {
    MiniAppHostControllerRegistry.debugReset();
  }

  @override
  bool updateShouldNotify(MiniAppHostControllerProvider oldWidget) {
    return controller != oldWidget.controller;
  }
}
