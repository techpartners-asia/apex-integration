import 'package:flutter/material.dart';

import 'mini_app_typography.dart';

extension MiniAppTextThemeContext on BuildContext {
  TextTheme get textTheme => MiniAppTextTheme.of(this);
}

class MiniAppTextTheme {
  static TextTheme of(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return MiniAppTypography.textThemeFor(theme.textTheme);
  }
}
