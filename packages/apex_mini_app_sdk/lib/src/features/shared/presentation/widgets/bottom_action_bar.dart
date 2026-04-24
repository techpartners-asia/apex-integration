import 'package:flutter/material.dart';
import 'package:mini_app_ui/mini_app_ui.dart';
import 'package:mini_app_sdk/mini_app_sdk.dart';

class BottomActionBar extends StatelessWidget {
  final Widget child;
  final Color backgroundColor;
  final EdgeInsetsGeometry? padding;

  const BottomActionBar({
    super.key,
    required this.child,
    this.backgroundColor = DesignTokens.softSurface,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    final responsive = context.responsive;

    return ColoredBox(
      color: backgroundColor,
      child: Padding(
        padding:
            padding ??
            EdgeInsets.fromLTRB(
              responsive.space(AppSpacing.xl),
              responsive.space(AppSpacing.xl),
              responsive.space(AppSpacing.xl),
              responsive.safeBottom + responsive.space(AppSpacing.xl),
            ),
        child: child,
      ),
    );
  }
}
