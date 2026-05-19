import 'package:flutter/material.dart';
import 'package:apex_mini_app_sdk/apex_mini_app_sdk.dart';

Widget buildSdkTestApp(Widget child, {MiniAppHostController? hostController}) {
  return MiniAppPlatformApp(
    title: 'SDK Test',
    theme: ThemeData(useMaterial3: true),
    localizationsDelegates: SdkLocalizations.localizationsDelegates,
    supportedLocales: SdkLocalizations.supportedLocales,
    home: MiniAppHostControllerScope(
      controller: hostController ?? TestMiniAppHostController(),
      child: child,
    ),
  );
}

class TestMiniAppHostController implements MiniAppHostController {
  final List<MiniAppLaunchReq> launchRequests = <MiniAppLaunchReq>[];
  final List<MiniAppLaunchReq> replaceRequests = <MiniAppLaunchReq>[];

  @override
  bool canLaunch(MiniAppLaunchReq req) => true;

  @override
  void dispose() {}

  @override
  Future<MiniAppLaunchRes> launch(
    BuildContext context,
    MiniAppLaunchReq req,
  ) async {
    launchRequests.add(req);
    return MiniAppLaunchRes(
      status: MiniAppLaunchStatus.success,
      route: req.route,
    );
  }

  @override
  void registerModule(UiMiniAppModule module) {}

  @override
  void registerModules(Iterable<UiMiniAppModule> modules) {}

  @override
  Future<MiniAppLaunchRes> replace(
    BuildContext context,
    MiniAppLaunchReq req,
  ) async {
    replaceRequests.add(req);
    return MiniAppLaunchRes(
      status: MiniAppLaunchStatus.success,
      route: req.route,
    );
  }
}
