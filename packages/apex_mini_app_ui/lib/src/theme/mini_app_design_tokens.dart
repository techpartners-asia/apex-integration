import 'package:flutter/material.dart';

import 'mini_app_typography.dart';

/// Shared visual design tokens used by SDK widgets.
final class DesignTokens {
  /// Primary pink brand color.
  static const Color rose = Color(0xFFE94C86);

  /// Deeper pink accent color.
  static const Color deepPink = Color(0xFFDD4F80);

  /// Warm peach accent color.
  static const Color softPeach = Color(0xFFFB9D6C);

  /// Orange-coral accent color.
  static const Color coral = Color(0xFFFFA06C);

  /// Teal accent color.
  static const Color teal = Color(0xFF1AA6A4);

  /// Primary teal brand color.
  static const Color primaryTeal = Color(0xFF009685);

  /// Dark teal accent color.
  static const Color darkTeal = Color(0xFF00727C);

  /// Primary text color on light surfaces.
  static const Color ink = Color(0xFF252C39);

  /// Secondary text color.
  static const Color muted = Color(0xFF717887);

  /// Standard border color.
  static const Color border = Color(0xFFE8EBF2);

  /// App background surface color.
  static const Color softSurface = Color(0xFFF6F7FB);

  /// Bottom-sheet background surface color.
  static const Color sheetBackground = Color(0xFFF7F8FC);

  /// Soft warning/accent fill color.
  static const Color softAccent = Color(0xFFFDF1D9);

  /// Border color for soft accent surfaces.
  static const Color softAccentBorder = Color(0xFFF3D28C);

  /// Success accent color.
  static const Color success = Color(0xFF24C15F);

  /// Strong success accent color.
  static const Color successStrong = Color(0xFF22C55E);

  /// Error/danger accent color.
  static const Color danger = Color(0xFFE55B63);

  /// Neutral chip background color.
  static const Color neutralChip = Color(0xFFEEF1F7);

  /// Blue selection accent color.
  static const Color selectionBlue = Color(0xFF386BFF);

  /// Border color for blue selection controls.
  static const Color selectionBlueBorder = Color(0xFFE6EAF2);

  /// Muted blue-gray selection color.
  static const Color selectionBlueMuted = Color(0xFFC5CBD8);

  /// Light rose tint.
  static const Color roseTint = Color(0xFFFFC5DA);

  /// Translucent rose glow.
  static const Color roseGlow = Color(0x2EE94C86);

  /// Checkbox/radio unchecked border color.
  static const Color agreementUnchecked = Color(0xFFD6D9E0);

  /// White constant for design-token call sites.
  static const Color white = Colors.white;

  /// Primary warm brand gradient.
  static const Gradient primaryGradient = LinearGradient(
    colors: <Color>[rose, coral],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );

  /// Pink-to-teal gradient used for recommended pack surfaces.
  static const Gradient coolGradient = LinearGradient(
    colors: <Color>[rose, teal],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  /// Disabled button/control gradient.
  static const Gradient disabledGradient = LinearGradient(
    colors: <Color>[Color(0xFFE1E5EC), Color(0xFFD6DAE3)],
  );

  /// Standard card elevation shadow.
  static const List<BoxShadow> cardShadow = <BoxShadow>[
    BoxShadow(color: Color(0x140F172A), blurRadius: 24, offset: Offset(0, 12)),
  ];

  /// Standard primary button shadow.
  static const List<BoxShadow> buttonShadow = <BoxShadow>[
    BoxShadow(color: Color(0x33E94C86), blurRadius: 18, offset: Offset(0, 8)),
  ];

  /// Standard card corner radius.
  static const BorderRadius cardRadius = BorderRadius.all(Radius.circular(20));

  /// Fully rounded pill corner radius.
  static const BorderRadius pillRadius = BorderRadius.all(Radius.circular(999));

  /// Applies mini-app colors and typography to a host/base theme.
  static ThemeData theme(ThemeData base) {
    final ThemeData typedBase = MiniAppTypography.apply(base);
    final ColorScheme scheme = typedBase.colorScheme.copyWith(
      primary: rose,
      secondary: coral,
      tertiary: teal,
      surface: Colors.white,
      surfaceContainerLowest: softSurface,
      surfaceContainerLow: softSurface,
      surfaceContainerHighest: const Color(0xFFF0F3F8),
      outlineVariant: border,
      onSurface: ink,
      onSurfaceVariant: muted,
      onPrimary: Colors.white,
      error: danger,
      shadow: const Color(0xFF101828),
    );

    return typedBase.copyWith(
      colorScheme: scheme,
      scaffoldBackgroundColor: softSurface,
      dividerColor: border,
      textTheme: typedBase.textTheme.copyWith(
        headlineSmall: MiniAppTypography.h8.copyWith(color: ink),
        titleLarge: MiniAppTypography.title1.copyWith(color: ink),
        titleMedium: MiniAppTypography.subtitle2.copyWith(color: ink),
        bodyMedium: MiniAppTypography.body2.copyWith(color: ink),
        bodySmall: MiniAppTypography.caption1.copyWith(color: muted),
        labelLarge: MiniAppTypography.buttonMedium.copyWith(color: ink),
      ),
      snackBarTheme: typedBase.snackBarTheme.copyWith(
        behavior: SnackBarBehavior.floating,
        backgroundColor: ink,
        contentTextStyle: MiniAppTypography.body2.copyWith(color: Colors.white),
      ),
    );
  }

  /// Selects the pack-card gradient based on recommendation state.
  static Gradient packGradient(bool recommended) =>
      recommended ? coolGradient : primaryGradient;
}
