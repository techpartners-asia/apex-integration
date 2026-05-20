import 'package:flutter/material.dart';
import 'package:apex_mini_app_sdk/apex_mini_app_sdk.dart';

/// Compact status chip with optional icon and emphasized filled state.
class IpsStatusChip extends StatelessWidget {
  /// Status text.
  final String label;

  /// Optional leading icon.
  final IconData? icon;

  /// Optional accent color.
  final Color? color;

  /// Whether to render as filled instead of subtle.
  final bool emphasized;

  /// Creates a compact status chip.
  const IpsStatusChip({
    super.key,
    required this.label,
    this.icon,
    this.color,
    this.emphasized = false,
  });

  @override
  Widget build(BuildContext context) {
    final responsive = context.responsive;
    final Color resolvedColor = color ?? DesignTokens.rose;
    final Color foreground = emphasized ? Colors.white : resolvedColor;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: emphasized
            ? resolvedColor
            : resolvedColor.withValues(alpha: 0.12),
        borderRadius: DesignTokens.pillRadius,
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: responsive.spacing.inlineSpacing,
          vertical: responsive.spacing.inlineSpacing * 0.55,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            if (icon != null) ...<Widget>[
              Icon(
                icon,
                size: responsive.spacing.iconSizeSmall,
                color: foreground,
              ),
              SizedBox(width: responsive.spacing.inlineSpacing * 0.5),
            ],
            CustomText(
              label,
              variant: MiniAppTextVariant.caption1,
              color: foreground,
            ),
          ],
        ),
      ),
    );
  }
}
