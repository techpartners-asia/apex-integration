import 'package:mini_app_ui/mini_app_ui.dart';
import 'package:flutter/material.dart';
import 'package:mini_app_sdk/mini_app_sdk.dart';

enum IpsTrendTone { neutral, positive, negative }

class IpsSummaryCard extends StatelessWidget {
  const IpsSummaryCard({
    super.key,
    required this.title,
    required this.primaryValue,
    this.subtitle,
    this.trailing,
    this.trendLabel,
    this.trendTone = IpsTrendTone.neutral,
    this.metrics = const <IpsMetricTile>[],
    this.footer,
    this.icon,
    this.gradient,
  });

  final String title;
  final String primaryValue;
  final String? subtitle;
  final Widget? trailing;
  final String? trendLabel;
  final IpsTrendTone trendTone;
  final List<IpsMetricTile> metrics;
  final Widget? footer;
  final IconData? icon;
  final Gradient? gradient;

  @override
  Widget build(BuildContext context) {
    final responsive = context.responsive;
    final ColorScheme colors = Theme.of(context).colorScheme;
    final bool emphasize = gradient != null;

    final Color titleColor = emphasize ? Colors.white : colors.onSurface;
    final Color subtitleColor = emphasize
        ? Colors.white.withValues(alpha: 0.75)
        : colors.onSurfaceVariant;

    final Color trendColor = switch (trendTone) {
      IpsTrendTone.positive => colors.tertiary,
      IpsTrendTone.negative => colors.error,
      IpsTrendTone.neutral =>
        emphasize ? Colors.white : colors.onSurfaceVariant,
    };

    final int metricColumns = responsive.adaptiveColumns(
      phone: 1,
      tablet: 2,
      largeTablet: 3,
    );
    final double metricWidth = metricColumns <= 1
        ? double.infinity
        : responsive.constraints.maxFinancialCardWidth;

    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: gradient,
        color: gradient == null ? colors.surface : null,
        borderRadius: BorderRadius.circular(responsive.spacing.radiusLarge),
        border: gradient == null
            ? Border.all(color: colors.outlineVariant)
            : null,
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: colors.shadow.withValues(alpha: 0.06),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(responsive.spacing.financialCardSpacing),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                if (icon != null) ...<Widget>[
                  Container(
                    width: responsive.spacing.iconSizeMedium + 14,
                    height: responsive.spacing.iconSizeMedium + 14,
                    decoration: BoxDecoration(
                      color: emphasize
                          ? Colors.white.withValues(alpha: 0.18)
                          : colors.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(
                        responsive.spacing.radiusSmall,
                      ),
                    ),
                    child: Icon(
                      icon,
                      size: responsive.spacing.iconSizeMedium,
                      color: titleColor,
                    ),
                  ),
                  SizedBox(width: responsive.spacing.inlineSpacing),
                ],
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      CustomText(
                        title,
                        variant: MiniAppTextVariant.subtitle2,
                        color: titleColor,
                      ),
                      if (subtitle != null &&
                          subtitle!.trim().isNotEmpty) ...<Widget>[
                        SizedBox(
                          height: responsive.spacing.inlineSpacing * 0.5,
                        ),
                        CustomText(
                          subtitle!,
                          variant: MiniAppTextVariant.caption1,
                          color: subtitleColor,
                        ),
                      ],
                    ],
                  ),
                ),
                if (trailing != null) ...<Widget>[
                  SizedBox(width: responsive.spacing.inlineSpacing),
                  trailing!,
                ],
              ],
            ),
            SizedBox(height: responsive.spacing.sectionSpacing),
            CustomText(
              primaryValue,
              variant: MiniAppTextVariant.h8,
              color: titleColor,
            ),
            if (trendLabel != null &&
                trendLabel!.trim().isNotEmpty) ...<Widget>[
              SizedBox(height: responsive.spacing.inlineSpacing),
              DecoratedBox(
                decoration: BoxDecoration(
                  color: trendColor.withValues(alpha: emphasize ? 0.18 : 0.10),
                  borderRadius: DesignTokens.pillRadius,
                ),
                child: Padding(
                  padding: responsive.insetsSymmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  child: CustomText(
                    trendLabel!,
                    variant: MiniAppTextVariant.caption1,
                    color: trendColor,
                  ),
                ),
              ),
            ],
            if (metrics.isNotEmpty) ...<Widget>[
              SizedBox(height: responsive.spacing.sectionSpacing),
              Wrap(
                spacing: responsive.spacing.cardGap,
                runSpacing: responsive.spacing.cardGap,
                children: metrics
                    .map(
                      (IpsMetricTile tile) =>
                          SizedBox(width: metricWidth, child: tile),
                    )
                    .toList(growable: false),
              ),
            ],
            if (footer != null) ...<Widget>[
              SizedBox(height: responsive.spacing.sectionSpacing),
              footer!,
            ],
          ],
        ),
      ),
    );
  }
}
