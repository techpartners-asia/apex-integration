import 'package:flutter/material.dart';
import 'package:mini_app_ui/mini_app_ui.dart';
import 'package:mini_app_sdk/mini_app_sdk.dart';

class SecondaryButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final Color backgroundColor;
  final Color foregroundColor;
  final List<BoxShadow> boxShadow;
  final BorderRadius? borderRadius;
  final double? height;

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
