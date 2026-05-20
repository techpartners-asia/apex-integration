import 'package:flutter/material.dart';
import 'package:apex_mini_app_sdk/apex_mini_app_sdk.dart';

/// Circular quantity increment/decrement button.
class QuantityButton extends StatelessWidget {
  /// Icon to display.
  final IconData icon;

  /// Whether the button can be tapped.
  final bool enabled;

  /// Tap callback when enabled.
  final VoidCallback onTap;

  /// Creates an increment/decrement control button.
  const QuantityButton({
    super.key,
    required this.icon,
    required this.enabled,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final responsive = context.responsive;

    return MiniAppAdaptiveIconButton(
      onPressed: enabled ? onTap : null,
      icon: icon,
      size: responsive.spacing.buttonHeight,
      iconSize: responsive.icon(AppComponentSize.iconMd),
      backgroundColor: DesignTokens.softSurface,
      disabledBackgroundColor: DesignTokens.neutralChip,
      foregroundColor: DesignTokens.ink,
    );
  }
}
