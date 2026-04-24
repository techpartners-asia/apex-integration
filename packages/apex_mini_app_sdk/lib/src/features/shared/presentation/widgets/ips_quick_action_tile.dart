import 'package:flutter/material.dart';
import 'package:mini_app_ui/mini_app_ui.dart';
import 'package:mini_app_sdk/mini_app_sdk.dart';

class IpsQuickActionTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final VoidCallback? onTap;
  final String? badgeLabel;
  final bool emphasized;

  const IpsQuickActionTile({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    this.onTap,
    this.badgeLabel,
    this.emphasized = false,
  });

  @override
  Widget build(BuildContext context) {
    final responsive = context.responsive;
    final Gradient gradient = DesignTokens.primaryGradient;
    final Color baseColor = emphasized ? DesignTokens.rose : Colors.white;
    final Color contentColor = emphasized ? Colors.white : DesignTokens.ink;
    final Color subtitleColor = emphasized ? Colors.white.withValues(alpha: 0.78) : DesignTokens.muted;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(responsive.spacing.radiusLarge),
        child: Ink(
          decoration: BoxDecoration(
            gradient: emphasized ? gradient : null,
            color: emphasized ? null : baseColor,
            borderRadius: DesignTokens.cardRadius,
            border: emphasized ? null : Border.all(color: DesignTokens.border),
            // boxShadow: DesignTokens.cardShadow,
          ),
          child: Padding(
            padding: EdgeInsets.all(responsive.spacing.financialCardSpacing),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  width: responsive.spacing.iconSizeMedium + 22,
                  height: responsive.spacing.iconSizeMedium + 22,
                  decoration: BoxDecoration(
                    color: emphasized ? Colors.white.withValues(alpha: 0.18) : DesignTokens.softSurface,
                    borderRadius: BorderRadius.circular(
                      responsive.spacing.radiusMedium,
                    ),
                  ),
                  child: Icon(
                    icon,
                    size: responsive.spacing.iconSizeMedium + 4,
                    color: emphasized ? Colors.white : DesignTokens.rose,
                  ),
                ),
                SizedBox(width: responsive.spacing.inlineSpacing),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      if (badgeLabel != null && badgeLabel!.trim().isNotEmpty) ...<Widget>[
                        IpsStatusChip(
                          label: badgeLabel!,
                          color: emphasized ? Colors.white : DesignTokens.rose,
                          emphasized: emphasized,
                        ),
                        SizedBox(height: responsive.spacing.inlineSpacing),
                      ],
                      Text(
                        title,
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: contentColor,
                          fontWeight: MiniAppTypography.bold,
                        ),
                      ),
                      SizedBox(height: responsive.spacing.inlineSpacing * 0.5),
                      Text(
                        subtitle,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: subtitleColor,
                          height: 1.45,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: responsive.spacing.inlineSpacing),
                Icon(
                  Icons.arrow_forward_rounded,
                  color: emphasized ? Colors.white.withValues(alpha: 0.92) : DesignTokens.rose,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
