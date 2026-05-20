import 'package:flutter/material.dart';
import 'package:apex_mini_app_sdk/apex_mini_app_sdk.dart';

/// Primary gradient button used for main screen actions.
class PrimaryButton extends StatelessWidget {
  /// Button label.
  final String label;

  /// Press callback. Null disables the button.
  final VoidCallback? onPressed;

  /// Optional leading icon.
  final IconData? icon;

  /// Text/icon color.
  final Color foregroundColor;

  /// Enabled gradient override.
  final Gradient? enabledGradient;

  /// Disabled gradient override.
  final Gradient? disabledGradient;

  /// Enabled shadow override.
  final List<BoxShadow>? enabledBoxShadow;

  /// Border radius override.
  final BorderRadius? borderRadius;

  /// Height override.
  final double? height;

  /// Creates the main gradient action button used by mini-app flows.
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
