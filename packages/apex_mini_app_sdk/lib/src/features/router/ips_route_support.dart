import 'package:flutter/widgets.dart';
import 'package:mini_app_sdk/mini_app_sdk.dart';

Widget buildGuarded<T>(
  BuildContext context, {
  required String route,
  required T? service,
  required String missingMessage,
  required Widget Function(T service) builder,
}) {
  if (service == null) {
    return missingScreen(context, route, missingMessage);
  }
  return builder(service);
}

Widget missingScreen(BuildContext context, String route, String message) {
  if (!isKnownIpsRoute(route)) {
    return UnavailableScreen(route: route);
  }
  final l10n = context.l10n;
  return DependencyMissingScreen(
    title: resolveIpsRouteTitle(l10n, route),
    subtitle: resolveIpsRouteSubtitle(l10n, route),
    message: message,
  );
}

String resolveIpsRouteTitle(SdkLocalizations l10n, String route) {
  return switch (route) {
    MiniAppRoutes.splash => l10n.ipsSplashTitle,
    MiniAppRoutes.overview => l10n.ipsHomeTitle,
    MiniAppRoutes.secAcnt => l10n.ipsAcntTitle,
    MiniAppRoutes.questionnaire => l10n.ipsQuestionnaireTitle,
    MiniAppRoutes.packs => l10n.ipsPackTitle,
    MiniAppRoutes.contract => l10n.ipsContractTitle,
    MiniAppRoutes.portfolio => l10n.ipsPortfolioTitle,
    MiniAppRoutes.orders => l10n.ipsOrdersTitle,
    MiniAppRoutes.recharge => l10n.ipsPaymentRechargeTitle,
    MiniAppRoutes.sell => l10n.ipsSellTitle,
    MiniAppRoutes.statements => l10n.ipsStatementTitle,
    _ => route,
  };
}

String resolveIpsRouteSubtitle(SdkLocalizations l10n, String route) {
  return switch (route) {
    MiniAppRoutes.splash => l10n.ipsSplashSubtitle,
    MiniAppRoutes.overview => l10n.ipsHomeSubtitle,
    MiniAppRoutes.secAcnt => l10n.ipsAcntSubtitle,
    MiniAppRoutes.questionnaire => l10n.ipsQuestionnaireSubtitle,
    MiniAppRoutes.packs => l10n.ipsPackSubtitle,
    MiniAppRoutes.contract => l10n.ipsContractSubtitle,
    MiniAppRoutes.portfolio => l10n.ipsPortfolioSubtitle,
    MiniAppRoutes.orders => l10n.ipsOrdersSubtitle,
    MiniAppRoutes.recharge => l10n.ipsPaymentRechargeSubtitle,
    MiniAppRoutes.sell => l10n.ipsSellSubtitle,
    MiniAppRoutes.statements => l10n.ipsStatementSubtitle,
    _ => '',
  };
}
