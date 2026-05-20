import 'dart:math' as math;

import 'package:flutter/foundation.dart';

import 'mini_app_breakpoints.dart';

/// Max-width constraints for common mini-app layout surfaces.
@immutable
class MiniAppAdaptiveConstraints {
  /// Max width for general page content.
  final double maxContentWidth;

  /// Max width for form-heavy content.
  final double maxFormWidth;

  /// Max width for dialogs.
  final double maxDialogWidth;

  /// Max width for modal bottom sheets.
  final double maxBottomSheetWidth;

  /// Max width for financial summary cards.
  final double maxFinancialCardWidth;

  /// Creates adaptive layout constraints for one size class.
  const MiniAppAdaptiveConstraints({
    required this.maxContentWidth,
    required this.maxFormWidth,
    required this.maxDialogWidth,
    required this.maxBottomSheetWidth,
    required this.maxFinancialCardWidth,
  });

  /// Returns constraints appropriate for [width] and [breakpoint].
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
