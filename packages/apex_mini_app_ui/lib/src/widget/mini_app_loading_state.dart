import 'package:flutter/material.dart';

import '../responsive/mini_app_responsive.dart';
import 'mini_app_state_panel.dart';

class MiniAppLoadingState extends StatelessWidget {
  final String title;
  final String message;

  const MiniAppLoadingState({
    super.key,
    required this.title,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    final responsive = context.responsive;
    return MiniAppStatePanel(
      title: title,
      message: message,
      leading: SizedBox(
        width: responsive.spacing.iconSizeMedium + 8,
        height: responsive.spacing.iconSizeMedium + 8,
        child: const CircularProgressIndicator(strokeWidth: 2.4),
      ),
    );
  }
}
