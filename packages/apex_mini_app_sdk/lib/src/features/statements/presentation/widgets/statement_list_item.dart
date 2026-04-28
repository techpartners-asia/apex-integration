import 'package:flutter/material.dart';
import 'package:mini_app_ui/mini_app_ui.dart';
import 'package:mini_app_sdk/mini_app_sdk.dart';

class StatementListItem extends StatelessWidget {
  final String title;
  final String subtitle;
  final String trailing;
  final String statusLabel;
  final bool positive;
  final Widget? action;
  final bool showDivider;

  const StatementListItem({
    super.key,
    required this.title,
    required this.subtitle,
    required this.trailing,
    required this.statusLabel,
    this.positive = true,
    this.action,
    this.showDivider = false,
  });

  @override
  Widget build(BuildContext context) {
    final responsive = context.responsive;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        TransactionTile(
          title: title,
          subtitle: subtitle,
          trailing: trailing,
          statusLabel: statusLabel,
          positive: positive,
        ),
        if (action != null)
          Align(alignment: Alignment.centerRight, child: action!),
        if (showDivider) Divider(height: responsive.dp(16)),
      ],
    );
  }
}
