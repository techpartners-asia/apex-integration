import 'package:flutter/material.dart';
import 'package:apex_mini_app_sdk/apex_mini_app_sdk.dart';

/// Package name used for SDK asset lookup.
final String packageName = 'apex_mini_app_sdk';

/// SDK asset image wrapper with responsive width/height scaling.
class CustomImage extends StatelessWidget {
  /// Asset path.
  final String path;

  /// Optional width before responsive scaling.
  final double? width;

  /// Optional height before responsive scaling.
  final double? height;

  /// Image fit.
  final BoxFit? fit;

  /// Error builder.
  final ImageErrorWidgetBuilder? errorBuilder;

  /// Optional image color filter.
  final Color? color;

  /// Creates a responsive SDK asset image.
  const CustomImage({
    super.key,
    required this.path,
    this.width,
    this.height,
    this.fit,
    this.errorBuilder,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final responsive = context.responsive;

    return Image.asset(
      path,
      package: packageName,
      width: width != null ? responsive.dp(width!) : null,
      height: responsive.dp(height ?? 120),
      fit: fit,
      errorBuilder: errorBuilder,
      color: color,
    );
  }
}
