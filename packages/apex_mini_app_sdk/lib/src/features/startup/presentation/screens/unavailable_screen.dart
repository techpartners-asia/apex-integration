import 'package:apex_mini_app_sdk/apex_mini_app_sdk.dart';
import 'package:flutter/material.dart';

/// Fallback page shown when a route cannot be resolved by the mini app router.
class UnavailableScreen extends StatelessWidget {
  /// Creates the unresolved-route fallback screen.
  const UnavailableScreen({super.key, required this.route});

  /// Route name/path that failed to resolve.
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
