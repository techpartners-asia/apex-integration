import 'package:mini_app_core/mini_app_core.dart';
import 'package:flutter/widgets.dart';

import '../module/ui_mini_app_module.dart';

abstract interface class MiniAppHostController {
  void registerModule(UiMiniAppModule module);

  void registerModules(Iterable<UiMiniAppModule> modules);

  bool canLaunch(MiniAppLaunchReq req);

  Future<MiniAppLaunchRes> launch(BuildContext context, MiniAppLaunchReq req);

  Future<MiniAppLaunchRes> replace(BuildContext context, MiniAppLaunchReq req);

  void dispose();
}

abstract interface class MiniAppHostControllerLifecycle {
  bool get isDisposed;
}
