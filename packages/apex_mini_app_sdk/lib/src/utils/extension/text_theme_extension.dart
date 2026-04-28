import 'package:flutter/material.dart';
import 'package:mini_app_ui/mini_app_ui.dart';

extension ContextTextTheme on BuildContext {
  TextTheme get txt {
    final ThemeData theme = Theme.of(this);
    return MiniAppTypography.textThemeFor(theme.textTheme);
  }
}
