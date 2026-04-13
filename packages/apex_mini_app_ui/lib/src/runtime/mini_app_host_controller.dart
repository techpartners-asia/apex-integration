import 'package:mini_app_core/mini_app_core.dart';
import 'package:flutter/widgets.dart';

import '../module/ui_mini_app_module.dart';

class MiniAppHostController {
  const MiniAppHostController();

  void registerModule(UiMiniAppModule module) {
    throw UnimplementedError();
  }

  void registerModules(Iterable<UiMiniAppModule> modules) {
    throw UnimplementedError();
  }

  bool canLaunch(MiniAppLaunchReq req) {
    throw UnimplementedError();
  }

  Future<MiniAppLaunchRes> launch(BuildContext context, MiniAppLaunchReq req) {
    throw UnimplementedError();
  }

  Future<MiniAppLaunchRes> replace(BuildContext context, MiniAppLaunchReq req) {
    throw UnimplementedError();
  }

  void dispose() {
    throw UnimplementedError();
  }
}
