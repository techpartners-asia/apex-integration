import 'package:flutter/material.dart';
import 'package:mini_app_ui/mini_app_ui.dart';

import '../helpers/investx_design_tokens.dart';

class InvestXSectionCard extends StatelessWidget {
  final String? title;
  final String? subtitle;
  final List<Widget> children;
  final EdgeInsetsGeometry? padding;
  final bool hasBorder;
  final bool hasShadow;

  const InvestXSectionCard({
    super.key,
    this.title,
    this.subtitle,
    this.children = const <Widget>[],
    this.padding,
    this.hasBorder = false,
    this.hasShadow = false,
  });

  @override
  Widget build(BuildContext context) {
    final responsive = context.responsive;

    return MiniAppSurfaceCard(
      hasBorder: hasBorder,
      hasShadow: hasShadow,
      backgroundColor: Colors.white,
      borderColor: hasBorder
          ? InvestXDesignTokens.border
          : Colors.transparent,
      borderRadius: responsive.radius(20),
      padding: padding ?? responsive.insetsAll(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          if (title != null) ...<Widget>[
            Text(
              title!,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: MiniAppTypography.bold,
              ),
            ),
          ],
          if (subtitle != null && subtitle!.trim().isNotEmpty) ...<Widget>[
            SizedBox(height: responsive.spacing.inlineSpacing * 0.5),
            Text(
              subtitle!,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: InvestXDesignTokens.muted,
                height: 1.45,
              ),
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
