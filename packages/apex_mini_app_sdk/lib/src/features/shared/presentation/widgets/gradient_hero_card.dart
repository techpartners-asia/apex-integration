import 'package:flutter/material.dart';
import 'package:mini_app_ui/mini_app_ui.dart';
import 'package:mini_app_sdk/mini_app_sdk.dart';

class GradientHeroCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final Widget? body;
  final Gradient? gradient;

  const GradientHeroCard({
    super.key,
    required this.title,
    required this.subtitle,
    this.body,
    this.gradient,
  });

  @override
  Widget build(BuildContext context) {
    final responsive = context.responsive;
    final Gradient resolvedGradient =
        gradient ?? DesignTokens.primaryGradient;

    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: resolvedGradient,
        borderRadius: DesignTokens.cardRadius,
        boxShadow: DesignTokens.cardShadow,
      ),
      child: Stack(
        children: <Widget>[
          Positioned(
            top: responsive.dp(40),
            right: responsive.dp(24),
            child: Container(
              width: responsive.dp(136),
              height: responsive.dp(136),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.10),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Positioned(
            bottom: responsive.dp(56),
            left: responsive.dp(12),
            child: Container(
              width: responsive.dp(124),
              height: responsive.dp(124),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.08),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(responsive.spacing.financialCardSpacing),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: Colors.white,
                    fontWeight: MiniAppTypography.bold,
                  ),
                ),
                SizedBox(height: responsive.spacing.inlineSpacing * 0.5),
                Text(
                  subtitle,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.white.withValues(alpha: 0.82),
                  ),
                ),
                if (body != null) ...<Widget>[
                  SizedBox(height: responsive.spacing.cardGap),
                  body!,
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
