import 'dart:ui' show ImageFilter;

import 'package:flutter/material.dart';

import '../responsive/mini_app_responsive.dart';
import '../theme/mini_app_design_tokens.dart';

/// Frosted glass card with blur, [DesignTokens.glassCardDecoration], and shine.
class MiniAppGlassCard extends StatelessWidget {
  /// Card content.
  final Widget child;

  /// Optional internal padding.
  final EdgeInsetsGeometry? padding;

  /// Corner radius passed to [DesignTokens.glassCardDecoration].
  final double radius;

  /// Whether the card shadow should be drawn.
  final bool showShadow;

  /// Backdrop blur strength in design pixels.
  final double blurSigma;

  /// Creates a frosted glass card surface.
  const MiniAppGlassCard({
    super.key,
    required this.child,
    this.padding,
    this.radius = 16,
    this.showShadow = true,
    this.blurSigma = 22,
  });

  @override
  Widget build(BuildContext context) {
    final MiniAppResponsiveData responsive = context.responsive;
    final BorderRadius borderRadius = BorderRadius.circular(radius);
    final Widget cardChild = padding != null
        ? Padding(padding: padding!, child: child)
        : child;

    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: borderRadius,
        boxShadow: showShadow ? DesignTokens.glassCardShadow : null,
      ),
      child: ClipRRect(
        borderRadius: borderRadius,
        child: BackdropFilter(
          filter: ImageFilter.blur(
            sigmaX: responsive.dp(blurSigma),
            sigmaY: responsive.dp(blurSigma),
          ),
          child: Stack(
            children: <Widget>[
              DecoratedBox(
                decoration: DesignTokens.glassCardDecoration(
                  radius: radius,
                  showShadow: false,
                ),
                child: cardChild,
              ),
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: IgnorePointer(
                  child: Container(
                    height: responsive.dp(10),
                    decoration: DesignTokens.glassCardShineDecoration(
                      radius: radius,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
