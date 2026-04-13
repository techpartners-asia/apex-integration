import 'package:flutter/material.dart';
import 'package:mini_app_ui/mini_app_ui.dart';

import '../../images/images.dart';
import '../helpers/investx_design_tokens.dart';
import 'custom_image.dart';

enum InvestXMessageCardVariant { reminder, accent }

class InvestXMessageCard extends StatelessWidget {
  const InvestXMessageCard({
    super.key,
    required this.title,
    required this.message,
    this.leading,
    this.variant = InvestXMessageCardVariant.reminder,
  });

  final String title;
  final String message;
  final Widget? leading;
  final InvestXMessageCardVariant variant;

  @override
  Widget build(BuildContext context) {
    final responsive = context.responsive;
    final _InvestXMessageCardStyle style = _InvestXMessageCardStyle.resolve(
      context,
      variant,
    );

    return DecoratedBox(
      decoration: BoxDecoration(
        color: style.backgroundColor,
        borderRadius: BorderRadius.circular(style.borderRadius),
        border: style.borderColor == null
            ? null
            : Border.all(color: style.borderColor!),
      ),
      child: Padding(
        padding: style.padding,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            leading ?? style.defaultLeading,
            SizedBox(width: responsive.dp(style.leadingSpacing)),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(title, style: style.titleStyle),
                  SizedBox(height: responsive.dp(style.messageSpacing)),
                  Text(message, style: style.messageStyle),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class InvestXReminderCard extends StatelessWidget {
  final String title;
  final String message;
  final Widget? leading;

  const InvestXReminderCard({
    super.key,
    required this.title,
    required this.message,
    this.leading,
  });

  @override
  Widget build(BuildContext context) {
    return InvestXMessageCard(
      title: title,
      message: message,
      leading: leading,
      variant: InvestXMessageCardVariant.reminder,
    );
  }
}

final class _InvestXMessageCardStyle {
  const _InvestXMessageCardStyle({
    required this.backgroundColor,
    required this.borderRadius,
    required this.padding,
    required this.defaultLeading,
    required this.leadingSpacing,
    required this.messageSpacing,
    required this.titleStyle,
    required this.messageStyle,
    this.borderColor,
  });

  final Color backgroundColor;
  final double borderRadius;
  final EdgeInsets padding;
  final Widget defaultLeading;
  final double leadingSpacing;
  final double messageSpacing;
  final TextStyle? titleStyle;
  final TextStyle? messageStyle;
  final Color? borderColor;

  static _InvestXMessageCardStyle resolve(
    BuildContext context,
    InvestXMessageCardVariant variant,
  ) {
    final responsive = context.responsive;
    return switch (variant) {
      InvestXMessageCardVariant.reminder => _InvestXMessageCardStyle(
        backgroundColor: Colors.white,
        borderRadius: responsive.radius(16),
        padding: EdgeInsets.all(responsive.dp(18)),
        defaultLeading: CustomImage(
          path: Img.warning,
          width: responsive.dp(26),
          height: responsive.dp(26),
        ),
        leadingSpacing: 10,
        messageSpacing: 6,
        titleStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
          fontWeight: MiniAppTypography.bold,
        ),
        messageStyle: Theme.of(context).textTheme.bodySmall?.copyWith(
          color: InvestXDesignTokens.ink,
          height: 1.55,
        ),
      ),
      InvestXMessageCardVariant.accent => _InvestXMessageCardStyle(
        backgroundColor: InvestXDesignTokens.softAccent,
        borderColor: InvestXDesignTokens.softAccentBorder,
        borderRadius: responsive.radius(16),
        padding: EdgeInsets.all(responsive.spacing.financialCardSpacing),
        defaultLeading: Icon(
          Icons.info_outline_rounded,
          color: InvestXDesignTokens.rose,
          size: responsive.dp(20),
        ),
        leadingSpacing: responsive.spacing.inlineSpacing * 0.75,
        messageSpacing: responsive.spacing.inlineSpacing * 0.35,
        titleStyle: Theme.of(context).textTheme.labelLarge?.copyWith(
          color: InvestXDesignTokens.ink,
        ),
        messageStyle: Theme.of(context).textTheme.bodySmall,
      ),
    };
  }
}
