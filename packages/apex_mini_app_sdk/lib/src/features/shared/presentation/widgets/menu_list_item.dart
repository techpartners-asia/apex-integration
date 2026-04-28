import 'package:flutter/material.dart';
import 'package:mini_app_ui/mini_app_ui.dart';
import 'package:mini_app_sdk/mini_app_sdk.dart';

class MenuListItem extends StatelessWidget {
  final String title;
  final String? subtitle;
  final Widget? leading;
  final Widget? trailing;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry? padding;

  const MenuListItem({
    super.key,
    required this.title,
    this.subtitle,
    this.leading,
    this.trailing,
    this.onTap,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    final responsive = context.responsive;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(responsive.radius(16)),
        child: Ink(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(responsive.radius(16)),
            border: Border.all(color: DesignTokens.border),
          ),
          child: Padding(
            padding:
                padding ??
                responsive.insetsSymmetric(horizontal: 14, vertical: 12),
            child: Row(
              children: <Widget>[
                if (leading != null) ...<Widget>[
                  leading!,
                  SizedBox(width: responsive.dp(10)),
                ],
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      CustomText(
                        title,
                        variant: MiniAppTextVariant.subtitle3,
                      ),
                      if (subtitle != null &&
                          subtitle!.trim().isNotEmpty) ...<Widget>[
                        SizedBox(height: responsive.spacingXxs),
                        CustomText(
                          subtitle!,
                          variant: MiniAppTextVariant.caption1,
                          color: DesignTokens.muted,
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
            ),
          ),
        ),
      ),
    );
  }
}
