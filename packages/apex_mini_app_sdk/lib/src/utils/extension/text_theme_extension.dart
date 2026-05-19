import 'package:flutter/material.dart';
import 'package:apex_mini_app_ui/apex_mini_app_ui.dart';

extension ContextTextTheme on BuildContext {
  TextTheme get txt {
    final ThemeData theme = Theme.of(this);
    return MiniAppTypography.textThemeFor(theme.textTheme);
  }
}
