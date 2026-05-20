import 'package:flutter/material.dart';
import 'package:apex_mini_app_sdk/apex_mini_app_sdk.dart';

/// Secondary filled button used for less prominent actions.
class SecondaryButton extends StatelessWidget {
  /// Button label.
  final String label;

  /// Tap action.
  final VoidCallback onPressed;

  /// Button background color.
  final Color backgroundColor;

  /// Button label color.
  final Color foregroundColor;

  /// Optional shadow.
  final List<BoxShadow> boxShadow;

  /// Optional border radius override.
  final BorderRadius? borderRadius;

  /// Optional fixed height.
  final double? height;

  /// Creates a secondary button.
  const SecondaryButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.backgroundColor = Colors.white,
    this.foregroundColor = DesignTokens.ink,
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
              child: CustomText(
                label,
                variant: MiniAppTextVariant.buttonLarge,
                color: foregroundColor,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
