import 'package:flutter/material.dart';
import 'package:mini_app_ui/mini_app_ui.dart';
import 'package:mini_app_sdk/mini_app_sdk.dart';

class DependencyMissingScreen extends StatelessWidget {
  final String title;
  final String subtitle;
  final String message;

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
