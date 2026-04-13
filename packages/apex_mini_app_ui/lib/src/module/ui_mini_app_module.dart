import 'package:mini_app_core/mini_app_core.dart';
import 'package:flutter/widgets.dart';

abstract class UiMiniAppModule extends MiniAppModule {
  const UiMiniAppModule();

  Widget buildPage(BuildContext context, String route, Object? arguments);

  void onLaunchStarted(MiniAppLaunchReq req) {}
  void onLaunchFinished(MiniAppLaunchRes res) {}
}
