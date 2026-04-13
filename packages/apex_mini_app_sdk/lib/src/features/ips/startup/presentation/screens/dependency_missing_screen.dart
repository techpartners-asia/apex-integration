import 'package:mini_app_ui/mini_app_ui.dart';
import 'package:flutter/material.dart';

import '../../../shared/presentation/widgets/widgets.dart';

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
    return InvestXResultPageTemplate(
      title: title,
      subtitle: subtitle,
      banner: InvestXNoticeBanner(
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
