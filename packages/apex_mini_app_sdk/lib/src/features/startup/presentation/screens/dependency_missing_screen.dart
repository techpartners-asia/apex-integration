import 'package:apex_mini_app_sdk/apex_mini_app_sdk.dart';
import 'package:flutter/material.dart';

/// Startup fallback shown when required SDK dependencies are not available.
class DependencyMissingScreen extends StatelessWidget {
  /// Page title.
  final String title;

  /// Page subtitle.
  final String subtitle;

  /// Detailed message explaining what dependency is missing.
  final String message;

  /// Creates the missing-dependency fallback screen.
  const DependencyMissingScreen({
    super.key,
    required this.title,
    required this.subtitle,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return ResultPageTemplate(
      title: title,
      subtitle: subtitle,
      banner: NoticeBanner(
        title: title,
        message: message,
        icon: Icons.info_outline_rounded,
      ),
      content: MiniAppEmptyState(
        title: title,
        message: message,
        icon: Icons.settings_input_component_outlined,
      ),
    );
  }
}
