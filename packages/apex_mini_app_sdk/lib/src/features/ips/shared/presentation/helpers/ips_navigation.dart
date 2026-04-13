import 'package:mini_app_core/mini_app_core.dart';
import 'package:mini_app_ui/mini_app_ui.dart';
import 'package:flutter/widgets.dart';

Future<void> launchIpsRoute(
  BuildContext context, {
  required String route,
  Object? arguments,
}) async {
  await MiniAppHostControllerProvider.of(
    context,
  ).launch(context, MiniAppLaunchReq(route: route, arguments: arguments));
}

Future<void> replaceIpsRoute(
  BuildContext context, {
  required String route,
  Object? arguments,
}) async {
  await MiniAppHostControllerProvider.of(
    context,
  ).replace(context, MiniAppLaunchReq(route: route, arguments: arguments));
}
