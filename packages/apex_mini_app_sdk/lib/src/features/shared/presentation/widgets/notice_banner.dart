import 'package:flutter/material.dart';
import 'package:apex_mini_app_sdk/apex_mini_app_sdk.dart';

/// Accent notice banner used for informational dependency/status messages.
class NoticeBanner extends StatelessWidget {
  /// Banner title.
  final String title;

  /// Banner body text.
  final String message;

  /// Leading icon.
  final IconData icon;

  /// Creates an informational notice banner.
  const NoticeBanner({
    super.key,
    required this.title,
    required this.message,
    this.icon = Icons.info_outline_rounded,
  });

  @override
  Widget build(BuildContext context) {
    return MessageCard(
      title: title,
      message: message,
      leading: Icon(
        icon,
        color: DesignTokens.rose,
        size: context.responsive.dp(20),
      ),
      variant: MessageCardVariant.accent,
    );
  }
}
