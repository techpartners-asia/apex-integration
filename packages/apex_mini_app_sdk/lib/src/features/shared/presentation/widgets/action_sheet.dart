import 'package:flutter/material.dart';
import 'package:mini_app_sdk/mini_app_sdk.dart';
import 'package:mini_app_ui/mini_app_ui.dart';

class ActionSheet extends StatelessWidget {
  final String title;
  final Widget child;
  final TextStyle? titleStyle;
  final bool showDivider;
  final bool showHandle;
  final Widget? trailing;
  final Color backgroundColor;

  const ActionSheet({
    super.key,
    required this.title,
    required this.child,
    this.titleStyle,
    this.showDivider = false,
    this.showHandle = true,
    this.trailing,
    this.backgroundColor = MiniAppStateColors.bottomSheetBackground,
  });

  @override
  Widget build(BuildContext context) {
    final responsive = context.responsive;
    final mediaQuery = MediaQuery.of(context);
    final double bottomInset = mediaQuery.viewInsets.bottom;
    final double safeBottom = mediaQuery.padding.bottom;
    final bool hasKeyboard = bottomInset > 0;
    final double contentMaxHeight = mediaQuery.size.height * 0.8;
    final double bottomPad =
        (hasKeyboard ? bottomInset : safeBottom) +
        responsive.space(AppSpacing.lg);
    final Widget resolvedTrailing =
        trailing ??
        ActionButton(
          img: Img.close,
          onPressed: () => Navigator.of(context).maybePop(),
          foregroundColor: DesignTokens.muted,
        );

    return ConstrainedBox(
      constraints: BoxConstraints(
        maxHeight: contentMaxHeight + bottomInset,
      ),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeOutCubic,
        padding: EdgeInsets.fromLTRB(
          responsive.space(AppSpacing.lg),
          responsive.space(AppSpacing.md),
          responsive.space(AppSpacing.lg),
          bottomPad,
        ),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(responsive.radius(28)),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            if (showHandle) ...<Widget>[
              Container(
                width: responsive.dp(54),
                height: responsive.dp(4),
                decoration: BoxDecoration(
                  color: DesignTokens.border,
                  borderRadius: BorderRadius.circular(999),
                ),
              ),
              SizedBox(height: responsive.space(AppSpacing.md)),
            ],
            Row(
              children: <Widget>[
                SizedBox(width: responsive.dp(40)),
                Expanded(
                  child: CustomText(
                    title,
                    variant: MiniAppTextVariant.subtitle2,
                    textAlign: TextAlign.center,
                    style: titleStyle,
                  ),
                ),
                resolvedTrailing,
              ],
            ),
            if (showDivider) ...<Widget>[
              SizedBox(height: responsive.space(AppSpacing.md)),
              Divider(
                height: 1,
                thickness: 1,
                color: DesignTokens.border,
              ),
              SizedBox(height: responsive.space(AppSpacing.lg)),
            ] else
              SizedBox(height: responsive.space(AppSpacing.lg)),
            Flexible(
              fit: FlexFit.loose,
              child: child,
            ),
          ],
        ),
      ),
    );
  }
}
