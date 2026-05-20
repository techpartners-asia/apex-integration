import 'package:flutter/material.dart';
import 'package:apex_mini_app_sdk/apex_mini_app_sdk.dart';

/// BuildContext extension for the mini-app text theme.
extension ContextTextTheme on BuildContext {
  /// Text theme normalized through [MiniAppTypography].
  TextTheme get txt {
    final ThemeData theme = Theme.of(this);
    return MiniAppTypography.textThemeFor(theme.textTheme);
  }
}
