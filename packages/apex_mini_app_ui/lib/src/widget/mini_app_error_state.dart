import 'package:flutter/material.dart';

import '../responsive/mini_app_responsive.dart';
import '../theme/mini_app_state_colors.dart';
import 'custom_text.dart';
import 'mini_app_state_panel.dart';

class MiniAppErrorState extends StatelessWidget {
  final String title;
  final String message;
  final String? retryLabel;
  final VoidCallback? onRetry;

  const MiniAppErrorState({
    super.key,
    required this.title,
    required this.message,
    this.retryLabel,
    this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    final responsive = context.responsive;
    return MiniAppStatePanel(
      title: title,
      message: message,
      surfaceColor: MiniAppStateColors.errorSurface,
      borderColor: MiniAppStateColors.errorBorder,
      leading: Icon(
        Icons.error_outline_rounded,
        size: responsive.icon(AppComponentSize.icon2xl),
        color: MiniAppStateColors.errorForeground,
      ),
      action: retryLabel != null && onRetry != null
          ? FilledButton.tonal(
              onPressed: onRetry,
              child: CustomText(
                retryLabel!,
                variant: MiniAppTextVariant.button,
              ),
            )
          : null,
    );
  }
}
