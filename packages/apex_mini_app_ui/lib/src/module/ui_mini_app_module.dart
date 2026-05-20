import 'package:apex_mini_app_core/apex_mini_app_core.dart';
import 'package:flutter/widgets.dart';

/// Flutter UI module that can build pages for registered mini-app routes.
abstract class UiMiniAppModule extends MiniAppModule {
  /// Creates a Flutter UI mini-app module contract.
  const UiMiniAppModule();

  /// Builds the widget page for [route] with optional [arguments].
  Widget buildPage(BuildContext context, String route, Object? arguments);

  /// Hook called before the controller opens a route.
  void onLaunchStarted(MiniAppLaunchReq req) {}

  /// Hook called after a route completes or fails to launch.
  void onLaunchFinished(MiniAppLaunchRes res) {}
}
