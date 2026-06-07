import 'package:flutter/material.dart';
import 'package:apex_mini_app_sdk/apex_mini_app_sdk.dart';

/// Small icon/bullet plus text row for feature and instruction lists.
class FeatureBullet extends StatelessWidget {
  /// Bullet text.
  final String label;

  /// Icon used as the bullet marker.
  final IconData icon;

  /// Typography variant for the label.
  final MiniAppTextVariant textVariant;

  /// Optional font weight override for the label.
  final FontWeight? fontWeight;

  /// Creates a feature bullet row.
  const FeatureBullet({
    super.key,
    required this.label,
    this.icon = Icons.circle,
    this.textVariant = MiniAppTextVariant.body2,
    this.fontWeight,
  });

  @override
  Widget build(BuildContext context) {
    final responsive = context.responsive;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(
            top: responsive.spacing.inlineSpacing * 0.45,
          ),
          child: Icon(
            icon,
            size: icon == Icons.circle ? 6 : 16,
            color: DesignTokens.ink,
          ),
        ),
        SizedBox(width: responsive.spacing.inlineSpacing * 0.75),
        Expanded(
          child: CustomText(
            label,
            variant: textVariant,
            fontWeight: fontWeight,
            color: DesignTokens.ink,
          ),
        ),
      ],
    );
  }
}
