import 'package:flutter/material.dart';
import 'package:mini_app_sdk/mini_app_sdk.dart';

Future<void> closeSecAcntFlow(BuildContext context) async {
  await Navigator.of(context, rootNavigator: true).maybePop();
}

Future<void> routeAfterSecAcntFlow(
  BuildContext context,
  AcntBootstrapState? state,
) async {
  final bool shouldOpenQuestionnaire =
      state != null && state.hasOpenSecAcnt && !state.hasIpsAcnt;
  final String nextRoute = shouldOpenQuestionnaire
      ? MiniAppRoutes.questionnaire
      : MiniAppRoutes.overview;

  await replaceIpsRoute(context, route: nextRoute, arguments: state);
}
