import 'package:mini_app_core/mini_app_core.dart';
import 'package:mini_app_ui/mini_app_ui.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mini_app_sdk/mini_app_sdk.dart';

class InvestXFeature extends UiMiniAppModule {
  final IpsDependencies dependencies;

  InvestXFeature({required this.dependencies});

  @override
  String get displayName => InvestXFeatureInfo.displayName;

  @override
  String get initialRoute => InvestXFeatureInfo.initialRoute;

  @override
  List<MiniAppRouteSpec> get routes => buildIpsRoutes();

  @override
  void onLaunchStarted(MiniAppLaunchReq req) {
    final Object? arguments = req.arguments;
    if (arguments is MiniAppLaunchContext) {
      dependencies.prepareLaunch(arguments);
    }
  }

  @override
  Widget buildPage(BuildContext context, String route, Object? arguments) {
    final Object? pageArguments = arguments is MiniAppLaunchContext
        ? arguments.arguments
        : arguments;

    return BlocProvider.value(
      value: dependencies.sessionStore,
      child: buildIpsPageForRoute(
        context,
        route: route,
        arguments: pageArguments,
        dependencies: dependencies,
      ),
    );
  }
}
