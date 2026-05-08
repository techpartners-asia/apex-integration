import 'package:mini_app_core/mini_app_core.dart';
import 'package:mini_app_sdk/mini_app_sdk.dart';

const List<String> ipsRoutes = MiniAppRoutes.publicRoutes;

List<MiniAppRouteSpec> buildIpsRoutes() {
  return ipsRoutes
      .map((String route) => MiniAppRouteSpec(path: route))
      .toList(growable: false);
}

bool isKnownIpsRoute(String route) => ipsRoutes.contains(route);
