import 'package:flutter/material.dart';

import '../responsive/mini_app_responsive.dart';
import '../theme/mini_app_state_colors.dart';
import 'custom_text.dart';
import 'mini_app_state_panel.dart';

/// Standard empty-state panel.
class MiniAppEmptyState extends StatelessWidget {
  /// Empty-state title.
  final String title;

  /// Empty-state message.
  final String message;

  /// Icon shown above the title.
  final IconData icon;

  /// Optional action button label.
  final String? actionLabel;

  /// Optional action callback.
  final VoidCallback? onAction;

  /// Creates an empty-state panel.
  const MiniAppEmptyState({
    super.key,
    required this.title,
    required this.message,
    this.icon = Icons.inbox_outlined,
    this.actionLabel,
    this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    final responsive = context.responsive;
    return MiniAppStatePanel(
      title: title,
      message: message,
      leading: Icon(
        icon,
        size: responsive.icon(AppComponentSize.icon2xl),
        color: MiniAppStateColors.mutedForeground,
      ),
      action: actionLabel != null && onAction != null
          ? OutlinedButton(
              onPressed: onAction,
              child: CustomText(
                actionLabel!,
                variant: MiniAppTextVariant.buttonMedium,
                color: Theme.of(context).colorScheme.primary,
              ),
            )
          : null,
    );
  }
}
