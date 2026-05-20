import 'package:apex_mini_app_sdk/apex_mini_app_sdk.dart';
import 'package:flutter/material.dart';

/// Statement/order list row with optional action and divider.
class StatementListItem extends StatelessWidget {
  /// Main row title.
  final String title;

  /// Supporting row subtitle.
  final String subtitle;

  /// Right-aligned amount/quantity text.
  final String trailing;

  /// Status label shown under trailing text.
  final String statusLabel;

  /// Whether this row should use positive or negative accent styling.
  final bool positive;

  /// Optional row action shown under the tile.
  final Widget? action;

  /// Whether to show a divider after the row.
  final bool showDivider;

  /// Creates a statement/order list item.
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
