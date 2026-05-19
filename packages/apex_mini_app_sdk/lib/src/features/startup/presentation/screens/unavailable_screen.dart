import 'package:apex_mini_app_ui/apex_mini_app_ui.dart';
import 'package:flutter/material.dart';
import 'package:apex_mini_app_sdk/apex_mini_app_sdk_internal.dart';

class UnavailableScreen extends StatelessWidget {
  const UnavailableScreen({super.key, required this.route});

  final String route;

  @override
  Widget build(BuildContext context) {
    return ResultPageTemplate(
      title: context.l10n.ipsUnknownRouteTitle,
      subtitle: context.l10n.ipsUnknownRouteMessage(route),
      content: MiniAppEmptyState(
        title: context.l10n.ipsUnknownRouteTitle,
        message: context.l10n.ipsUnknownRouteMessage(route),
      ),
    );
  }
}
