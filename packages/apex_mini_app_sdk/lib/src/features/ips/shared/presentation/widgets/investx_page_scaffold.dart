export 'investx_app_bar.dart';

import 'package:adaptive_platform_ui/adaptive_platform_ui.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mini_app_ui/mini_app_ui.dart';

import '../helpers/investx_design_tokens.dart';
import 'bottom_navbar.dart';
import 'investx_app_bar.dart';
import 'investx_page_scaffold_body.dart';

class InvestXPageScaffold extends StatelessWidget {
  final String title;
  final PreferredSizeWidget? appBar;
  final bool hasAppBar;
  final Widget? body;
  final Widget? bottomNavigationBar;
  final AdaptiveBottomNavigationBar? adaptiveBottomNavigationBar;
  final InvestXBottomNavigationConfig? investXBottomNavigation;
  final bool adaptiveUseNativeToolbar;
  final String? subtitle;
  final Widget? trailing;
  final String? appBarTitle;
  final TextStyle? appBarTitleStyle;
  final bool appBarCenterTitle;
  final bool appBarReserveLeadingSpace;
  final double? appBarTitleSpacing;
  final List<Widget> actions;
  final List<Widget> children;
  final bool? showBackButton;
  final bool showCloseButton;
  final bool showClearButton;
  final Color backgroundColor;
  final Color appBarBackgroundColor;
  final bool appBarShowBottomBorder;
  final VoidCallback? onBack;
  final VoidCallback? onClose;
  final VoidCallback? onClear;
  final bool hasSafeArea;
  final Widget? floatingActionButton;
  final Future<void> Function()? onRefresh;

  const InvestXPageScaffold({
    super.key,
    this.title = '',
    this.appBar,
    this.hasAppBar = true,
    this.body,
    this.bottomNavigationBar,
    this.adaptiveBottomNavigationBar,
    this.investXBottomNavigation,
    this.adaptiveUseNativeToolbar = true,
    this.subtitle,
    this.trailing,
    this.appBarTitle,
    this.appBarTitleStyle,
    this.appBarCenterTitle = true,
    this.appBarReserveLeadingSpace = true,
    this.appBarTitleSpacing,
    this.actions = const <Widget>[],
    this.children = const <Widget>[],
    this.showBackButton,
    this.showCloseButton = true,
    this.showClearButton = false,
    this.backgroundColor = InvestXDesignTokens.softSurface,
    this.appBarBackgroundColor = InvestXDesignTokens.softSurface,
    this.appBarShowBottomBorder = false,
    this.onBack,
    this.onClose,
    this.onClear,
    this.hasSafeArea = true,
    this.floatingActionButton,
    this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: InvestXDesignTokens.theme(Theme.of(context)),
      child: Builder(
        builder: (BuildContext context) {
          final responsive = context.responsive;
          final double bottomInset = responsive.safeBottom;
          final NavigatorState navigator = Navigator.of(context);
          final bool effectiveShowBackButton =
              showBackButton ?? navigator.canPop();
          final EdgeInsets bodyPadding = EdgeInsets.fromLTRB(
            responsive.spacing.financialCardSpacing,
            0,
            responsive.spacing.financialCardSpacing,
            hasSafeArea ? responsive.spacing.sectionSpacing + bottomInset : 0,
          );
          final PreferredSizeWidget? effectiveAppBar = hasAppBar
              ? appBar ??
                    InvestXAppBar(
                      title: appBarTitle,
                      trailing: trailing,
                      showBackButton: effectiveShowBackButton,
                      showCloseButton: showCloseButton,
                      showClearButton: showClearButton,
                      titleStyle: appBarTitleStyle,
                      centerTitle: appBarCenterTitle,
                      reserveLeadingSpace: appBarReserveLeadingSpace,
                      titleSpacing: appBarTitleSpacing,
                      backgroundColor: appBarBackgroundColor,
                      showBottomBorder: appBarShowBottomBorder,
                      onBack: onBack,
                      onClose: onClose,
                      onClear: onClear,
                    )
              : null;
          final Widget effectiveBody =
              body ??
              InvestXPageScaffoldBody(
                title: title,
                subtitle: subtitle,
                actions: actions,
                bodyPadding: bodyPadding,
                onRefresh: onRefresh,
                refreshIndicatorColor: InvestXDesignTokens.rose,
                children: children,
              );
          final AdaptiveBottomNavigationBar?
          resolvedAdaptiveBottomNavigationBar = adaptiveBottomNavigationBar;
          final Widget? resolvedBottomNavigationBar =
              investXBottomNavigation != null
              ? InvestXNavbar(
                  selectedIndex: investXBottomNavigation!.selectedIndex,
                  onSelected: investXBottomNavigation!.onSelected,
                  onActionPressed: investXBottomNavigation!.onActionPressed,
                  isActionEnabled: investXBottomNavigation!.isActionEnabled,
                )
              : bottomNavigationBar;
          final bool hasAdaptiveShell =
              resolvedAdaptiveBottomNavigationBar != null ||
              investXBottomNavigation != null;
          final bool hasAdaptiveBottomBarOverlay =
              resolvedBottomNavigationBar != null;
          final bool resolvedAdaptiveUseNativeToolbar =
              adaptiveUseNativeToolbar && effectiveAppBar == null;

          if (hasAdaptiveShell) {
            final Widget adaptiveBody = hasAdaptiveBottomBarOverlay
                ? Padding(
                    padding: EdgeInsets.only(
                      bottom: responsive.dp(96) + bottomInset,
                    ),
                    child: effectiveBody,
                  )
                : effectiveBody;

            return AdaptiveScaffold(
              appBar: effectiveAppBar == null
                  ? null
                  : AdaptiveAppBar(
                      useNativeToolbar: resolvedAdaptiveUseNativeToolbar,
                      appBar: effectiveAppBar,
                      cupertinoNavigationBar:
                          effectiveAppBar is ObstructingPreferredSizeWidget
                          ? effectiveAppBar
                          : null,
                    ),
              body: ColoredBox(
                color: backgroundColor,
                child: hasAdaptiveBottomBarOverlay
                    ? Stack(
                        children: <Widget>[
                          Positioned.fill(child: adaptiveBody),
                          Positioned(
                            left: 0,
                            right: 0,
                            bottom: 0,
                            child: resolvedBottomNavigationBar,
                          ),
                        ],
                      )
                    : adaptiveBody,
              ),
              bottomNavigationBar: hasAdaptiveBottomBarOverlay
                  ? null
                  : resolvedAdaptiveBottomNavigationBar,
              floatingActionButton: floatingActionButton,
            );
          }

          return Scaffold(
            backgroundColor: backgroundColor,
            appBar: effectiveAppBar,
            body: effectiveBody,
            bottomNavigationBar: resolvedBottomNavigationBar,
          );
        },
      ),
    );
  }
}
