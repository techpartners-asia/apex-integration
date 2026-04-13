import 'dart:math' as math;

import 'package:flutter/foundation.dart';

import 'mini_app_breakpoints.dart';

@immutable
class MiniAppAdaptiveConstraints {
  final double maxContentWidth;
  final double maxFormWidth;
  final double maxDialogWidth;
  final double maxBottomSheetWidth;
  final double maxFinancialCardWidth;

  const MiniAppAdaptiveConstraints({
    required this.maxContentWidth,
    required this.maxFormWidth,
    required this.maxDialogWidth,
    required this.maxBottomSheetWidth,
    required this.maxFinancialCardWidth,
  });

  factory MiniAppAdaptiveConstraints.forWidth(
    double width,
    MiniAppBreakpoint breakpoint,
  ) {
    switch (breakpoint) {
      case MiniAppBreakpoint.compact:
        return MiniAppAdaptiveConstraints(
          maxContentWidth: width,
          maxFormWidth: width,
          maxDialogWidth: math.min(width, 320),
          maxBottomSheetWidth: width,
          maxFinancialCardWidth: width,
        );
      case MiniAppBreakpoint.phone:
        return MiniAppAdaptiveConstraints(
          maxContentWidth: math.min(width, 420),
          maxFormWidth: math.min(width, 400),
          maxDialogWidth: math.min(width, 400),
          maxBottomSheetWidth: math.min(width, 420),
          maxFinancialCardWidth: math.min(width, 420),
        );
      case MiniAppBreakpoint.widePhone:
        return MiniAppAdaptiveConstraints(
          maxContentWidth: math.min(width, 520),
          maxFormWidth: math.min(width, 460),
          maxDialogWidth: math.min(width, 460),
          maxBottomSheetWidth: math.min(width, 520),
          maxFinancialCardWidth: math.min(width, 460),
        );
      case MiniAppBreakpoint.tablet:
        return MiniAppAdaptiveConstraints(
          maxContentWidth: math.min(width, 720),
          maxFormWidth: math.min(width, 560),
          maxDialogWidth: math.min(width, 520),
          maxBottomSheetWidth: math.min(width, 640),
          maxFinancialCardWidth: math.min(width, 320),
        );
      case MiniAppBreakpoint.largeTablet:
        return MiniAppAdaptiveConstraints(
          maxContentWidth: math.min(width, 960),
          maxFormWidth: math.min(width, 640),
          maxDialogWidth: math.min(width, 560),
          maxBottomSheetWidth: math.min(width, 720),
          maxFinancialCardWidth: math.min(width, 360),
        );
    }
  }
}
