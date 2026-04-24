import 'package:flutter/material.dart';
import 'package:mini_app_ui/mini_app_ui.dart';
import 'package:mini_app_sdk/mini_app_sdk.dart';

class QuantityButton extends StatelessWidget {
  final IconData icon;
  final bool enabled;
  final VoidCallback onTap;

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
