import 'package:mini_app_core/mini_app_core.dart';

import '../../../routes/mini_app_routes.dart';

const List<String> ipsRoutes = <String>[
  MiniAppRoutes.splash,
  MiniAppRoutes.overview,
  MiniAppRoutes.secAcnt,
  MiniAppRoutes.questionnaire,
  MiniAppRoutes.packs,
  MiniAppRoutes.contract,
  MiniAppRoutes.portfolio,
  MiniAppRoutes.orders,
  MiniAppRoutes.recharge,
  MiniAppRoutes.sell,
  MiniAppRoutes.statements,
  MiniAppRoutes.help,
  MiniAppRoutes.feedback,
  MiniAppRoutes.reward,
  MiniAppRoutes.personalInfo,
  MiniAppRoutes.liquidGlassDemo,
];

List<MiniAppRouteSpec> buildIpsRoutes() {
  return ipsRoutes
      .map((String route) => MiniAppRouteSpec(path: route))
      .toList(growable: false);
}

bool isKnownIpsRoute(String route) => ipsRoutes.contains(route);
