import 'package:flutter/material.dart';
import 'package:apex_mini_app_sdk/apex_mini_app_sdk.dart';

/// Visual variants for [MessageCard].
enum MessageCardVariant { reminder, accent }

/// Reusable message card for reminders, notices, and inline alerts.
class MessageCard extends StatelessWidget {
  /// Message title.
  final String title;

  /// Message body text.
  final String message;

  /// Optional leading widget.
  final Widget? leading;

  /// Visual style variant.
  final MessageCardVariant variant;

  /// Creates a reusable inline message card.
  const MessageCard({
    super.key,
    required this.title,
    required this.message,
    this.leading,
    this.variant = MessageCardVariant.reminder,
  });

  @override
  Widget build(BuildContext context) {
    final responsive = context.responsive;
    final _MessageCardStyle style = _MessageCardStyle.resolve(
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
                  CustomText(
                    title,
                    variant: style.titleVariant,
                    color: style.titleColor,
                  ),
                  SizedBox(height: responsive.dp(style.messageSpacing)),
                  CustomText(
                    message,
                    variant: style.messageVariant,
                    color: style.messageColor,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Convenience wrapper for a reminder-style [MessageCard].
class ReminderCard extends StatelessWidget {
  /// Reminder title.
  final String title;

  /// Reminder message.
  final String message;

  /// Optional leading widget.
  final Widget? leading;

  /// Creates a reminder-style message card.
  const ReminderCard({
    super.key,
    required this.title,
    required this.message,
    this.leading,
  });

  @override
  Widget build(BuildContext context) {
    return MessageCard(
      title: title,
      message: message,
      leading: leading,
      variant: MessageCardVariant.reminder,
    );
  }
}

final class _MessageCardStyle {
  const _MessageCardStyle({
    required this.backgroundColor,
    required this.borderRadius,
    required this.padding,
    required this.defaultLeading,
    required this.leadingSpacing,
    required this.messageSpacing,
    required this.titleVariant,
    required this.messageVariant,
    this.titleColor,
    this.messageColor,
    this.borderColor,
  });

  /// Card background color.
  final Color backgroundColor;

  /// Card border radius.
  final double borderRadius;

  /// Inner content padding.
  final EdgeInsets padding;

  /// Fallback leading widget when caller does not provide one.
  final Widget defaultLeading;

  /// Gap between leading widget and text column.
  final double leadingSpacing;

  /// Gap between title and message.
  final double messageSpacing;

  /// Typography variant for the title.
  final MiniAppTextVariant titleVariant;

  /// Typography variant for the message.
  final MiniAppTextVariant messageVariant;

  /// Optional title color override.
  final Color? titleColor;

  /// Optional message color override.
  final Color? messageColor;

  /// Optional border color.
  final Color? borderColor;

  /// Creates resolved visual styling for a [MessageCard].
  static _MessageCardStyle resolve(
    BuildContext context,
    MessageCardVariant variant,
  ) {
    final responsive = context.responsive;
    return switch (variant) {
      MessageCardVariant.reminder => _MessageCardStyle(
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
        titleVariant: MiniAppTextVariant.subtitle3,
        messageVariant: MiniAppTextVariant.caption1,
        messageColor: DesignTokens.ink,
      ),
      MessageCardVariant.accent => _MessageCardStyle(
        backgroundColor: DesignTokens.softAccent,
        borderColor: DesignTokens.softAccentBorder,
        borderRadius: responsive.radius(16),
        padding: EdgeInsets.all(responsive.spacing.financialCardSpacing),
        defaultLeading: Icon(
          Icons.info_outline_rounded,
          color: DesignTokens.rose,
          size: responsive.dp(20),
        ),
        leadingSpacing: responsive.spacing.inlineSpacing * 0.75,
        messageSpacing: responsive.spacing.inlineSpacing * 0.35,
        titleVariant: MiniAppTextVariant.buttonMedium,
        titleColor: DesignTokens.ink,
        messageVariant: MiniAppTextVariant.caption1,
      ),
    };
  }
}
