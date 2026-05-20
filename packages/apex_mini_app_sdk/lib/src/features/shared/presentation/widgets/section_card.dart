import 'package:flutter/material.dart';
import 'package:apex_mini_app_sdk/apex_mini_app_sdk.dart';

/// Standard white section card with optional title/subtitle.
class SectionCard extends StatelessWidget {
  /// Optional section title.
  final String? title;

  /// Optional supporting subtitle.
  final String? subtitle;

  /// Section content.
  final List<Widget> children;

  /// Padding override.
  final EdgeInsetsGeometry? padding;

  /// Whether border styling should be enabled.
  final bool hasBorder;

  /// Whether card shadow should be enabled.
  final bool hasShadow;

  /// Background color override.
  final Color? backgroundColor;

  /// Creates a standard section card.
  const SectionCard({
    super.key,
    this.title,
    this.subtitle,
    this.children = const <Widget>[],
    this.padding,
    this.hasBorder = false,
    this.hasShadow = false,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    final responsive = context.responsive;

    return MiniAppSurfaceCard(
      hasBorder: false,
      hasShadow: hasShadow,
      backgroundColor: backgroundColor ?? Colors.white,
      borderColor: hasBorder ? DesignTokens.border : Colors.transparent,
      borderRadius: responsive.radius(20),
      padding: padding ?? responsive.insetsAll(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          if (title != null) ...<Widget>[
            CustomText(
              title!,
              variant: MiniAppTextVariant.subtitle2,
            ),
          ],
          if (subtitle != null && subtitle!.trim().isNotEmpty) ...<Widget>[
            SizedBox(height: responsive.spacing.inlineSpacing * 0.5),
            CustomText(
              subtitle!,
              variant: MiniAppTextVariant.caption1,
              color: DesignTokens.muted,
            ),
          ],
          if ((title != null || subtitle != null) && children.isNotEmpty)
            SizedBox(height: responsive.spacing.cardGap),
          ...children,
        ],
      ),
    );
  }
}
