import 'package:flutter/material.dart';
import 'package:apex_mini_app_sdk/apex_mini_app_sdk.dart';

/// List tile used for wizard/action rows with a status icon.
class ActionListTile extends StatelessWidget {
  /// Tile title.
  final String title;

  /// Step/action status that controls icon and color.
  final StepStatus status;

  /// Tap callback.
  final VoidCallback? onTap;

  /// Creates an action/status list tile.
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
