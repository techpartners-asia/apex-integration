import 'package:apex_mini_app_sdk/apex_mini_app_sdk.dart';

/// Public InvestX routes registered in the mini-app runtime.
const List<String> ipsRoutes = MiniAppRoutes.publicRoutes;

/// Converts route strings to runtime route specs.
List<MiniAppRouteSpec> buildIpsRoutes() {
  return ipsRoutes
      .map((String route) => MiniAppRouteSpec(path: route))
      .toList(growable: false);
}

/// Returns whether [route] is part of the registered InvestX route table.
bool isKnownIpsRoute(String route) => ipsRoutes.contains(route);
