import 'package:flutter/material.dart';

import '../responsive/mini_app_responsive.dart';
import '../theme/mini_app_state_colors.dart';

/// Reusable rounded surface used by cards, dialogs, and state panels.
class MiniAppSurfaceCard extends StatelessWidget {
  /// Card content.
  final Widget child;

  /// Internal padding.
  final EdgeInsetsGeometry? padding;

  /// External margin.
  final EdgeInsetsGeometry? margin;

  /// Surface fill color.
  final Color backgroundColor;

  /// Border color used when [hasBorder] is true.
  final Color borderColor;

  /// Optional radius override.
  final double? borderRadius;

  /// Whether to draw a border.
  final bool hasBorder;

  /// Whether to draw the standard card shadow.
  final bool hasShadow;

  /// Creates a reusable mini-app surface card.
  const MiniAppSurfaceCard({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.backgroundColor = Colors.white,
    this.borderColor = MiniAppStateColors.neutralBorder,
    this.borderRadius,
    this.hasBorder = false,
    this.hasShadow = false,
  });

  @override
  Widget build(BuildContext context) {
    final responsive = context.responsive;

    return Container(
      margin: margin,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(
          borderRadius ?? responsive.radius(AppRadius.lg),
        ),
        border: Border.all(color: hasBorder ? borderColor : Colors.transparent),
        boxShadow: hasShadow
            ? <BoxShadow>[
                BoxShadow(
                  color: Color(0x140F172A),
                  blurRadius: 2,
                  offset: Offset(0, 0),
                ),
              ]
            : null,
      ),
      child: Padding(
        padding: padding ?? responsive.insetsAll(AppSpacing.xl),
        child: child,
      ),
    );
  }
}
