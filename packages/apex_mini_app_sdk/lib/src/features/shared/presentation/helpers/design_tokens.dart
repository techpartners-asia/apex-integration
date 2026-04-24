import 'package:mini_app_ui/mini_app_ui.dart';
import 'package:flutter/material.dart';

final class DesignTokens {
  static const Color rose = Color(0xFFE94C86);
  static const Color deepPink = Color(0xFFDD4F80);
  static const Color softPeach = Color(0xFFFB9D6C);
  static const Color coral = Color(0xFFFFA06C);
  static const Color teal = Color(0xFF1AA6A4);
  static const Color primaryTeal = Color(0xFF009685);
  static const Color darkTeal = Color(0xFF00727C);
  static const Color ink = Color(0xFF252C39);
  static const Color muted = Color(0xFF717887);
  static const Color border = Color(0xFFE8EBF2);
  static const Color softSurface = Color(0xFFF6F7FB);
  static const Color sheetBackground = Color(0xFFF7F8FC);
  static const Color softAccent = Color(0xFFFDF1D9);
  static const Color softAccentBorder = Color(0xFFF3D28C);
  static const Color success = Color(0xFF24C15F);
  static const Color successStrong = Color(0xFF22C55E);
  static const Color danger = Color(0xFFE55B63);
  static const Color neutralChip = Color(0xFFEEF1F7);
  static const Color selectionBlue = Color(0xFF386BFF);
  static const Color selectionBlueBorder = Color(0xFFE6EAF2);
  static const Color selectionBlueMuted = Color(0xFFC5CBD8);
  static const Color roseTint = Color(0xFFFFC5DA);
  static const Color roseGlow = Color(0x2EE94C86);
  static const Color agreementUnchecked = Color(0xFFD6D9E0);
  static const Color white = Colors.white;

  static const Gradient primaryGradient = LinearGradient(
    colors: <Color>[rose, coral],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );

  static const Gradient coolGradient = LinearGradient(
    colors: <Color>[rose, teal],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const Gradient disabledGradient = LinearGradient(
    colors: <Color>[Color(0xFFE1E5EC), Color(0xFFD6DAE3)],
  );

  static const List<BoxShadow> cardShadow = <BoxShadow>[
    BoxShadow(color: Color(0x140F172A), blurRadius: 24, offset: Offset(0, 12)),
  ];

  static const List<BoxShadow> buttonShadow = <BoxShadow>[
    BoxShadow(color: Color(0x33E94C86), blurRadius: 18, offset: Offset(0, 8)),
  ];

  static const BorderRadius cardRadius = BorderRadius.all(Radius.circular(20));
  static const BorderRadius pillRadius = BorderRadius.all(Radius.circular(999));

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
        headlineSmall: typedBase.textTheme.headlineSmall?.copyWith(
          color: ink,
          fontWeight: MiniAppTypography.bold,
          letterSpacing: 0.4,
        ),
        titleLarge: typedBase.textTheme.titleLarge?.copyWith(
          color: ink,
          fontWeight: MiniAppTypography.bold,
        ),
        titleMedium: typedBase.textTheme.titleMedium?.copyWith(
          color: ink,
          fontWeight: MiniAppTypography.semiBold,
        ),
        bodyMedium: typedBase.textTheme.bodyMedium?.copyWith(
          color: ink,
          height: 1.5,
        ),
        bodySmall: typedBase.textTheme.bodySmall?.copyWith(
          color: muted,
          height: 1.45,
        ),
        labelLarge: typedBase.textTheme.labelLarge?.copyWith(
          color: ink,
          fontWeight: MiniAppTypography.semiBold,
        ),
      ),
      snackBarTheme: typedBase.snackBarTheme.copyWith(
        behavior: SnackBarBehavior.floating,
        backgroundColor: ink,
        contentTextStyle: typedBase.textTheme.bodyMedium?.copyWith(
          color: Colors.white,
        ),
      ),
    );
  }

  static Gradient packGradient(bool recommended) =>
      recommended ? coolGradient : primaryGradient;
}
