import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../images/images.dart';
import 'package:mini_app_ui/mini_app_ui.dart';

import '../helpers/investx_design_tokens.dart';
import 'button.dart';
import 'custom_image.dart';

class InvestXAppBar extends StatelessWidget implements PreferredSizeWidget, ObstructingPreferredSizeWidget {
  final String? title;
  final Widget? trailing;
  final bool showBackButton;
  final bool showCloseButton;
  final bool showClearButton;
  final VoidCallback? onBack;
  final VoidCallback? onClose;
  final VoidCallback? onClear;
  final TextStyle? titleStyle;
  final bool centerTitle;
  final bool reserveLeadingSpace;
  final double? titleSpacing;
  final Color backgroundColor;
  final bool showBottomBorder;
  final Widget? tab;

  const InvestXAppBar({
    super.key,
    this.title,
    this.trailing,
    this.showBackButton = false,
    this.showCloseButton = true,
    this.showClearButton = false,
    this.onBack,
    this.onClose,
    this.onClear,
    this.titleStyle,
    this.centerTitle = true,
    this.reserveLeadingSpace = true,
    this.titleSpacing,
    this.backgroundColor = Colors.white,
    this.showBottomBorder = true,
    this.tab,
  });

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight + (tab != null ? kToolbarHeight : 1.0));

  @override
  bool shouldFullyObstruct(BuildContext context) => backgroundColor.a == 1;

  @override
  Widget build(BuildContext context) {
    final responsive = context.responsive;
    final ThemeData theme = Theme.of(context);
    final String? trimmedTitle = title?.trim();
    final bool hasTitle = trimmedTitle != null && trimmedTitle.isNotEmpty;
    final double actionButtonSize = responsive.component(
      AppComponentSize.controlMd,
    );
    final double actionSlotSpacing = responsive.space(AppSpacing.sm);
    final double actionSlotWidth = actionButtonSize + actionSlotSpacing;
    final bool showLeadingSlot = showBackButton || reserveLeadingSpace;

    return AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: backgroundColor,
      surfaceTintColor: backgroundColor,
      foregroundColor: InvestXDesignTokens.ink,
      scrolledUnderElevation: 0,
      elevation: 0,
      toolbarHeight: kToolbarHeight,
      systemOverlayStyle: SystemUiOverlayStyle.dark,
      centerTitle: centerTitle,
      titleSpacing: titleSpacing ?? (centerTitle ? responsive.space(AppSpacing.sm) : responsive.dp(20)),
      leadingWidth: showLeadingSlot ? actionSlotWidth + responsive.space(AppSpacing.md) : 0,
      leading: showLeadingSlot
          ? _InvestXAppBarActionSlot(
              leftPadding: responsive.space(AppSpacing.md),
              width: actionSlotWidth,
              child: showBackButton
                  ? InvestXActionButton(
                      onPressed: onBack ?? () => Navigator.maybePop(context),
                      icon: Icons.arrow_back_ios_new_rounded,
                      iosIcon: CupertinoIcons.back,
                      foregroundColor: InvestXDesignTokens.ink,
                    )
                  : const SizedBox.shrink(),
            )
          : null,
      title: hasTitle
          ? CustomText(
              trimmedTitle,
              variant: MiniAppTextVariant.label,
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style:
                  titleStyle ??
                  theme.textTheme.titleMedium?.copyWith(
                    color: InvestXDesignTokens.ink,
                    fontWeight: MiniAppTypography.semiBold,
                  ),
            )
          : CustomImage(path: Img.investX, height: responsive.dp(24)),
      actionsPadding: EdgeInsets.only(right: responsive.space(AppSpacing.md)),
      actions: <Widget>[
        if (trailing != null)
          _InvestXAppBarActionSlot(
            width: actionSlotWidth,
            child: Center(child: trailing),
          ),
        if (showClearButton)
          _InvestXAppBarActionSlot(
            width: actionSlotWidth,
            child: InvestXActionButton(
              onPressed: onClear,
              img: Img.close,
              foregroundColor: InvestXDesignTokens.muted,
            ),
          ),
        if (showCloseButton)
          _InvestXAppBarActionSlot(
            width: actionSlotWidth,
            child: InvestXActionButton(
              onPressed: onClose ?? () => Navigator.of(context).maybePop(),
              img: Img.close,
              foregroundColor: InvestXDesignTokens.muted,
            ),
          ),
      ],
      bottom: showBottomBorder
          ? PreferredSize(
              preferredSize: Size.fromHeight(
                tab != null ? kToolbarHeight : 1.0,
              ),
              child: Column(
                children: <Widget>[
                  const Divider(
                    height: 1,
                    thickness: 1,
                    color: InvestXDesignTokens.border,
                  ),
                  tab ?? const SizedBox.shrink(),
                ],
              ),
            )
          : null,
    );
  }
}

class _InvestXAppBarActionSlot extends StatelessWidget {
  final double width;
  final Widget child;
  final double leftPadding;

  const _InvestXAppBarActionSlot({
    required this.width,
    required this.child,
    this.leftPadding = 0,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: leftPadding),
      child: Center(child: child),
    );
  }
}
