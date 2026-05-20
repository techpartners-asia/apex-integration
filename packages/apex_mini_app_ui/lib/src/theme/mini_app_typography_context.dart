import 'package:flutter/material.dart';

import 'mini_app_typography.dart';

/// Convenience accessors for the mini-app typography scale.
extension MiniAppTextThemeContext on BuildContext {
  /// Mini-app text theme derived from the nearest Flutter theme.
  TextTheme get textTheme => MiniAppTextTheme.of(this);
}

/// Resolves mini-app typography from a build context.
class MiniAppTextTheme {
  /// Returns a text theme using [MiniAppTypography].
  static TextTheme of(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return MiniAppTypography.textThemeFor(theme.textTheme);
  }
}
