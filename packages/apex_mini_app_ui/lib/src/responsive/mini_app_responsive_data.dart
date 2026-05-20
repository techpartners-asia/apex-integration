import 'dart:math' as math;

import 'package:flutter/widgets.dart';

import 'mini_app_adaptive_constraints.dart';
import 'mini_app_breakpoints.dart';
import 'mini_app_semantic_tokens.dart';
import 'mini_app_spacing_scale.dart';
import 'mini_app_size_class.dart';

/// Derived responsive metrics for the current mini-app viewport.
@immutable
class MiniAppResponsiveData {
  static const double _designWidth = 390;
  static const double _minScaleFactor = 0.86;
  static const double _maxScaleFactor = 1.18;

  /// Viewport width.
  final double width;

  /// Viewport height.
  final double screenHeight;

  /// Device safe-area padding.
  final EdgeInsets safePadding;

  /// Breakpoint resolved from [width].
  final MiniAppBreakpoint breakpoint;

  /// Spacing scale for [breakpoint].
  final MiniAppSpacingScale spacing;

  /// Max-width constraints for common layout surfaces.
  final MiniAppAdaptiveConstraints constraints;

  /// Creates responsive data from already resolved viewport metrics.
  const MiniAppResponsiveData({
    required this.width,
    required this.screenHeight,
    required this.safePadding,
    required this.breakpoint,
    required this.spacing,
    required this.constraints,
  });

  /// Creates responsive data from Flutter media query values.
  factory MiniAppResponsiveData.fromMediaQuery(MediaQueryData mediaQuery) {
    return MiniAppResponsiveData._fromMetrics(
      width: mediaQuery.size.width,
      screenHeight: mediaQuery.size.height,
      safePadding: mediaQuery.padding,
    );
  }

  /// Creates responsive data for width-only calculations/tests.
  factory MiniAppResponsiveData.fromWidth(double width) {
    return MiniAppResponsiveData._fromMetrics(
      width: width,
      screenHeight: 0,
      safePadding: EdgeInsets.zero,
    );
  }

  /// Shared constructor path for media-query and width-only factories.
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

  /// High-level size class derived from [breakpoint].
  MiniAppSizeClass get sizeClass => breakpoint.sizeClass;

  /// Whether this viewport should use compact layouts.
  bool get isCompact => sizeClass == MiniAppSizeClass.compact;

  /// Whether this viewport should use medium layouts.
  bool get isMedium => sizeClass == MiniAppSizeClass.medium;

  /// Whether this viewport should use expanded layouts.
  bool get isExpanded => sizeClass == MiniAppSizeClass.expanded;

  /// Whether the current breakpoint is phone-sized.
  bool get isPhone => breakpoint.isPhone;

  /// Whether the current breakpoint is a wide phone.
  bool get isWidePhone => breakpoint.isWidePhone;

  /// Whether the current breakpoint is tablet-sized.
  bool get isTablet => breakpoint.isTablet;

  /// Whether the current breakpoint is large-tablet-sized.
  bool get isLargeTablet => breakpoint.isLargeTablet;

  /// Whether tablet-style layouts should be used.
  bool get isTabletLike => breakpoint.isTabletLike;

  /// Alias for [width] used by existing widget code.
  double get screenWidth => width;

  /// Top safe-area inset.
  double get safeTop => safePadding.top;

  /// Bottom safe-area inset.
  double get safeBottom => safePadding.bottom;

  /// Height after subtracting top and bottom safe-area padding.
  double get usableHeight => math.max(0, screenHeight - safeTop - safeBottom);

  /// Horizontal page padding resolved for the active breakpoint.
  double get pageHorizontalPadding => spacing.pagePadding.horizontal / 2;

  /// Maximum content width resolved for the active breakpoint.
  double get maxContentWidth => constraints.maxContentWidth;

  /// Bounded layout scale factor relative to the base design width.
  double get scaleFactor {
    final double effectiveWidth = math.min(width, constraints.maxContentWidth);
    final double factor = effectiveWidth / _designWidth;
    return factor.clamp(_minScaleFactor, _maxScaleFactor);
  }

