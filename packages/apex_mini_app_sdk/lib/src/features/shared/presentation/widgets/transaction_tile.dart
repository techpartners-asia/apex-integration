import 'package:flutter/material.dart';
import 'package:mini_app_ui/mini_app_ui.dart';
import 'package:mini_app_sdk/mini_app_sdk.dart';

class TransactionTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final String trailing;
  final String statusLabel;
  final bool positive;

  const TransactionTile({
    super.key,
    required this.title,
    required this.subtitle,
    required this.trailing,
    required this.statusLabel,
    this.positive = true,
  });

  @override
  Widget build(BuildContext context) {
    final responsive = context.responsive;
    final Color accent = positive ? DesignTokens.success : DesignTokens.rose;

    return Padding(
      padding: responsive.insetsSymmetric(vertical: 6),
      child: Row(
        children: <Widget>[
          Container(
            width: responsive.dp(32),
            height: responsive.dp(32),
            decoration: BoxDecoration(
              color: accent.withValues(alpha: 0.12),
              shape: BoxShape.circle,
            ),
            child: Icon(
              positive ? Icons.arrow_downward_rounded : Icons.arrow_upward_rounded,
              color: accent,
              size: responsive.icon(AppComponentSize.iconSm),
            ),
          ),
          SizedBox(width: responsive.space(AppSpacing.md)),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  title,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: MiniAppTypography.bold,
                  ),
                ),
                SizedBox(height: responsive.space(AppSpacing.xxs)),
                Text(subtitle, style: Theme.of(context).textTheme.bodySmall),
              ],
            ),
          ),
          SizedBox(width: responsive.space(AppSpacing.md)),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              Text(
                trailing,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: DesignTokens.ink,
                  fontWeight: MiniAppTypography.bold,
                ),
              ),
              SizedBox(height: responsive.space(AppSpacing.xxs)),
              Text(
                statusLabel,
                style: Theme.of(
                  context,
                ).textTheme.bodySmall?.copyWith(color: accent),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
