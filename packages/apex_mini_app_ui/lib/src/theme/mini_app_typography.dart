import 'package:flutter/material.dart';

final class MiniAppTypography {
  static const String fontFamily = 'Zona Pro';
  static const String package = 'mini_app_ui';
  static const FontWeight regular = FontWeight.w400;
  static const FontWeight semiBold = FontWeight.w600;
  static const FontWeight bold = FontWeight.w700;

  static ThemeData apply(ThemeData base) {
    final TextTheme textTheme = textThemeFor(base.textTheme);
    final TextTheme primaryTextTheme = textThemeFor(base.primaryTextTheme);
    final TextStyle? buttonTextStyle = withWeight(
      textTheme.labelLarge,
      semiBold,
    );
    final TextStyle? dialogTitleTextStyle = withWeight(
      textTheme.titleLarge,
      bold,
    );
    final TextStyle? dialogBodyTextStyle = withWeight(
      textTheme.bodyMedium,
      regular,
    );
    final TextStyle? listTileTitleTextStyle = withWeight(
      textTheme.bodyLarge,
      semiBold,
    );
    final TextStyle? listTileSubtitleTextStyle = withWeight(
      textTheme.bodyMedium,
      regular,
    );

    return base.copyWith(
      textTheme: textTheme,
      primaryTextTheme: primaryTextTheme,
      appBarTheme: base.appBarTheme.copyWith(
        titleTextStyle: withWeight(textTheme.titleLarge, bold),
        toolbarTextStyle: withWeight(textTheme.bodyMedium, regular),
      ),
      chipTheme: base.chipTheme.copyWith(
        labelStyle: withWeight(textTheme.labelMedium, semiBold),
        secondaryLabelStyle: withWeight(textTheme.labelMedium, semiBold),
      ),
      tabBarTheme: base.tabBarTheme.copyWith(
        labelStyle: withWeight(textTheme.titleSmall, semiBold),
        unselectedLabelStyle: withWeight(textTheme.titleSmall, regular),
      ),
      textButtonTheme: TextButtonThemeData(
        style: withTextStyle(base.textButtonTheme.style, buttonTextStyle),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: withTextStyle(base.filledButtonTheme.style, buttonTextStyle),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: withTextStyle(base.outlinedButtonTheme.style, buttonTextStyle),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: withTextStyle(base.elevatedButtonTheme.style, buttonTextStyle),
      ),
      snackBarTheme: base.snackBarTheme.copyWith(
        contentTextStyle: withWeight(textTheme.bodyMedium, regular),
      ),
      dialogTheme: base.dialogTheme.copyWith(
        titleTextStyle: dialogTitleTextStyle,
        contentTextStyle: dialogBodyTextStyle,
      ),
      listTileTheme: base.listTileTheme.copyWith(
        titleTextStyle: listTileTitleTextStyle,
        subtitleTextStyle: listTileSubtitleTextStyle,
      ),
      popupMenuTheme: base.popupMenuTheme.copyWith(
        textStyle: withWeight(textTheme.bodyMedium, regular),
      ),
      tooltipTheme: base.tooltipTheme.copyWith(
        textStyle: withWeight(textTheme.bodySmall, regular),
      ),
      bottomNavigationBarTheme: base.bottomNavigationBarTheme.copyWith(
        selectedLabelStyle: withWeight(textTheme.labelMedium, semiBold),
        unselectedLabelStyle: withWeight(textTheme.labelMedium, regular),
      ),
      navigationBarTheme: base.navigationBarTheme.copyWith(
        labelTextStyle: WidgetStateProperty.resolveWith<TextStyle?>((
          Set<WidgetState> states,
        ) {
          final FontWeight weight = states.contains(WidgetState.selected) ? semiBold : regular;
          return withWeight(textTheme.labelMedium, weight);
        }),
      ),
    );
  }

  // display   →    displaySmall   →   36
  // headline  →    headlineSmall  →   24
  // title     →    titleMedium    →   16
  // body      →    bodyMedium     →   14
  // bodySmall →    bodySmall      →   12
  // label     →    labelMedium    →   12
  // caption   →    labelSmall     →   11f
  // button    →    labelLarge     →   14

  // static TextTheme textThemeFor(TextTheme base) {
  //   return TextTheme(
  //     displayLarge: withWeight(base.displayLarge, bold),
  //     displayMedium: withWeight(base.displayMedium, bold),
  //     displaySmall: withWeight(base.displaySmall, bold),
  //     headlineLarge: withWeight(base.headlineLarge, bold),
  //     headlineMedium: withWeight(base.headlineMedium, bold),
  //     headlineSmall: withWeight(base.headlineSmall, bold),
  //     titleLarge: withWeight(base.titleLarge, bold),
  //     titleMedium: withWeight(base.titleMedium, semiBold),
  //     titleSmall: withWeight(base.titleSmall, semiBold),
  //     bodyLarge: withWeight(base.bodyLarge, regular),
  //     bodyMedium: withWeight(base.bodyMedium, regular),
  //     bodySmall: withWeight(base.bodySmall, regular),
  //     labelLarge: withWeight(base.labelLarge, semiBold),
  //     labelMedium: withWeight(base.labelMedium, semiBold),
  //     labelSmall: withWeight(base.labelSmall, regular),
  //   );
  // }

  static TextTheme textThemeFor(TextTheme base) {
    return TextTheme(
      displayLarge: withWeight(base.displayLarge, bold)?.copyWith(fontSize: 48),
      displayMedium: withWeight(base.displayMedium, bold)?.copyWith(fontSize: 40),
      displaySmall: withWeight(base.displaySmall, bold)?.copyWith(fontSize: 36),

      headlineLarge: withWeight(base.headlineLarge, bold)?.copyWith(fontSize: 32),
      headlineMedium: withWeight(base.headlineMedium, bold)?.copyWith(fontSize: 28),
      headlineSmall: withWeight(base.headlineSmall, bold)?.copyWith(fontSize: 20),

      titleLarge: withWeight(base.titleLarge, bold)?.copyWith(fontSize: 22),
      titleMedium: withWeight(base.titleMedium, semiBold)?.copyWith(fontSize: 18),
      titleSmall: withWeight(base.titleSmall, semiBold)?.copyWith(fontSize: 16),

      bodyLarge: withWeight(base.bodyLarge, regular)?.copyWith(fontSize: 16),
      bodyMedium: withWeight(base.bodyMedium, regular)?.copyWith(fontSize: 14),
      bodySmall: withWeight(base.bodySmall, regular)?.copyWith(fontSize: 12),

      labelLarge: withWeight(base.labelLarge, semiBold)?.copyWith(fontSize: 14),
      labelMedium: withWeight(base.labelMedium, semiBold)?.copyWith(fontSize: 12),
      labelSmall: withWeight(base.labelSmall, regular)?.copyWith(fontSize: 10),
    );
  }

  static TextStyle? withWeight(TextStyle? style, FontWeight weight) {
    return style?.copyWith(
      fontFamily: fontFamily,
      fontWeight: weight,
      package: package,
    );
  }

  static TextStyle? withFamily(TextStyle? style) {
    return style?.copyWith(fontFamily: fontFamily, package: package);
  }

  static ButtonStyle withTextStyle(ButtonStyle? base, TextStyle? textStyle) {
    return (base ?? const ButtonStyle()).copyWith(
      textStyle: WidgetStatePropertyAll<TextStyle?>(textStyle),
    );
  }
}
