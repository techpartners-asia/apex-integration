import 'package:flutter/material.dart';
import 'package:mini_app_ui/mini_app_ui.dart';

import '../helpers/investx_design_tokens.dart';

class InvestXQuantityButton extends StatelessWidget {
  final IconData icon;
  final bool enabled;
  final VoidCallback onTap;

  const InvestXQuantityButton({
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
      backgroundColor: InvestXDesignTokens.softSurface,
      disabledBackgroundColor: InvestXDesignTokens.neutralChip,
      foregroundColor: InvestXDesignTokens.ink,
    );
  }
}
