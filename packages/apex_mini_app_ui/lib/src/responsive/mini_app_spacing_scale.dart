import 'package:flutter/widgets.dart';

import 'mini_app_breakpoints.dart';

/// Breakpoint-specific spacing, radius, and component size tokens.
@immutable
class MiniAppSpacingScale {
  /// Default page padding for this breakpoint.
  final EdgeInsets pagePadding;

  /// Vertical gap between major sections.
  final double sectionSpacing;

  /// Gap between card-like elements.
  final double cardGap;

  /// Horizontal gap between inline controls.
  final double inlineSpacing;

  /// Small corner radius token.
  final double radiusSmall;

  /// Medium corner radius token.
  final double radiusMedium;

  /// Large corner radius token.
  final double radiusLarge;

  /// Small icon size token.
  final double iconSizeSmall;

  /// Medium icon size token.
  final double iconSizeMedium;

  /// Standard primary button height.
  final double buttonHeight;

  /// Padding used inside modal surfaces.
  final double modalPadding;

  /// Horizontal padding used by financial card layouts.
  final double financialCardSpacing;

  /// Creates a spacing scale with concrete breakpoint token values.
  const MiniAppSpacingScale({
    required this.pagePadding,
    required this.sectionSpacing,
    required this.cardGap,
    required this.inlineSpacing,
    required this.radiusSmall,
    required this.radiusMedium,
    required this.radiusLarge,
    required this.iconSizeSmall,
    required this.iconSizeMedium,
    required this.buttonHeight,
    required this.modalPadding,
    required this.financialCardSpacing,
  });

  /// Returns the spacing scale for [breakpoint].
  factory MiniAppSpacingScale.forBreakpoint(MiniAppBreakpoint breakpoint) {
    switch (breakpoint) {
      case MiniAppBreakpoint.compact:
        return const MiniAppSpacingScale(
          pagePadding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          sectionSpacing: 12,
          cardGap: 10,
          inlineSpacing: 15,
          radiusSmall: 10,
          radiusMedium: 14,
          radiusLarge: 18,
          iconSizeSmall: 16,
          iconSizeMedium: 18,
          buttonHeight: 44,
          modalPadding: 16,
          financialCardSpacing: 12,
        );
      case MiniAppBreakpoint.phone:
        return const MiniAppSpacingScale(
          pagePadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          sectionSpacing: 20,
          cardGap: 16,
          inlineSpacing: 20,
          radiusSmall: 10,
          radiusMedium: 16,
          radiusLarge: 20,
          iconSizeSmall: 16,
          iconSizeMedium: 20,
          buttonHeight: 50,
          modalPadding: 18,
          financialCardSpacing: 20,
        );
      case MiniAppBreakpoint.widePhone:
        return const MiniAppSpacingScale(
          pagePadding: EdgeInsets.symmetric(horizontal: 20, vertical: 18),
          sectionSpacing: 20,
          cardGap: 14,
          inlineSpacing: 20,
          radiusSmall: 12,
          radiusMedium: 18,
          radiusLarge: 22,
          iconSizeSmall: 18,
          iconSizeMedium: 22,
          buttonHeight: 55,
          modalPadding: 20,
          financialCardSpacing: 25,
        );
      case MiniAppBreakpoint.tablet:
        return const MiniAppSpacingScale(
          pagePadding: EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          sectionSpacing: 30,
          cardGap: 16,
          inlineSpacing: 20,
          radiusSmall: 12,
          radiusMedium: 18,
          radiusLarge: 24,
          iconSizeSmall: 18,
          iconSizeMedium: 22,
          buttonHeight: 50,
          modalPadding: 22,
          financialCardSpacing: 30,
        );
      case MiniAppBreakpoint.largeTablet:
        return const MiniAppSpacingScale(
          pagePadding: EdgeInsets.symmetric(horizontal: 28, vertical: 24),
          sectionSpacing: 20,
          cardGap: 18,
          inlineSpacing: 20,
          radiusSmall: 12,
          radiusMedium: 20,
          radiusLarge: 24,
          iconSizeSmall: 18,
          iconSizeMedium: 22,
          buttonHeight: 52,
          modalPadding: 24,
          financialCardSpacing: 35,
        );
    }
  }
}
