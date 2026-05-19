import 'package:apex_mini_app_core/apex_mini_app_core.dart';
import 'package:apex_mini_app_sdk/apex_mini_app_sdk_internal.dart';

const List<String> ipsRoutes = MiniAppRoutes.publicRoutes;

List<MiniAppRouteSpec> buildIpsRoutes() {
  return ipsRoutes
      .map((String route) => MiniAppRouteSpec(path: route))
      .toList(growable: false);
}

bool isKnownIpsRoute(String route) => ipsRoutes.contains(route);
