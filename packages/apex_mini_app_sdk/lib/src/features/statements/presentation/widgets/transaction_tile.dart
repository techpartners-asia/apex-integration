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
              positive
                  ? Icons.arrow_downward_rounded
                  : Icons.arrow_upward_rounded,
              color: accent,
              size: responsive.icon(AppComponentSize.iconSm),
            ),
          ),
          SizedBox(width: responsive.space(AppSpacing.md)),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                CustomText(
                  title,
                  variant: MiniAppTextVariant.subtitle3,
                ),
                SizedBox(height: responsive.space(AppSpacing.xxs)),
                CustomText(
                  subtitle,
                  variant: MiniAppTextVariant.caption1,
                ),
              ],
            ),
          ),
          SizedBox(width: responsive.space(AppSpacing.md)),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              CustomText(
                trailing,
                variant: MiniAppTextVariant.subtitle3,
                color: DesignTokens.ink,
              ),
              SizedBox(height: responsive.space(AppSpacing.xxs)),
              CustomText(
                statusLabel,
                variant: MiniAppTextVariant.caption1,
                color: accent,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
