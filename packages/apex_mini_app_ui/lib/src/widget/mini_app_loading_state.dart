import 'package:flutter/material.dart';

import '../responsive/mini_app_responsive.dart';
import 'mini_app_state_panel.dart';

/// Standard loading-state panel.
class MiniAppLoadingState extends StatelessWidget {
  /// Loading title.
  final String title;

  /// Loading message.
  final String message;

  /// Creates a loading-state panel.
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
