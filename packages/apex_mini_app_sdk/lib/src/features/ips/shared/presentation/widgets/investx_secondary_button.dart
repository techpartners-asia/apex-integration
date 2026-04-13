import 'package:flutter/material.dart';
import 'package:mini_app_ui/mini_app_ui.dart';

import '../helpers/investx_design_tokens.dart';

class InvestXSecondaryButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final Color backgroundColor;
  final Color foregroundColor;
  final List<BoxShadow> boxShadow;
  final BorderRadius? borderRadius;
  final double? height;

  const InvestXSecondaryButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.backgroundColor = Colors.white,
    this.foregroundColor = InvestXDesignTokens.ink,
    this.boxShadow = const <BoxShadow>[],
    this.borderRadius,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    final responsive = context.responsive;
    final BorderRadius resolvedBorderRadius =
        borderRadius ?? BorderRadius.circular(responsive.radiusLg);

    return SizedBox(
      height: height ?? responsive.component(AppComponentSize.buttonHeight),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: resolvedBorderRadius,
          boxShadow: boxShadow,
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: resolvedBorderRadius,
            onTap: onPressed,
            child: Center(
              child: Text(
                label,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: foregroundColor,
                  fontWeight: MiniAppTypography.semiBold,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
