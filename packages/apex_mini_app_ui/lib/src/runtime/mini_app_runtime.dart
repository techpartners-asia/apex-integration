import 'package:mini_app_core/mini_app_core.dart';
import 'package:flutter/widgets.dart';

import '../module/ui_mini_app_module.dart';
import 'default_mini_app_host_controller.dart';
import 'mini_app_host_controller.dart';

class MiniAppRuntime {
  final MiniAppHostController controller;
  final List<UiMiniAppModule> registeredModules;

  MiniAppRuntime({
    Iterable<UiMiniAppModule> modules = const <UiMiniAppModule>[],
    void Function(String? routeName, Object? arguments)? onNavigate,
    void Function(Object error, StackTrace? stackTrace)? onError,
  }) : controller = DefaultMiniAppHostController(
         onNavigate: onNavigate,
         onError: onError,
       ),
       registeredModules = List<UiMiniAppModule>.unmodifiable(modules) {
    controller.registerModules(modules);
  }

  List<UiMiniAppModule> get modules => registeredModules;

  Future<MiniAppLaunchRes> launch(BuildContext context, MiniAppLaunchReq req) {
    return controller.launch(context, req);
  }

  Future<MiniAppLaunchRes> replace(BuildContext context, MiniAppLaunchReq req) {
    return controller.replace(context, req);
  }

  void dispose() {
    controller.dispose();
  }
}
