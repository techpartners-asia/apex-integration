import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../responsive/mini_app_responsive.dart';
import '../theme/mini_app_state_colors.dart';
import 'mini_app_adaptive_controls.dart';
import 'custom_text.dart';

class MiniAppPageHeader extends StatelessWidget {
  final String title;
  final String? subtitle;
  final VoidCallback? onBack;
  final Widget? trailing;

  const MiniAppPageHeader({
    super.key,
    required this.title,
    this.subtitle,
    this.onBack,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final responsive = context.responsive;
    final MaterialLocalizations materialLocalizations =
        MaterialLocalizations.of(context);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        if (onBack != null) ...<Widget>[
          MiniAppAdaptiveIconButton(
            onPressed: onBack,
            icon: Icons.arrow_back_ios_new_rounded,
            iosIcon: CupertinoIcons.back,
            size: responsive.component(AppComponentSize.controlMd),
            iconSize: responsive.icon(AppComponentSize.iconMd),
            backgroundColor: colorScheme.surfaceContainerHighest,
            foregroundColor: colorScheme.onSurface,
            tooltip: materialLocalizations.backButtonTooltip,
          ),
          SizedBox(width: responsive.spacing.inlineSpacing),
        ],
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              CustomText(
                title,
                variant: MiniAppTextVariant.title1,
                maxLines: responsive.isCompact ? 2 : 3,
                overflow: TextOverflow.ellipsis,
              ),
              if (subtitle != null && subtitle!.trim().isNotEmpty) ...<Widget>[
                SizedBox(height: responsive.spacing.inlineSpacing * 0.5),
                CustomText(
                  subtitle!,
                  variant: MiniAppTextVariant.body3,
                  color: MiniAppStateColors.mutedForeground,
                  maxLines: responsive.isCompact ? 2 : 3,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ],
          ),
        ),
        if (trailing != null) ...<Widget>[
          SizedBox(width: responsive.spacing.inlineSpacing),
          trailing!,
        ],
      ],
    );
  }
}
