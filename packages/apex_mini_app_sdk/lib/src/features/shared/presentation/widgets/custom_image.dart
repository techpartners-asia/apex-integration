import 'package:flutter/material.dart';
import 'package:apex_mini_app_sdk/apex_mini_app_sdk.dart';

final String packageName = 'apex_mini_app_sdk';

class CustomImage extends StatelessWidget {
  final String path;
  final double? width;
  final double? height;
  final BoxFit? fit;
  final ImageErrorWidgetBuilder? errorBuilder;
  final Color? color;

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
