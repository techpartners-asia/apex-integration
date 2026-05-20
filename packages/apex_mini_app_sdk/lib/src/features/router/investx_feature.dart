import 'package:apex_mini_app_sdk/apex_mini_app_sdk.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// InvestX mini-app feature module registered with the runtime.
class InvestXFeature extends UiMiniAppModule {
  /// Feature dependency bundle.
  final IpsDependencies dependencies;

  /// Creates the InvestX feature with its dependency bundle.
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
