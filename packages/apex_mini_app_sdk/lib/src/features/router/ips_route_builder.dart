import 'package:flutter/widgets.dart';
import 'package:mini_app_sdk/mini_app_sdk.dart';

Widget buildIpsPageForRoute(
  BuildContext context, {
  required String route,
  required Object? arguments,
  required IpsDependencies dependencies,
}) {
  final l10n = context.l10n;

  switch (route) {
    case MiniAppRoutes.splash:
      return buildIpsSplashPage(
        context,
        route: route,
        dependencies: dependencies,
        l10n: l10n,
      );
    case MiniAppRoutes.overview:
      return buildIpsOverviewPage(
        context,
        route: route,
        arguments: arguments,
        dependencies: dependencies,
        l10n: l10n,
      );
    case MiniAppRoutes.secAcnt:
      return buildIpsSecAcntPage(
        context,
        route: route,
        arguments: arguments,
        dependencies: dependencies,
        l10n: l10n,
      );
    case MiniAppRoutes.questionnaire:
      return buildIpsQuestionnairePage(
        context,
        route: route,
        arguments: arguments,
        dependencies: dependencies,
        l10n: l10n,
      );
    case MiniAppRoutes.packs:
      return buildIpsPackPage(
        context,
        route: route,
        arguments: arguments,
        dependencies: dependencies,
        l10n: l10n,
      );
    case MiniAppRoutes.contract:
      return buildIpsContractPage(
        context,
        route: route,
        arguments: arguments,
        dependencies: dependencies,
        l10n: l10n,
      );
    case MiniAppRoutes.portfolio:
      return buildIpsPortfolioPage(
        context,
        route: route,
        dependencies: dependencies,
        l10n: l10n,
      );
    case MiniAppRoutes.orders:
      return buildIpsOrdersPage(
        context,
        route: route,
        dependencies: dependencies,
        l10n: l10n,
      );
    case MiniAppRoutes.recharge:
      return buildIpsRechargePage(
        context,
        route: route,
        dependencies: dependencies,
        l10n: l10n,
      );
    case MiniAppRoutes.sell:
      return buildIpsSellPage(
        context,
        route: route,
        dependencies: dependencies,
        l10n: l10n,
      );
    case MiniAppRoutes.statements:
      return buildIpsStatementsPage(
        context,
        route: route,
        arguments: arguments,
        dependencies: dependencies,
        l10n: l10n,
      );
    case MiniAppRoutes.help:
      return buildIpsHelpPage(
        context,
        route: route,
        dependencies: dependencies,
        l10n: l10n,
      );
    case MiniAppRoutes.feedback:
      return buildIpsFeedbackPage(
        context,
        route: route,
        dependencies: dependencies,
        l10n: l10n,
      );
    case MiniAppRoutes.reward:
      return buildIpsRewardPage(context, route: route);
    case MiniAppRoutes.personalInfo:
      return buildIpsPersonalInfoPage(
        context,
        route: route,
        dependencies: dependencies,
      );
    default:
      return UnavailableScreen(route: route);
  }
}
