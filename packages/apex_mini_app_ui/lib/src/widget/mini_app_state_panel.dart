import 'package:flutter/material.dart';

import '../responsive/mini_app_responsive.dart';
import '../theme/mini_app_state_colors.dart';
import '../theme/mini_app_typography.dart';
import 'custom_text.dart';
import 'mini_app_surface_card.dart';

class MiniAppStatePanel extends StatelessWidget {
  final String title;
  final String message;
  final Widget leading;
  final Widget? action;
  final Color surfaceColor;
  final Color borderColor;

  const MiniAppStatePanel({
    super.key,
    required this.title,
    required this.message,
    required this.leading,
    this.action,
    this.surfaceColor = Colors.white,
    this.borderColor = MiniAppStateColors.neutralBorder,
  });

  @override
  Widget build(BuildContext context) {
    final responsive = context.responsive;
    final TextTheme textTheme = Theme.of(context).textTheme;

    return MiniAppSurfaceCard(
      backgroundColor: surfaceColor,
      borderColor: borderColor,
      borderRadius: responsive.spacing.radiusLarge,
      padding: EdgeInsets.all(responsive.spacing.modalPadding),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          leading,
          SizedBox(height: responsive.spacing.inlineSpacing),
          CustomText(
            title,
            variant: MiniAppTextVariant.title,
            textAlign: TextAlign.center,
            style: textTheme.titleMedium?.copyWith(
              fontWeight: MiniAppTypography.bold,
            ),
          ),
          SizedBox(height: responsive.spacing.inlineSpacing * 0.5),
          CustomText(
            message,
            variant: MiniAppTextVariant.body,
            textAlign: TextAlign.center,
            style: textTheme.bodyMedium?.copyWith(
              color: MiniAppStateColors.mutedForeground,
            ),
          ),
          if (action != null) ...<Widget>[
            SizedBox(height: responsive.spacing.sectionSpacing),
            action!,
          ],
        ],
      ),
    );
  }
}
