import 'package:adaptive_platform_ui/adaptive_platform_ui.dart';
import 'package:flutter/material.dart';

import '../../apex_mini_app_ui.dart';

/// Adaptive icon/image button with SDK sizing and platform behavior.
class MiniAppAdaptiveIconButton extends StatelessWidget {
  /// Optional SDK asset image path.
  final String? img;

  /// Material/default icon.
  final IconData? icon;

  /// iOS-specific icon override.
  final IconData? iosIcon;

  /// Press callback. Null disables the button.
  final VoidCallback? onPressed;

  /// Optional tooltip.
  final String? tooltip;

  /// Outer square size.
  final double size;

  /// Icon or image size.
  final double iconSize;

  /// Inner button padding.
  final EdgeInsetsGeometry padding;

  /// Optional radius override.
  final BorderRadius? borderRadius;

  /// Enabled background color.
  final Color? backgroundColor;

  /// Enabled foreground color.
  final Color? foregroundColor;

  /// Disabled background color override.
  final Color? disabledBackgroundColor;

  /// Disabled foreground color override.
  final Color? disabledForegroundColor;

  /// Optional border.
  final Border? border;

  /// Optional shadow list.
  final List<BoxShadow>? boxShadow;

  /// Whether the shape should be circular.
  final bool circular;

  /// Whether to allow native platform-view rendering when supported.
  final bool useNativePlatformView;

  /// Creates an adaptive icon button.
  const MiniAppAdaptiveIconButton({
    super.key,
    this.img,
    this.icon,
    required this.onPressed,
    this.iosIcon,
    this.tooltip,
    this.size = 40,
    this.iconSize = 20,
    this.padding = EdgeInsets.zero,
    this.borderRadius,
    this.backgroundColor,
    this.foregroundColor,
    this.disabledBackgroundColor,
    this.disabledForegroundColor,
    this.border,
    this.boxShadow,
    this.circular = true,
    this.useNativePlatformView = true,
  });

  @override
  Widget build(BuildContext context) {
    final bool enabled = onPressed != null;
    final BorderRadius radius = borderRadius ?? BorderRadius.circular(circular ? size / 2 : 14);
    final Color? effectiveBackground = enabled ? backgroundColor : disabledBackgroundColor ?? backgroundColor?.withValues(alpha: 0.72);
    final Color? effectiveForeground = enabled ? foregroundColor : disabledForegroundColor ?? foregroundColor?.withValues(alpha: 0.52);
    final IconData resolvedIcon = PlatformInfo.isIOS && iosIcon != null ? iosIcon! : icon ?? Icons.add;
    // The native iOS 26 button implementation is a UiKitView with fixed-height
    // constraints. These icon/custom wrappers apply their own outer sizing, so
    // opting into the platform-view path by default causes UIKit conflicts.
    final bool preferNativePlatformView = useNativePlatformView && PlatformInfo.isIOS26OrHigher();

    Widget child = SizedBox.square(
      dimension: size,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: effectiveBackground,
          borderRadius: radius,
          border: border,
          boxShadow: boxShadow,
        ),
        child: AdaptiveButton.child(
          onPressed: onPressed,
          enabled: enabled,
          style: AdaptiveButtonStyle.glass,
          padding: padding,
          borderRadius: radius,
          minSize: Size.square(size),
          useSmoothRectangleBorder: !circular,
          useNative: preferNativePlatformView,
          child: Center(
            child: (img != null)
                ? Image.asset(
                    img!,
                    package: 'apex_mini_app_sdk',
                    width: iconSize,
                    height: iconSize,
                  )
                : Icon(
                    resolvedIcon,
                    size: iconSize,
                    color: effectiveForeground,
                  ),
          ),
        ),
      ),
    );

    if (tooltip != null && tooltip!.trim().isNotEmpty) {
      child = Tooltip(message: tooltip!, child: child);
    }

    return child;
  }
}

/// Adaptive pressable wrapper for custom child content.
class MiniAppAdaptivePressable extends StatelessWidget {
  /// Press callback.
  final VoidCallback? onPressed;

  /// Pressable content.
  final Widget child;

  /// Inner padding.
  final EdgeInsetsGeometry padding;

  /// Optional radius override.
  final BorderRadius? borderRadius;

  /// Optional minimum size.
  final Size? minSize;

  /// Whether the control should be interactive.
  final bool enabled;

  /// Whether to allow native platform-view rendering when supported.
  final bool useNativePlatformView;

  /// Creates an adaptive pressable region.
  const MiniAppAdaptivePressable({
    super.key,
    required this.onPressed,
    required this.child,
    this.padding = EdgeInsets.zero,
    this.borderRadius,
    this.minSize,
    this.enabled = true,
    this.useNativePlatformView = true,
  });

  @override
  Widget build(BuildContext context) {
    final bool preferNativePlatformView = useNativePlatformView && PlatformInfo.isIOS26OrHigher();

    return AdaptiveButton.child(
      onPressed: onPressed,
      enabled: enabled && onPressed != null,
      style: AdaptiveButtonStyle.glass,
      padding: padding,
      borderRadius: borderRadius ?? BorderRadius.circular(context.responsive.dp(16)),
      minSize: minSize,
      useNative: preferNativePlatformView,
      child: child,
    );
  }
}
