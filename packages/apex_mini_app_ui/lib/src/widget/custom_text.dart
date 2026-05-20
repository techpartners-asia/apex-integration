import 'package:flutter/material.dart';

import '../theme/mini_app_typography.dart';

/// Named text styles from the mini-app typography scale.
enum MiniAppTextVariant {
  h1,
  h2,
  h3,
  h4,
  h5,
  h6,
  h7,
  h8,
  title1,
  title2,
  title3,
  subtitle1,
  subtitle2,
  subtitle3,
  subtitle4,
  body1,
  body2,
  body3,
  caption1,
  caption2,
  overline1,
  overline2,
  overlineSemiBold,
  buttonLarge,
  buttonMedium,
  buttonSmall,
}

/// Text wrapper that applies the mini-app typography scale consistently.
class CustomText extends StatelessWidget {
  /// Text content.
  final String text;

  /// Typography variant to use.
  final MiniAppTextVariant variant;

  /// Optional color override.
  final Color? color;

  /// Optional weight override.
  final FontWeight? fontWeight;

  /// Text alignment.
  final TextAlign? textAlign;

  /// Maximum line count.
  final int? maxLines;

  /// Overflow behavior.
  final TextOverflow? overflow;

  /// Whether text may wrap softly.
  final bool? softWrap;

  /// Optional text decoration.
  final TextDecoration? decoration;

  /// Optional line-height override.
  final double? height;

  /// Additional style merged on top of the resolved variant style.
  final TextStyle? style;

  /// Optional accessibility label.
  final String? semanticsLabel;

  /// Creates SDK typography text.
  const CustomText(
    this.text, {
    super.key,
    this.variant = MiniAppTextVariant.body3,
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
    final TextStyle fallbackStyle = TextStyle(
      fontFamily: MiniAppTypography.fontFamily,
      package: MiniAppTypography.package,
      fontWeight: MiniAppTypography.regular,
    );

    final TextStyle baseStyle = _resolveBaseStyle(variant) ?? fallbackStyle;
    final Color resolvedColor =
        color ??
        style?.color ??
        baseStyle.color ??
        MiniAppTypography.defaultTextColor;
    final TextStyle effectiveStyle = baseStyle
        .merge(style)
        .copyWith(
          color: resolvedColor,
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

  /// Maps a [MiniAppTextVariant] to its base text style.
  TextStyle? _resolveBaseStyle(MiniAppTextVariant variant) {
    return switch (variant) {
      MiniAppTextVariant.h1 => MiniAppTypography.h1,
      MiniAppTextVariant.h2 => MiniAppTypography.h2,
      MiniAppTextVariant.h3 => MiniAppTypography.h3,
      MiniAppTextVariant.h4 => MiniAppTypography.h4,
      MiniAppTextVariant.h5 => MiniAppTypography.h5,
      MiniAppTextVariant.h6 => MiniAppTypography.h6,
      MiniAppTextVariant.h7 => MiniAppTypography.h7,
      MiniAppTextVariant.h8 => MiniAppTypography.h8,
      MiniAppTextVariant.title1 => MiniAppTypography.title1,
      MiniAppTextVariant.title2 => MiniAppTypography.title2,
      MiniAppTextVariant.title3 => MiniAppTypography.title3,
      MiniAppTextVariant.subtitle1 => MiniAppTypography.subtitle1,
      MiniAppTextVariant.subtitle2 => MiniAppTypography.subtitle2,
      MiniAppTextVariant.subtitle3 => MiniAppTypography.subtitle3,
      MiniAppTextVariant.subtitle4 => MiniAppTypography.subtitle4,
      MiniAppTextVariant.body1 => MiniAppTypography.body1,
      MiniAppTextVariant.body2 => MiniAppTypography.body2,
      MiniAppTextVariant.body3 => MiniAppTypography.body3,
      MiniAppTextVariant.caption1 => MiniAppTypography.caption1,
      MiniAppTextVariant.caption2 => MiniAppTypography.caption2,
      MiniAppTextVariant.overline1 => MiniAppTypography.overline1,
      MiniAppTextVariant.overline2 => MiniAppTypography.overline2,
      MiniAppTextVariant.overlineSemiBold => MiniAppTypography.overlineSemiBold,
      MiniAppTextVariant.buttonLarge => MiniAppTypography.buttonLarge,
      MiniAppTextVariant.buttonMedium => MiniAppTypography.buttonMedium,
      MiniAppTextVariant.buttonSmall => MiniAppTypography.buttonSmall,
    };
  }
}
