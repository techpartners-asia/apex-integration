import 'package:flutter/material.dart';
import 'package:mini_app_ui/mini_app_ui.dart';
import 'package:mini_app_sdk/mini_app_sdk.dart';

class FeatureBullet extends StatelessWidget {
  final String label;
  final IconData icon;

  const FeatureBullet({
    super.key,
    required this.label,
    this.icon = Icons.circle,
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
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: DesignTokens.ink),
          ),
        ),
      ],
    );
  }
}
