import 'package:flutter/material.dart';
import 'package:apex_mini_app_sdk/apex_mini_app_sdk.dart';

/// Shared circular icon/image action button.
class ActionButton extends StatelessWidget {
  /// Press callback. Null disables the button.
  final VoidCallback? onPressed;

  /// Optional SDK asset image.
  final String? img;

  /// Material/default icon.
  final IconData? icon;

  /// iOS icon override.
  final IconData? iosIcon;

  /// Icon/image foreground color.
  final Color foregroundColor;

  /// Button background color.
  final Color backgroundColor;

  /// Optional shadow.
  final List<BoxShadow>? boxShadow;

  /// Size override.
  final double? size;

  /// Icon/image size override.
  final double? iconSize;

  /// Creates a circular adaptive action button.
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
