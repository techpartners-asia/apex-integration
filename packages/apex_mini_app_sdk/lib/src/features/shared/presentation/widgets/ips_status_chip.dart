import 'package:flutter/material.dart';
import 'package:mini_app_ui/mini_app_ui.dart';
import 'package:mini_app_sdk/mini_app_sdk.dart';

class IpsStatusChip extends StatelessWidget {
  final String label;
  final IconData? icon;
  final Color? color;
  final bool emphasized;

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
            Text(
              label,
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                color: foreground,
                fontWeight: MiniAppTypography.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
