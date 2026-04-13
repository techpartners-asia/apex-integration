import 'package:flutter/material.dart';
import 'package:mini_app_ui/mini_app_ui.dart';

import '../helpers/investx_design_tokens.dart';

class InvestXBottomActionBar extends StatelessWidget {
  final Widget child;
  final Color backgroundColor;
  final EdgeInsetsGeometry? padding;

  const InvestXBottomActionBar({
    super.key,
    required this.child,
    this.backgroundColor = InvestXDesignTokens.softSurface,
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
