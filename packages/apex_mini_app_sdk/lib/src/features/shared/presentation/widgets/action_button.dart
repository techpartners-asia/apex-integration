import 'package:flutter/material.dart';
import 'package:mini_app_ui/mini_app_ui.dart';
import 'package:mini_app_sdk/mini_app_sdk.dart';

class ActionButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final String? img;
  final IconData? icon;
  final IconData? iosIcon;
  final Color foregroundColor;
  final Color backgroundColor;
  final List<BoxShadow>? boxShadow;
  final double? size;
  final double? iconSize;

  const ActionButton({
    super.key,
    required this.onPressed,
    this.img,
    this.icon,
    this.iosIcon,
    required this.foregroundColor,
    this.backgroundColor = DesignTokens.softSurface,
    this.boxShadow,
    this.size,
    this.iconSize,
  });

  @override
  Widget build(BuildContext context) {
    final responsive = context.responsive;

    return MiniAppAdaptiveIconButton(
      onPressed: onPressed,
      img: img,
      icon: icon,
      iosIcon: iosIcon,
      size: size ?? responsive.component(AppComponentSize.controlMd),
      iconSize: iconSize ?? responsive.icon(AppComponentSize.iconMd),
      backgroundColor: backgroundColor,
      foregroundColor: foregroundColor,
      boxShadow: boxShadow,
    );
  }
}
