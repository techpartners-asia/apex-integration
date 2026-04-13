import 'package:flutter/material.dart';
import 'package:mini_app_core/mini_app_core.dart';
import 'package:mini_app_sdk/l10n/sdk_localizations.dart';
import 'package:mini_app_ui/mini_app_ui.dart';

Widget buildSdkTestApp(Widget child, {MiniAppHostController? hostController}) {
  return MiniAppHostControllerProvider(
    controller: hostController ?? TestMiniAppHostController(),
    child: MiniAppPlatformApp(
      title: 'SDK Test',
      theme: ThemeData(useMaterial3: true),
      localizationsDelegates: SdkLocalizations.localizationsDelegates,
      supportedLocales: SdkLocalizations.supportedLocales,
      home: child,
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
