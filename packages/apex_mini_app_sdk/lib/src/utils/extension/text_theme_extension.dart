import 'package:flutter/material.dart';
import 'package:apex_mini_app_sdk/apex_mini_app_sdk.dart';

extension ContextTextTheme on BuildContext {
  TextTheme get txt {
    final ThemeData theme = Theme.of(this);
    return MiniAppTypography.textThemeFor(theme.textTheme);
  }
}
