import 'package:apex_mini_app_core/apex_mini_app_core.dart';
import 'package:flutter/widgets.dart';

import '../module/ui_mini_app_module.dart';

/// Navigation controller used by mini-app screens to launch/replace routes.
abstract interface class MiniAppHostController {
  /// Registers one UI module and its route table.
  void registerModule(UiMiniAppModule module);

  /// Registers multiple UI modules.
  void registerModules(Iterable<UiMiniAppModule> modules);

  /// Returns whether [req] can be resolved to a registered UI route.
  bool canLaunch(MiniAppLaunchReq req);

  /// Pushes the requested mini-app route.
  Future<MiniAppLaunchRes> launch(BuildContext context, MiniAppLaunchReq req);

  /// Replaces the current mini-app route with the requested route.
  Future<MiniAppLaunchRes> replace(BuildContext context, MiniAppLaunchReq req);

  /// Releases the controller and prevents future navigation.
  void dispose();
}

/// Optional lifecycle contract used to filter disposed controllers from lookup.
abstract interface class MiniAppHostControllerLifecycle {
  /// Whether this controller has been disposed.
  bool get isDisposed;
}
