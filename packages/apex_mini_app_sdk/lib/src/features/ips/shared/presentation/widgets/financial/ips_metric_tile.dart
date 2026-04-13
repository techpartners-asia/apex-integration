import 'package:mini_app_ui/mini_app_ui.dart';
import 'package:flutter/material.dart';

class IpsMetricTile extends StatelessWidget {
  const IpsMetricTile({
    super.key,
    required this.label,
    required this.value,
    this.caption,
    this.icon,
    this.toneColor,
  });

  final String label;
  final String value;
  final String? caption;
  final IconData? icon;
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
          Text(
            label,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: colors.onSurfaceVariant,
              fontWeight: MiniAppTypography.semiBold,
            ),
          ),
          SizedBox(height: responsive.spacing.inlineSpacing * 0.5),
          Text(
            value,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: resolvedTone,
              fontWeight: MiniAppTypography.bold,
            ),
          ),
          if (caption != null && caption!.trim().isNotEmpty) ...<Widget>[
            SizedBox(height: responsive.spacing.inlineSpacing * 0.5),
            Text(
              caption!,
              style: Theme.of(
                context,
              ).textTheme.bodySmall?.copyWith(color: colors.onSurfaceVariant),
            ),
          ],
        ],
      ),
    );
  }
}
