import 'package:apex_mini_app_core/apex_mini_app_core.dart';
import 'package:flutter/widgets.dart';

import '../module/ui_mini_app_module.dart';
import 'default_mini_app_host_controller.dart';
import 'mini_app_host_controller.dart';

/// Runtime container for UI mini-app modules.
///
/// It creates one host controller, registers all modules, and exposes simple
/// launch/replace methods used by the SDK layer.
class MiniAppRuntime {
  /// Controller that owns navigation and module route resolution.
  final MiniAppHostController controller;

  /// Immutable list of modules registered in this runtime.
  final List<UiMiniAppModule> registeredModules;

  /// Creates a mini-app runtime and registers [modules].
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

  /// Registered modules exposed for initial-route building.
  List<UiMiniAppModule> get modules => registeredModules;

  /// Pushes a mini-app route through the runtime controller.
  Future<MiniAppLaunchRes> launch(BuildContext context, MiniAppLaunchReq req) {
    return controller.launch(context, req);
  }

  /// Replaces the active mini-app route through the runtime controller.
  Future<MiniAppLaunchRes> replace(BuildContext context, MiniAppLaunchReq req) {
    return controller.replace(context, req);
  }

  /// Disposes the runtime controller.
  void dispose() {
    controller.dispose();
  }
}
