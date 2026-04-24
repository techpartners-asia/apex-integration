import 'package:flutter/material.dart';
import 'package:mini_app_ui/mini_app_ui.dart';
import 'package:mini_app_sdk/mini_app_sdk.dart';

class ActionListTile extends StatelessWidget {
  final String title;
  final StepStatus status;
  final VoidCallback? onTap;

  const ActionListTile({
    super.key,
    required this.title,
    required this.status,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final responsive = context.responsive;
    final Color accent = switch (status) {
      StepStatus.completed => DesignTokens.success,
      StepStatus.active => DesignTokens.rose,
      StepStatus.upcoming => DesignTokens.border,
    };
    final IconData leadingIcon = switch (status) {
      StepStatus.completed => Icons.check_circle_rounded,
      StepStatus.active => Icons.radio_button_checked_rounded,
      StepStatus.upcoming => Icons.lock_outline_rounded,
    };

    return MenuListItem(
      title: title,
      onTap: onTap,
      leading: Icon(leadingIcon, color: accent, size: responsive.dp(20)),
      trailing: const Icon(
        Icons.chevron_right_rounded,
        color: DesignTokens.muted,
      ),
    );
  }
}
