import 'package:flutter/material.dart';
import 'package:mini_app_ui/mini_app_ui.dart';

import '../helpers/investx_design_tokens.dart';
import 'investx_message_card.dart';

class InvestXNoticeBanner extends StatelessWidget {
  final String title;
  final String message;
  final IconData icon;

  const InvestXNoticeBanner({
    super.key,
    required this.title,
    required this.message,
    this.icon = Icons.info_outline_rounded,
  });

  @override
  Widget build(BuildContext context) {
    return InvestXMessageCard(
      title: title,
      message: message,
      leading: Icon(
        icon,
        color: InvestXDesignTokens.rose,
        size: context.responsive.dp(20),
      ),
      variant: InvestXMessageCardVariant.accent,
    );
  }
}
