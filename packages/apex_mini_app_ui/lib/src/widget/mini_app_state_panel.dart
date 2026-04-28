import 'package:flutter/material.dart';

import '../responsive/mini_app_responsive.dart';
import '../theme/mini_app_state_colors.dart';
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
            variant: MiniAppTextVariant.subtitle2,
            textAlign: TextAlign.center,
          ),
          SizedBox(height: responsive.spacing.inlineSpacing * 0.5),
          CustomText(
            message,
            variant: MiniAppTextVariant.body3,
            color: MiniAppStateColors.mutedForeground,
            textAlign: TextAlign.center,
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
