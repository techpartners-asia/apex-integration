import 'package:flutter/widgets.dart';

import 'mini_app_host_controller.dart';

class MiniAppHostControllerProvider extends InheritedWidget {
  final MiniAppHostController controller;

  const MiniAppHostControllerProvider({
    super.key,
    required this.controller,
    required super.child,
  });

  static MiniAppHostController of(BuildContext context) {
    final MiniAppHostControllerProvider? provider = context
        .dependOnInheritedWidgetOfExactType<MiniAppHostControllerProvider>();

    if (provider == null) {
      throw StateError(
        'No MiniAppHostControllerProvider found in the widget tree.',
      );
    }

    return provider.controller;
  }

  static MiniAppHostController? maybeOf(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<MiniAppHostControllerProvider>()
        ?.controller;
  }

  @override
  bool updateShouldNotify(MiniAppHostControllerProvider oldWidget) {
    return controller != oldWidget.controller;
  }
}
