import 'package:flutter/material.dart';
import 'package:apex_mini_app_sdk/apex_mini_app_sdk.dart';

/// Reusable tappable menu/list row with optional leading and trailing widgets.
class MenuListItem extends StatelessWidget {
  /// Main row title.
  final String title;

  /// Optional subtitle shown below [title].
  final String? subtitle;

  /// Optional leading widget.
  final Widget? leading;

  /// Optional trailing widget.
  final Widget? trailing;

  /// Optional tap handler.
  final VoidCallback? onTap;

  /// Optional row padding override.
  final EdgeInsetsGeometry? padding;

  /// Creates a tappable menu/list row.
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
