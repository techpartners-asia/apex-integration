import 'package:flutter/material.dart';

/// Typography scale used by the mini app regardless of host app text theme.
final class MiniAppTypography {
  /// Bundled package font family.
  static const String fontFamily = 'Zona Pro';

  /// Package that owns the font assets.
  static const String package = 'apex_mini_app_sdk';

  /// Regular font weight.
  static const FontWeight regular = FontWeight.w400;

  /// Medium font weight.
  static const FontWeight medium = FontWeight.w500;

  /// Semi-bold font weight.
  static const FontWeight semiBold = FontWeight.w600;

  /// Bold font weight.
  static const FontWeight bold = FontWeight.w700;

  /// Extra-bold font weight.
  static const FontWeight extraBold = FontWeight.w800;

  /// Black/heaviest font weight.
  static const FontWeight black = FontWeight.w900;

  /// Default text color for standalone text styles.
  static const Color defaultTextColor = Colors.black;

  /// Largest display heading style.
  static const TextStyle h1 = TextStyle(
    fontFamily: fontFamily,
    package: package,
    fontSize: 72,
    // height: 85 / 72,
    fontWeight: black,
  );

  /// Alternate largest display heading style.
  static const TextStyle h2 = TextStyle(
    fontFamily: fontFamily,
    package: package,
    fontSize: 72,
    // height: 87 / 72,
    fontWeight: extraBold,
  );

  /// Large display heading style.
  static const TextStyle h3 = TextStyle(
    fontFamily: fontFamily,
    package: package,
    fontSize: 48,
    // height: 58 / 48,
    fontWeight: bold,
  );

  /// Medium display heading style.
  static const TextStyle h4 = TextStyle(
    fontFamily: fontFamily,
    package: package,
    fontSize: 40,
    // height: 58 / 40,
    fontWeight: bold,
  );

  /// Small display heading style.
  static const TextStyle h5 = TextStyle(
    fontFamily: fontFamily,
    package: package,
    fontSize: 32,
    // height: 48 / 32,
    fontWeight: semiBold,
  );

  /// Section heading style.
  static const TextStyle h6 = TextStyle(
    fontFamily: fontFamily,
    package: package,
    fontSize: 32,
    // height: 48 / 32,
    fontWeight: semiBold,
  );

  /// Dialog/page heading style.
  static const TextStyle h7 = TextStyle(
    fontFamily: fontFamily,
    package: package,
    fontSize: 24,
    // height: 36 / 24,
    fontWeight: semiBold,
  );

  /// Compact heading style.
  static const TextStyle h8 = TextStyle(
    fontFamily: fontFamily,
    package: package,
    fontSize: 20,
    // height: 30 / 20,
    fontWeight: semiBold,
  );

  /// Primary title style.
  static const TextStyle title1 = TextStyle(
    fontFamily: fontFamily,
    package: package,
    fontSize: 18,
    // height: 24 / 18,
    fontWeight: semiBold,
  );

  /// Alias for [title1].
  static const TextStyle title2 = title1;

  /// Alias for [title1].
  static const TextStyle title3 = title1;

  /// Alias for [title1].
  static const TextStyle subtitle1 = title1;

  /// Primary subtitle style.
  static const TextStyle subtitle2 = TextStyle(
    fontFamily: fontFamily,
    package: package,
    fontSize: 16,
    // height: 24 / 16,
    fontWeight: semiBold,
  );

  /// Compact subtitle style.
  static const TextStyle subtitle3 = TextStyle(
    fontFamily: fontFamily,
    package: package,
    fontSize: 14,
    // height: 22 / 14,
    fontWeight: semiBold,
  );

  /// Bold compact subtitle style.
  static const TextStyle subtitle4 = TextStyle(
    fontFamily: fontFamily,
    package: package,
    fontSize: 14,
    fontWeight: bold,
  );

  /// Large body text style.
  static const TextStyle body1 = TextStyle(
    fontFamily: fontFamily,
    package: package,
    fontSize: 18,
    // height: 24 / 18,
    fontWeight: medium,
  );

  /// Default body text style.
  static const TextStyle body2 = TextStyle(
    fontFamily: fontFamily,
    package: package,
    fontSize: 16,
    // height: 24 / 16,
    fontWeight: medium,
  );

  /// Compact body text style.
  static const TextStyle body3 = TextStyle(
    fontFamily: fontFamily,
    package: package,
    fontSize: 14,
    // height: 22 / 14,
    fontWeight: medium,
  );

  /// Primary caption style.
  static const TextStyle caption1 = TextStyle(
    fontFamily: fontFamily,
    package: package,
    fontSize: 12,
    // height: 20 / 12,
    fontWeight: medium,
  );

  /// Small caption style.
  static const TextStyle caption2 = TextStyle(
    fontFamily: fontFamily,
    package: package,
    fontSize: 10,
    // height: 20 / 10,
    fontWeight: medium,
  );

