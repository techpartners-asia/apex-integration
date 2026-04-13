import 'dart:math' as math;

import 'package:flutter/widgets.dart';

import 'mini_app_adaptive_constraints.dart';
import 'mini_app_breakpoints.dart';
import 'mini_app_semantic_tokens.dart';
import 'mini_app_spacing_scale.dart';
import 'mini_app_size_class.dart';

@immutable
class MiniAppResponsiveData {
  static const double _designWidth = 390;
  static const double _minScaleFactor = 0.86;
  static const double _maxScaleFactor = 1.18;

  final double width;
  final double screenHeight;
  final EdgeInsets safePadding;
  final MiniAppBreakpoint breakpoint;
  final MiniAppSpacingScale spacing;
  final MiniAppAdaptiveConstraints constraints;

  const MiniAppResponsiveData({
    required this.width,
    required this.screenHeight,
    required this.safePadding,
    required this.breakpoint,
    required this.spacing,
    required this.constraints,
  });

  factory MiniAppResponsiveData.fromMediaQuery(MediaQueryData mediaQuery) {
    return MiniAppResponsiveData._fromMetrics(
      width: mediaQuery.size.width,
      screenHeight: mediaQuery.size.height,
      safePadding: mediaQuery.padding,
    );
  }

  factory MiniAppResponsiveData.fromWidth(double width) {
    return MiniAppResponsiveData._fromMetrics(
      width: width,
      screenHeight: 0,
      safePadding: EdgeInsets.zero,
    );
  }

  factory MiniAppResponsiveData._fromMetrics({
    required double width,
    required double screenHeight,
    required EdgeInsets safePadding,
  }) {
    final MiniAppBreakpoint breakpoint = MiniAppBreakpoints.fromWidth(width);
    return MiniAppResponsiveData(
      width: width,
      screenHeight: screenHeight,
      safePadding: safePadding,
      breakpoint: breakpoint,
      spacing: MiniAppSpacingScale.forBreakpoint(breakpoint),
      constraints: MiniAppAdaptiveConstraints.forWidth(width, breakpoint),
    );
  }

  MiniAppSizeClass get sizeClass => breakpoint.sizeClass;

  bool get isCompact => sizeClass == MiniAppSizeClass.compact;

  bool get isMedium => sizeClass == MiniAppSizeClass.medium;

  bool get isExpanded => sizeClass == MiniAppSizeClass.expanded;

  bool get isPhone => breakpoint.isPhone;

  bool get isWidePhone => breakpoint.isWidePhone;

  bool get isTablet => breakpoint.isTablet;

  bool get isLargeTablet => breakpoint.isLargeTablet;

  bool get isTabletLike => breakpoint.isTabletLike;

  double get screenWidth => width;

  double get safeTop => safePadding.top;

  double get safeBottom => safePadding.bottom;

  double get usableHeight => math.max(0, screenHeight - safeTop - safeBottom);

  double get pageHorizontalPadding => spacing.pagePadding.horizontal / 2;

  double get maxContentWidth => constraints.maxContentWidth;

  double get scaleFactor {
    final double effectiveWidth = math.min(width, constraints.maxContentWidth);
    final double factor = effectiveWidth / _designWidth;
    return factor.clamp(_minScaleFactor, _maxScaleFactor);
  }

  double get fontScaleFactor => scaleFactor.clamp(0.92, 1.12);

  double dp(num value) => value.toDouble() * scaleFactor;

  double sp(num value) => value.toDouble() * fontScaleFactor;

  double font(num value) => sp(value);

  double space(num token) => dp(token);

  double icon(num token) => dp(token);

  double component(num token) => dp(token);

  double radius(num value) => dp(value);

  EdgeInsets insetsAll(num value) => EdgeInsets.all(dp(value));

  EdgeInsets insetsSymmetric({num horizontal = 0, num vertical = 0}) {
    return EdgeInsets.symmetric(
      horizontal: dp(horizontal),
      vertical: dp(vertical),
    );
  }

  EdgeInsets insetsOnly({
    num left = 0,
    num top = 0,
    num right = 0,
    num bottom = 0,
  }) {
    return EdgeInsets.only(
      left: dp(left),
      top: dp(top),
      right: dp(right),
      bottom: dp(bottom),
    );
  }

  int adaptiveColumns({int phone = 1, int tablet = 2, int largeTablet = 3}) {
    if (isExpanded) {
      return largeTablet;
    }
    if (isMedium) {
      return tablet;
    }
    return phone;
  }

  double get spacingXs => space(AppSpacing.xs);

  double get spacingSm => space(AppSpacing.sm);

  double get spacingMd => space(AppSpacing.md);

  double get spacingLg => space(AppSpacing.lg);

  double get spacingXl => space(AppSpacing.xl);

  double get spacingXxs => space(AppSpacing.xxs);

  double get spacingXxl => space(AppSpacing.xxl);

  double get spacingDisplay => space(AppSpacing.display);

  double get radiusSm => radius(AppRadius.sm);

  double get radiusMd => radius(AppRadius.md);

  double get radiusLg => radius(AppRadius.lg);

  double get radiusXl => radius(AppRadius.xl);

  double get radiusXxl => radius(AppRadius.xxl);

  double get iconXs => icon(AppComponentSize.iconXs);

  double get iconSm => icon(AppComponentSize.iconSm);

  double get iconMd => icon(AppComponentSize.iconMd);

  double get iconLg => icon(AppComponentSize.iconLg);

  double get iconXl => icon(AppComponentSize.iconXl);

  double get icon2xl => icon(AppComponentSize.icon2xl);

  double get controlSm => component(AppComponentSize.controlSm);

  double get controlMd => component(AppComponentSize.controlMd);

  double get closeButtonSize => component(AppComponentSize.closeButton);

  double get buttonHeight => component(AppComponentSize.buttonHeight);

  double get inputHeight => component(AppComponentSize.inputHeight);
}
