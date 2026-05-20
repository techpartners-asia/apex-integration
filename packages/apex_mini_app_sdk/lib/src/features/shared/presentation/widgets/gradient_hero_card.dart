import 'package:flutter/material.dart';
import 'package:apex_mini_app_sdk/apex_mini_app_sdk.dart';

/// Gradient hero card for high-emphasis feature summaries.
class GradientHeroCard extends StatelessWidget {
  /// Hero title.
  final String title;

  /// Supporting subtitle.
  final String subtitle;

  /// Optional content shown below the subtitle.
  final Widget? body;

  /// Optional gradient override; defaults to the primary app gradient.
  final Gradient? gradient;

  /// Creates a gradient hero card.
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
    final Gradient resolvedGradient = gradient ?? DesignTokens.primaryGradient;

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
                CustomText(
                  title,
                  variant: MiniAppTextVariant.title1,
                  color: Colors.white,
                ),
                SizedBox(height: responsive.spacing.inlineSpacing * 0.5),
                CustomText(
                  subtitle,
                  variant: MiniAppTextVariant.body3,
                  color: Colors.white.withValues(alpha: 0.82),
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