  /// Uppercase/eyebrow style.
  static const TextStyle overline1 = TextStyle(
    fontFamily: fontFamily,
    package: package,
    fontSize: 12,
    // height: 20 / 12,
    fontWeight: semiBold,
    letterSpacing: 1.2,
  );

  /// Bold uppercase/eyebrow style.
  static const TextStyle overline2 = TextStyle(
    fontFamily: fontFamily,
    package: package,
    fontSize: 12,
    // height: 20 / 12,
    fontWeight: bold,
    letterSpacing: 1.2,
  );

  /// Alias for bold overline text.
  static const TextStyle overlineSemiBold = overline2;

  /// Large button label style.
  static const TextStyle buttonLarge = TextStyle(
    fontFamily: fontFamily,
    package: package,
    fontSize: 16,
    // height: 26 / 16,
    fontWeight: bold,
  );

  /// Default button label style.
  static const TextStyle buttonMedium = TextStyle(
    fontFamily: fontFamily,
    package: package,
    fontSize: 14,
    // height: 24 / 14,
    fontWeight: bold,
  );

  /// Small button label style.
  static const TextStyle buttonSmall = TextStyle(
    fontFamily: fontFamily,
    package: package,
    fontSize: 13,
    // height: 22 / 13,
    fontWeight: bold,
  );

  /// Applies the mini-app typography scale to common Material theme slots.
  static ThemeData apply(ThemeData base) {
    final TextTheme textTheme = textThemeFor(base.textTheme);
    final TextTheme primaryTextTheme = textThemeFor(base.primaryTextTheme);
    const TextStyle buttonTextStyle = buttonMedium;
    const TextStyle dialogTitleTextStyle = h7;
    const TextStyle dialogBodyTextStyle = body3;
    const TextStyle listTileTitleTextStyle = subtitle2;
    const TextStyle listTileSubtitleTextStyle = body3;

    return base.copyWith(
      textTheme: textTheme,
      primaryTextTheme: primaryTextTheme,
      appBarTheme: base.appBarTheme.copyWith(
        titleTextStyle: h7,
        toolbarTextStyle: body3,
      ),
      chipTheme: base.chipTheme.copyWith(
        labelStyle: caption1,
        secondaryLabelStyle: caption1,
      ),
      tabBarTheme: base.tabBarTheme.copyWith(
        labelStyle: subtitle3,
        unselectedLabelStyle: body3,
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
        contentTextStyle: body3,
      ),
      dialogTheme: base.dialogTheme.copyWith(
        titleTextStyle: dialogTitleTextStyle,
        contentTextStyle: dialogBodyTextStyle,
      ),
      listTileTheme: base.listTileTheme.copyWith(
        titleTextStyle: listTileTitleTextStyle,
        subtitleTextStyle: listTileSubtitleTextStyle,
      ),
      popupMenuTheme: base.popupMenuTheme.copyWith(textStyle: body3),
      tooltipTheme: base.tooltipTheme.copyWith(textStyle: caption1),
      bottomNavigationBarTheme: base.bottomNavigationBarTheme.copyWith(
        selectedLabelStyle: caption1,
        unselectedLabelStyle: caption1,
      ),
      navigationBarTheme: base.navigationBarTheme.copyWith(
        labelTextStyle: WidgetStateProperty.resolveWith<TextStyle?>((
          Set<WidgetState> states,
        ) {
          return caption1;
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

  /// Creates a full text theme using the mini-app type scale.
  static TextTheme textThemeFor(TextTheme base) {
    return TextTheme(
      displayLarge: h1,
      displayMedium: h3,
      displaySmall: h4,
      headlineLarge: h5,
      headlineMedium: h7,
      headlineSmall: h8,
      titleLarge: title1,
      titleMedium: subtitle2,
      titleSmall: subtitle3,
      bodyLarge: body1,
      bodyMedium: body2,
      bodySmall: body3,
      labelLarge: buttonMedium,
      labelMedium: caption1,
      labelSmall: caption2,
    );
  }

  /// Applies the mini-app font family and a specific weight to [style].
  static TextStyle? withWeight(TextStyle? style, FontWeight weight) {
    return style?.copyWith(
      fontFamily: fontFamily,
      fontWeight: weight,
      package: package,
    );
  }

  /// Applies the mini-app font family to [style].
  static TextStyle? withFamily(TextStyle? style) {
    return style?.copyWith(fontFamily: fontFamily, package: package);
  }

  /// Returns a button style that uses [textStyle] for every widget state.
  static ButtonStyle withTextStyle(ButtonStyle? base, TextStyle? textStyle) {
    return (base ?? const ButtonStyle()).copyWith(
      textStyle: WidgetStatePropertyAll<TextStyle?>(textStyle),
    );
  }
}
