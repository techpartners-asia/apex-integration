import 'package:apex_mini_app_sdk/apex_mini_app_sdk.dart';
import 'package:flutter/material.dart';

/// Compact metric tile for financial dashboard values.
class IpsMetricTile extends StatelessWidget {
  /// Creates a compact dashboard metric tile.
  const IpsMetricTile({
    super.key,
    required this.label,
    required this.value,
    this.caption,
    this.icon,
    this.toneColor,
  });

  /// Metric label.
  final String label;

  /// Main metric value.
  final String value;

  /// Optional caption below the value.
  final String? caption;

  /// Optional leading icon.
  final IconData? icon;

  /// Optional tone/accent color.
  final Color? toneColor;

  @override
  Widget build(BuildContext context) {
    final responsive = context.responsive;
    final ColorScheme colors = Theme.of(context).colorScheme;
    final Color resolvedTone = toneColor ?? colors.primary;

    return Container(
      constraints: BoxConstraints(
        minHeight:
            responsive.spacing.buttonHeight + responsive.spacing.inlineSpacing,
      ),
      padding: EdgeInsets.all(responsive.spacing.financialCardSpacing),
      decoration: BoxDecoration(
        color: colors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(responsive.spacing.radiusMedium),
        border: Border.all(color: colors.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          if (icon != null) ...<Widget>[
            Icon(
              icon,
              size: responsive.spacing.iconSizeMedium,
              color: resolvedTone,
            ),
            SizedBox(height: responsive.spacing.inlineSpacing),
          ],
          CustomText(
            label,
            variant: MiniAppTextVariant.subtitle3,
            color: colors.onSurfaceVariant,
          ),
          SizedBox(height: responsive.spacing.inlineSpacing * 0.5),
          CustomText(
            value,
            variant: MiniAppTextVariant.subtitle2,
            color: resolvedTone,
          ),
          if (caption != null && caption!.trim().isNotEmpty) ...<Widget>[
            SizedBox(height: responsive.spacing.inlineSpacing * 0.5),
            CustomText(
              caption!,
              variant: MiniAppTextVariant.caption1,
              color: colors.onSurfaceVariant,
            ),
          ],
        ],
      ),
    );
  }
}
