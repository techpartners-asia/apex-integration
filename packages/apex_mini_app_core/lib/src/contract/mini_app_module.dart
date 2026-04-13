import '../model/route/mini_app_route_spec.dart';

abstract class MiniAppModule {
  const MiniAppModule();

  String get displayName;

  String get initialRoute;

  List<MiniAppRouteSpec> get routes;
}
