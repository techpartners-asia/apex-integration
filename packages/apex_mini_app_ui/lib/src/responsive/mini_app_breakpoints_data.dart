import 'package:flutter/foundation.dart';

import 'mini_app_breakpoint.dart';

@immutable
class MiniAppBreakpoints {
  const MiniAppBreakpoints._();

  static const double compactMaxWidth = 359;
  static const double phoneMaxWidth = 479;
  static const double widePhoneMaxWidth = 599;
  static const double tabletMaxWidth = 839;

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
