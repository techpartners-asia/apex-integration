import 'package:flutter/material.dart';

import '../responsive/mini_app_responsive.dart';
import '../theme/mini_app_state_colors.dart';
import 'custom_text.dart';
import 'mini_app_state_panel.dart';

class MiniAppEmptyState extends StatelessWidget {
  final String title;
  final String message;
  final IconData icon;
  final String? actionLabel;
  final VoidCallback? onAction;

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
                variant: MiniAppTextVariant.button,
              ),
            )
          : null,
    );
  }
}
