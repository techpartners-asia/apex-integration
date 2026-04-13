import 'package:flutter/material.dart';
import 'package:mini_app_ui/mini_app_ui.dart';

import 'investx_transaction_tile.dart';

class InvestXStatementListItem extends StatelessWidget {
  final String title;
  final String subtitle;
  final String trailing;
  final String statusLabel;
  final bool positive;
  final Widget? action;
  final bool showDivider;

  const InvestXStatementListItem({
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

    return Padding(
      padding: EdgeInsets.only(bottom: responsive.spacing.inlineSpacing * 0.75),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          InvestXTransactionTile(
            title: title,
            subtitle: subtitle,
            trailing: trailing,
            statusLabel: statusLabel,
            positive: positive,
          ),
          if (action != null) Align(alignment: Alignment.centerRight, child: action!),
          if (showDivider) Divider(height: responsive.dp(16)),
        ],
      ),
    );
  }
}
