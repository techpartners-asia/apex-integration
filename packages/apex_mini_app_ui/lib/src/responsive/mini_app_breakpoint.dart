import 'mini_app_size_class.dart';

/// Detailed breakpoints used by the mini-app responsive system.
enum MiniAppBreakpoint { compact, phone, widePhone, tablet, largeTablet }

/// Convenience predicates for breakpoint-specific layout choices.
extension MiniAppBreakpointX on MiniAppBreakpoint {
  /// Whether this breakpoint maps to the compact size class.
  bool get isCompact => sizeClass == MiniAppSizeClass.compact;

  /// Whether this breakpoint maps to the medium size class.
  bool get isMedium => sizeClass == MiniAppSizeClass.medium;

  /// Whether this breakpoint maps to the expanded size class.
  bool get isExpanded => sizeClass == MiniAppSizeClass.expanded;

  /// Whether this breakpoint should use phone layout treatment.
  bool get isPhone =>
      this == MiniAppBreakpoint.compact || this == MiniAppBreakpoint.phone;

  /// Whether this breakpoint is a wide-phone viewport.
  bool get isWidePhone => this == MiniAppBreakpoint.widePhone;

  /// Whether this breakpoint is a tablet viewport.
  bool get isTablet => this == MiniAppBreakpoint.tablet;

  /// Whether this breakpoint is a large-tablet viewport.
  bool get isLargeTablet => this == MiniAppBreakpoint.largeTablet;

  /// Whether this breakpoint should use tablet-like layout treatment.
  bool get isTabletLike => isTablet || isLargeTablet;

  /// Higher-level size class for this breakpoint.
  MiniAppSizeClass get sizeClass => switch (this) {
    MiniAppBreakpoint.compact ||
    MiniAppBreakpoint.phone => MiniAppSizeClass.compact,
    MiniAppBreakpoint.widePhone ||
    MiniAppBreakpoint.tablet => MiniAppSizeClass.medium,
    MiniAppBreakpoint.largeTablet => MiniAppSizeClass.expanded,
  };
}
