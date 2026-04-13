import 'package:flutter/material.dart';
import 'package:mini_app_ui/mini_app_ui.dart';

import '../helpers/investx_design_tokens.dart';
import 'investx_menu_list_item.dart';
import 'investx_step_status.dart';

class InvestXActionListTile extends StatelessWidget {
  final String title;
  final InvestXStepStatus status;
  final VoidCallback? onTap;

  const InvestXActionListTile({
    super.key,
    required this.title,
    required this.status,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final responsive = context.responsive;
    final Color accent = switch (status) {
      InvestXStepStatus.completed => InvestXDesignTokens.success,
      InvestXStepStatus.active => InvestXDesignTokens.rose,
      InvestXStepStatus.upcoming => InvestXDesignTokens.border,
    };
    final IconData leadingIcon = switch (status) {
      InvestXStepStatus.completed => Icons.check_circle_rounded,
      InvestXStepStatus.active => Icons.radio_button_checked_rounded,
      InvestXStepStatus.upcoming => Icons.lock_outline_rounded,
    };

    return InvestXMenuListItem(
      title: title,
      onTap: onTap,
      leading: Icon(leadingIcon, color: accent, size: responsive.dp(20)),
      trailing: const Icon(
        Icons.chevron_right_rounded,
        color: InvestXDesignTokens.muted,
      ),
    );
  }
}
