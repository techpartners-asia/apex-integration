import 'package:flutter/foundation.dart';

import 'mini_app_breakpoint.dart';

/// Width thresholds used to map viewport width to mini-app breakpoints.
@immutable
class MiniAppBreakpoints {
  /// Prevents construction.
  const MiniAppBreakpoints._();

  /// Maximum width for compact screens.
  static const double compactMaxWidth = 359;

  /// Maximum width for phone screens.
  static const double phoneMaxWidth = 479;

  /// Maximum width for wide-phone screens.
  static const double widePhoneMaxWidth = 599;

  /// Maximum width for tablet screens.
  static const double tabletMaxWidth = 839;

  /// Resolves the breakpoint for [width].
  static MiniAppBreakpoint fromWidth(double width) {
    if (width <= compactMaxWidth) {
      return MiniAppBreakpoint.compact;
    }
    if (width <= phoneMaxWidth) {
      return MiniAppBreakpoint.phone;
    }
    if (width <= widePhoneMaxWidth) {
      return MiniAppBreakpoint.widePhone;
    }
    if (width <= tabletMaxWidth) {
      return MiniAppBreakpoint.tablet;
    }
    return MiniAppBreakpoint.largeTablet;
  }
}
