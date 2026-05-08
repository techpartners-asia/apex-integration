import 'package:flutter/material.dart';
import 'package:mini_app_ui/mini_app_ui.dart';
import 'package:mini_app_sdk/mini_app_sdk.dart';

class SectionCard extends StatelessWidget {
  final String? title;
  final String? subtitle;
  final List<Widget> children;
  final EdgeInsetsGeometry? padding;
  final bool hasBorder;
  final bool hasShadow;
  final Color? backgroundColor;

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
