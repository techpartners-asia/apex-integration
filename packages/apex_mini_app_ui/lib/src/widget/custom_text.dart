import 'package:flutter/material.dart';

import '../theme/mini_app_typography.dart';
import '../theme/mini_app_typography_context.dart';

// display   →    displaySmall   →   36
// headline  →    headlineSmall  →   24
// title     →    titleMedium    →   16
// body      →    bodyMedium     →   14
// bodySmall →    bodySmall      →   12
// label     →    labelMedium    →   12
// caption   →    labelSmall     →   11
// button    →    labelLarge     →   14

enum MiniAppTextVariant {
  display,
  headline,
  titleSmall,
  title,
  titleLarge,
  body,
  bodySmall,
  label,
  caption,
  button,
  labelSmall,
}

class CustomText extends StatelessWidget {
  final String text;
  final MiniAppTextVariant variant;
  final Color? color;
  final FontWeight? fontWeight;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? overflow;
  final bool? softWrap;
  final TextDecoration? decoration;
  final double? height;
  final TextStyle? style;
  final String? semanticsLabel;

  const CustomText(
    this.text, {
    super.key,
    this.variant = MiniAppTextVariant.body,
    this.color,
    this.fontWeight,
    this.textAlign,
    this.maxLines = 10,
    this.overflow = TextOverflow.ellipsis,
    this.softWrap = false,
    this.decoration,
    this.height,
    this.style,
    this.semanticsLabel,
  });

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = context.textTheme;
    final TextStyle fallbackStyle = TextStyle(
      fontFamily: MiniAppTypography.fontFamily,
      package: MiniAppTypography.package,
      fontWeight: MiniAppTypography.regular,
    );

    final TextStyle baseStyle =
        _resolveBaseStyle(textTheme, variant) ?? fallbackStyle;
    final TextStyle effectiveStyle = baseStyle
        .merge(style)
        .copyWith(
          color: color,
          fontWeight: fontWeight,
          decoration: decoration,
          height: height,
        );

    return Text(
      text,
      semanticsLabel: semanticsLabel,
      style: effectiveStyle,
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
      softWrap: softWrap,
    );
  }

  TextStyle? _resolveBaseStyle(
    TextTheme textTheme,
    MiniAppTextVariant variant,
  ) {
    return switch (variant) {
      MiniAppTextVariant.display => textTheme.displaySmall, // 36
      MiniAppTextVariant.headline => textTheme.headlineSmall, // 20
      MiniAppTextVariant.titleSmall => textTheme.titleSmall, // 16
      MiniAppTextVariant.title => textTheme.titleMedium, // 18
      MiniAppTextVariant.titleLarge => textTheme.titleLarge, // 22
      MiniAppTextVariant.body => textTheme.bodyMedium, // 14
      MiniAppTextVariant.bodySmall => textTheme.bodySmall, // 12
      MiniAppTextVariant.label => textTheme.labelMedium, // 12
      MiniAppTextVariant.caption => textTheme.labelSmall, // 10
      MiniAppTextVariant.button => textTheme.titleSmall, // 16
      MiniAppTextVariant.labelSmall => textTheme.labelSmall, // 10
    };
  }
}
