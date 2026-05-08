import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mini_app_ui/mini_app_ui.dart';
import 'package:mini_app_sdk/mini_app_sdk.dart';

class CustomAppBar extends StatelessWidget
    implements PreferredSizeWidget, ObstructingPreferredSizeWidget {
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

  const CustomAppBar({
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
  Size get preferredSize {
    final double bottomHeight = tab != null
        ? kToolbarHeight
        : showBottomBorder
        ? 1.0
        : 0.0;

    return Size.fromHeight(kToolbarHeight + bottomHeight);
  }

  @override
  bool shouldFullyObstruct(BuildContext context) => backgroundColor.a == 1;

  @override
  Widget build(BuildContext context) {
    final responsive = context.responsive;
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
      foregroundColor: DesignTokens.ink,
      scrolledUnderElevation: 0,
      elevation: 0,
      toolbarHeight: kToolbarHeight,
      systemOverlayStyle: SystemUiOverlayStyle.dark,
      centerTitle: centerTitle,
      titleSpacing:
          titleSpacing ??
          (centerTitle ? responsive.space(AppSpacing.sm) : responsive.dp(20)),
      leadingWidth: showLeadingSlot
          ? actionSlotWidth + responsive.space(AppSpacing.md)
          : 0,
      leading: showLeadingSlot
          ? _CustomAppBarActionSlot(
              leftPadding: responsive.space(AppSpacing.md),
              width: actionSlotWidth,
              child: showBackButton
                  ? ActionButton(
                      onPressed: onBack ?? () => Navigator.maybePop(context),
                      icon: Icons.arrow_back_ios_new_rounded,
                      iosIcon: CupertinoIcons.back,
                      foregroundColor: DesignTokens.ink,
                    )
                  : const SizedBox.shrink(),
            )
          : null,
      title: hasTitle
          ? CustomText(
              trimmedTitle,
              variant: MiniAppTextVariant.caption1,
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style:
                  titleStyle ??
                  MiniAppTypography.subtitle2.copyWith(
                    color: DesignTokens.ink,
                  ),
            )
          : CustomImage(path: Img.investX, height: responsive.dp(24)),
      actionsPadding: EdgeInsets.only(right: responsive.space(AppSpacing.md)),
      actions: <Widget>[
        if (trailing != null)
          _CustomAppBarActionSlot(
            width: actionSlotWidth,
            child: Center(child: trailing),
          ),
        if (showClearButton)
          _CustomAppBarActionSlot(
            width: actionSlotWidth,
            child: ActionButton(
              onPressed: onClear,
              img: Img.close,
              foregroundColor: DesignTokens.muted,
            ),
          ),
        if (showCloseButton)
          _CustomAppBarActionSlot(
            width: actionSlotWidth,
            child: ActionButton(
              onPressed: onClose ?? () => Navigator.of(context).maybePop(),
              img: Img.close,
              foregroundColor: DesignTokens.muted,
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
                    color: DesignTokens.border,
                  ),
                  tab ?? const SizedBox.shrink(),
                ],
              ),
            )
          : null,
    );
  }
}

class _CustomAppBarActionSlot extends StatelessWidget {
  final double width;
  final Widget child;
  final double leftPadding;

  const _CustomAppBarActionSlot({
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
