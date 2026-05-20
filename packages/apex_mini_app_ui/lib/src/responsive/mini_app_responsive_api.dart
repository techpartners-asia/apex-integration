import 'package:flutter/widgets.dart';

import 'mini_app_responsive_data.dart';

/// Static helpers for resolving responsive metrics.
class MiniAppResponsive {
  /// Prevents construction.
  const MiniAppResponsive._();

  /// Builds responsive data from the nearest `MediaQuery`.
  static MiniAppResponsiveData of(BuildContext context) {
    return MiniAppResponsiveData.fromMediaQuery(MediaQuery.of(context));
  }

  /// Builds responsive data for tests or calculations with only width.
  static MiniAppResponsiveData fromWidth(double width) {
    return MiniAppResponsiveData.fromWidth(width);
  }

  /// Returns the max content width for [width].
  static double maxContentWidthFor(double width) {
    return fromWidth(width).maxContentWidth;
  }

  /// Returns page padding for [width].
  static EdgeInsets contentPaddingFor(double width) {
    return fromWidth(width).spacing.pagePadding;
  }

  /// Returns the max content width for the current context.
  static double maxContentWidth(BuildContext context) {
    return of(context).maxContentWidth;
  }

  /// Returns page padding for the current context.
  static EdgeInsets contentPadding(BuildContext context) {
    return of(context).spacing.pagePadding;
  }
}