  /// Bounded font scale factor derived from [scaleFactor].
  double get fontScaleFactor => scaleFactor.clamp(0.92, 1.12);

  /// Scales a design pixel value using the bounded layout scale factor.
  double dp(num value) => value.toDouble() * scaleFactor;

  /// Scales a font value using the bounded font scale factor.
  double sp(num value) => value.toDouble() * fontScaleFactor;

  /// Alias for [sp] at call sites that pass font-size tokens.
  double font(num value) => sp(value);

  /// Alias for [dp] at call sites that pass spacing tokens.
  double space(num token) => dp(token);

  /// Alias for [dp] at call sites that pass icon-size tokens.
  double icon(num token) => dp(token);

  /// Alias for [dp] at call sites that pass component-size tokens.
  double component(num token) => dp(token);

  /// Scales a radius token using the bounded layout scale.
  double radius(num value) => dp(value);

  /// Returns equal insets scaled from design pixels.
  EdgeInsets insetsAll(num value) => EdgeInsets.all(dp(value));

  /// Returns symmetric insets scaled from design pixels.
  EdgeInsets insetsSymmetric({num horizontal = 0, num vertical = 0}) {
    return EdgeInsets.symmetric(
      horizontal: dp(horizontal),
      vertical: dp(vertical),
    );
  }

  /// Returns directional insets scaled from design pixels.
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

  /// Returns a responsive column count for compact/medium/expanded layouts.
  int adaptiveColumns({int phone = 1, int tablet = 2, int largeTablet = 3}) {
    if (isExpanded) {
      return largeTablet;
    }
    if (isMedium) {
      return tablet;
    }
    return phone;
  }

  /// Scaled extra-small spacing token.
  double get spacingXs => space(AppSpacing.xs);

  /// Scaled small spacing token.
  double get spacingSm => space(AppSpacing.sm);

  /// Scaled medium spacing token.
  double get spacingMd => space(AppSpacing.md);

  /// Scaled large spacing token.
  double get spacingLg => space(AppSpacing.lg);

  /// Scaled extra-large spacing token.
  double get spacingXl => space(AppSpacing.xl);

  /// Scaled extra-extra-small spacing token.
  double get spacingXxs => space(AppSpacing.xxs);

  /// Scaled extra-extra-large spacing token.
  double get spacingXxl => space(AppSpacing.xxl);

  /// Scaled display spacing token.
  double get spacingDisplay => space(AppSpacing.display);

  /// Scaled small radius token.
  double get radiusSm => radius(AppRadius.sm);

  /// Scaled medium radius token.
  double get radiusMd => radius(AppRadius.md);

  /// Scaled large radius token.
  double get radiusLg => radius(AppRadius.lg);

  /// Scaled extra-large radius token.
  double get radiusXl => radius(AppRadius.xl);

  /// Scaled extra-extra-large radius token.
  double get radiusXxl => radius(AppRadius.xxl);

  /// Scaled extra-small icon token.
  double get iconXs => icon(AppComponentSize.iconXs);

  /// Scaled small icon token.
  double get iconSm => icon(AppComponentSize.iconSm);

  /// Scaled medium icon token.
  double get iconMd => icon(AppComponentSize.iconMd);

  /// Scaled large icon token.
  double get iconLg => icon(AppComponentSize.iconLg);

  /// Scaled extra-large icon token.
  double get iconXl => icon(AppComponentSize.iconXl);

  /// Scaled double-extra-large icon token.
  double get icon2xl => icon(AppComponentSize.icon2xl);

  /// Scaled small control height token.
  double get controlSm => component(AppComponentSize.controlSm);

  /// Scaled medium control height token.
  double get controlMd => component(AppComponentSize.controlMd);

  /// Scaled close-button size token.
  double get closeButtonSize => component(AppComponentSize.closeButton);

  /// Scaled primary button height token.
  double get buttonHeight => component(AppComponentSize.buttonHeight);

  /// Scaled input height token.
  double get inputHeight => component(AppComponentSize.inputHeight);
}
