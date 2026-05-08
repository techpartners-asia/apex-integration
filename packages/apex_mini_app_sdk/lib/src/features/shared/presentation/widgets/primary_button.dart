import 'package:flutter/material.dart';
import 'package:mini_app_ui/mini_app_ui.dart';
import 'package:mini_app_sdk/mini_app_sdk.dart';

class PrimaryButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final Color foregroundColor;
  final Gradient? enabledGradient;
  final Gradient? disabledGradient;
  final List<BoxShadow>? enabledBoxShadow;
  final BorderRadius? borderRadius;
  final double? height;

  const PrimaryButton({
    super.key,
    required this.label,
    this.onPressed,
    this.icon,
    this.foregroundColor = Colors.white,
    this.enabledGradient,
    this.disabledGradient,
    this.enabledBoxShadow,
    this.borderRadius,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    final responsive = context.responsive;
    final bool enabled = onPressed != null;
    final BorderRadius resolvedBorderRadius =
        borderRadius ?? BorderRadius.circular(responsive.radiusLg);

    return SizedBox(
      height: height ?? responsive.spacing.buttonHeight + 4,
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: enabled
              ? (enabledGradient ?? DesignTokens.primaryGradient)
              : (disabledGradient ?? DesignTokens.disabledGradient),
          borderRadius: resolvedBorderRadius,
          boxShadow: enabled
              ? (enabledBoxShadow ?? DesignTokens.buttonShadow)
              : const <BoxShadow>[],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onPressed,
            borderRadius: resolvedBorderRadius,
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  if (icon != null) ...<Widget>[
                    Icon(icon, color: foregroundColor, size: responsive.dp(20)),
                    SizedBox(width: responsive.spacing.inlineSpacing * 0.6),
                  ],
                  CustomText(
                    label,
                    variant: MiniAppTextVariant.buttonMedium,
                    color: foregroundColor,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
