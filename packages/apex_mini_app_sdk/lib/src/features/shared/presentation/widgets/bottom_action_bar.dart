import 'package:flutter/material.dart';
import 'package:apex_mini_app_sdk/apex_mini_app_sdk.dart';

/// Bottom fixed action area with safe-area padding.
class BottomActionBar extends StatelessWidget {
  /// Action content, usually a primary button.
  final Widget child;

  /// Bar background color.
  final Color backgroundColor;

  /// Padding override.
  final EdgeInsetsGeometry? padding;

  /// Creates a fixed bottom action container.
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
