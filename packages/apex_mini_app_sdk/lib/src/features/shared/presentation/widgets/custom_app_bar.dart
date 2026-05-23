import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:apex_mini_app_sdk/apex_mini_app_sdk.dart';

/// Standard Apex mini-app app bar with safe close/back behavior.
class CustomAppBar extends StatelessWidget implements PreferredSizeWidget, ObstructingPreferredSizeWidget {
  /// Optional title. When omitted, InvestX logo is shown.
  final String? title;

  /// Optional trailing widget before clear/close actions.
  final Widget? trailing;

  /// Whether to show a back button.
  final bool showBackButton;

  /// Whether to show the close button.
  final bool showCloseButton;

  /// Whether to show the clear button.
  final bool showClearButton;

  /// Back action override.
  final VoidCallback? onBack;

  /// Dismiss action override.
  final VoidCallback? onDismiss;

  /// Clear action.
  final VoidCallback? onClear;

  /// Title text style override.
  final TextStyle? titleStyle;

  /// Whether title/logo should be centered.
  final bool centerTitle;

  /// Whether to reserve leading space when no back button is shown.
  final bool reserveLeadingSpace;

  /// Optional title spacing override.
  final double? titleSpacing;

  /// App bar background.
  final Color backgroundColor;

  /// Whether to draw the bottom divider.
  final bool showBottomBorder;

  /// Optional bottom tab content.
  final Widget? tab;

  /// Creates the standard Apex mini-app app bar.
  const CustomAppBar({
    super.key,
    this.title,
    this.trailing,
    this.showBackButton = false,
    this.showCloseButton = true,
    this.showClearButton = false,
    this.onBack,
    this.onDismiss,
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
      titleSpacing: titleSpacing ?? (centerTitle ? responsive.space(AppSpacing.sm) : responsive.dp(20)),
      leadingWidth: showLeadingSlot ? actionSlotWidth + responsive.space(AppSpacing.md) : 0,
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
              onPressed: onDismiss ?? () => unawaited(Navigator.maybePop(context)),
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

/// Fixed-width leading/trailing slot used to keep app-bar title alignment.
class _CustomAppBarActionSlot extends StatelessWidget {
  /// Reserved slot width.
  final double width;

  /// Action child to center inside the slot.
  final Widget child;

  /// Optional left padding for visual spacing.
  final double leftPadding;

  /// Creates an app-bar action slot.
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
