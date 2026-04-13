import 'package:adaptive_platform_ui/adaptive_platform_ui.dart';
import 'package:flutter/material.dart';
import 'package:mini_app_ui/mini_app_ui.dart';

class MiniAppAdaptiveIconButton extends StatelessWidget {
  final String? img;
  final IconData? icon;
  final IconData? iosIcon;
  final VoidCallback? onPressed;
  final String? tooltip;
  final double size;
  final double iconSize;
  final EdgeInsetsGeometry padding;
  final BorderRadius? borderRadius;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final Color? disabledBackgroundColor;
  final Color? disabledForegroundColor;
  final Border? border;
  final List<BoxShadow>? boxShadow;
  final bool circular;
  final bool useNativePlatformView;

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
                    package: 'mini_app_sdk',
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

class MiniAppAdaptivePressable extends StatelessWidget {
  final VoidCallback? onPressed;
  final Widget child;
  final EdgeInsetsGeometry padding;
  final BorderRadius? borderRadius;
  final Size? minSize;
  final bool enabled;
  final bool useNativePlatformView;

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
