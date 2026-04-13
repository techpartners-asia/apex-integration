import 'mini_app_size_class.dart';

enum MiniAppBreakpoint { compact, phone, widePhone, tablet, largeTablet }

extension MiniAppBreakpointX on MiniAppBreakpoint {
  bool get isCompact => sizeClass == MiniAppSizeClass.compact;

  bool get isMedium => sizeClass == MiniAppSizeClass.medium;

  bool get isExpanded => sizeClass == MiniAppSizeClass.expanded;

  bool get isPhone =>
      this == MiniAppBreakpoint.compact || this == MiniAppBreakpoint.phone;

  bool get isWidePhone => this == MiniAppBreakpoint.widePhone;

  bool get isTablet => this == MiniAppBreakpoint.tablet;

  bool get isLargeTablet => this == MiniAppBreakpoint.largeTablet;

  bool get isTabletLike => isTablet || isLargeTablet;

  MiniAppSizeClass get sizeClass => switch (this) {
    MiniAppBreakpoint.compact ||
    MiniAppBreakpoint.phone => MiniAppSizeClass.compact,
    MiniAppBreakpoint.widePhone ||
    MiniAppBreakpoint.tablet => MiniAppSizeClass.medium,
    MiniAppBreakpoint.largeTablet => MiniAppSizeClass.expanded,
  };
}
