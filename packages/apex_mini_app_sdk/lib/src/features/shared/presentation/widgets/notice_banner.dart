import 'package:flutter/material.dart';
import 'package:apex_mini_app_ui/apex_mini_app_ui.dart';
import 'package:apex_mini_app_sdk/apex_mini_app_sdk_internal.dart';

class NoticeBanner extends StatelessWidget {
  final String title;
  final String message;
  final IconData icon;

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
