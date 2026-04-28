import 'package:flutter/material.dart';

import '../responsive/mini_app_responsive.dart';
import '../theme/mini_app_state_colors.dart';

class MiniAppSurfaceCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final Color backgroundColor;
  final Color borderColor;
  final double? borderRadius;
  final bool hasBorder;
  final bool hasShadow;

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
