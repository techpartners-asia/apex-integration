import 'package:flutter/material.dart';

import '../responsive/mini_app_responsive.dart';
import '../theme/mini_app_state_colors.dart';
import 'custom_text.dart';
import 'mini_app_state_panel.dart';

class MiniAppSuccessState extends StatelessWidget {
  final String title;
  final String message;
  final String? actionLabel;
  final VoidCallback? onAction;

  const MiniAppSuccessState({
    super.key,
    required this.title,
    required this.message,
    this.actionLabel,
    this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    final responsive = context.responsive;
    return MiniAppStatePanel(
      title: title,
      message: message,
      surfaceColor: MiniAppStateColors.successSurface,
      borderColor: MiniAppStateColors.successBorder,
      leading: Icon(
        Icons.check_circle_outline_rounded,
        size: responsive.icon(AppComponentSize.icon2xl),
        color: MiniAppStateColors.successForeground,
      ),
      action: actionLabel != null && onAction != null
          ? FilledButton(
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
