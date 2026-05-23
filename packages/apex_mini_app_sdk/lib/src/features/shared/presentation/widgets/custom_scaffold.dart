import 'package:adaptive_platform_ui/adaptive_platform_ui.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:apex_mini_app_sdk/apex_mini_app_sdk.dart';

/// Shared scaffold used by Apex mini-app screens.
///
/// It centralizes the SDK theme wrapper, custom app bar behavior, adaptive tab
/// shell support, safe-area padding, refresh handling, and bottom navigation
/// placement so feature screens stay consistent.
class CustomScaffold extends StatelessWidget {
  /// Header title used by the default body layout.
  final String title;

  /// Optional custom app bar. When absent, [CustomAppBar] is built.
  final PreferredSizeWidget? appBar;

  /// Whether this screen should display an app bar.
  final bool hasAppBar;

  /// Complete body override. When absent, [children] are wrapped in
  /// [CustomScaffoldBody].
  final Widget? body;

  /// Standard Flutter bottom navigation/footer widget.
  final Widget? bottomNavigationBar;

  /// Adaptive bottom navigation used by the iOS/Android platform UI layer.
  final AdaptiveBottomNavigationBar? adaptiveBottomNavigationBar;

  /// Whether adaptive scaffold may use a native toolbar when no app bar exists.
  final bool adaptiveUseNativeToolbar;

  /// Optional subtitle shown by the default body layout.
  final String? subtitle;

  /// Optional widget displayed near the app bar title.
  final Widget? trailing;

  /// App bar title override.
  final String? appBarTitle;

  /// App bar title style override.
  final TextStyle? appBarTitleStyle;

  /// Whether the default app bar centers the title.
  final bool appBarCenterTitle;

  /// Whether the default app bar reserves leading space when no back button is
  /// shown.
  final bool appBarReserveLeadingSpace;

  /// Optional app bar title spacing.
  final double? appBarTitleSpacing;

  /// Header/body actions passed to the default body layout.
  final List<Widget> actions;

  /// Children rendered by the default body layout.
  final List<Widget> children;

  /// Overrides automatic back-button visibility.
  final bool? showBackButton;

  /// Whether the default app bar shows the mini-app close button.
  final bool showCloseButton;

  /// Whether the default app bar shows a clear action.
  final bool showClearButton;

  /// Scaffold background color.
  final Color backgroundColor;

  /// App bar background color.
  final Color appBarBackgroundColor;

  /// Whether the default app bar draws a bottom divider.
  final bool appBarShowBottomBorder;

  /// Optional back action override.
  final VoidCallback? onBack;

  /// Optional dismiss action override.
  final VoidCallback? onDismiss;

  /// Optional clear action.
  final VoidCallback? onClear;

  /// Whether body bottom padding should include the device safe area.
  final bool hasSafeArea;

  /// Optional floating action button.
  final Widget? floatingActionButton;

  /// Pull-to-refresh callback for the default body layout.
  final Future<void> Function()? onRefresh;

  /// Feature flag used by screens that need trading-specific UI state.
  final bool isTradingEnabled;

  /// Creates the shared Apex mini-app scaffold.
  const CustomScaffold({
    super.key,
    this.title = '',
    this.appBar,
    this.hasAppBar = true,
    this.body,
    this.bottomNavigationBar,
    this.adaptiveBottomNavigationBar,
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
    this.backgroundColor = DesignTokens.softSurface,
    this.appBarBackgroundColor = DesignTokens.softSurface,
    this.appBarShowBottomBorder = false,
    this.onBack,
    this.onDismiss,
    this.onClear,
    this.hasSafeArea = true,
    this.floatingActionButton,
    this.onRefresh,
    this.isTradingEnabled = false,
  });

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: DesignTokens.theme(Theme.of(context)),
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
                    CustomAppBar(
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
                      onDismiss: onDismiss,
                      onClear: onClear,
                    )
              : null;
          final Widget effectiveBody =
              body ??
              CustomScaffoldBody(
                title: title,
                subtitle: subtitle,
                actions: actions,
                bodyPadding: bodyPadding,
                onRefresh: onRefresh,
                refreshIndicatorColor: DesignTokens.rose,
                children: children,
              );
          final AdaptiveBottomNavigationBar?
          resolvedAdaptiveBottomNavigationBar = adaptiveBottomNavigationBar;
          final Widget? resolvedBottomNavigationBar = bottomNavigationBar;
          final bool hasAdaptiveShell =
              resolvedAdaptiveBottomNavigationBar != null;
          final bool resolvedAdaptiveUseNativeToolbar =
              adaptiveUseNativeToolbar && effectiveAppBar == null;

          if (hasAdaptiveShell) {
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
              minimizeBehavior: TabBarMinimizeBehavior.never,
              body: ColoredBox(
                color: backgroundColor,
                child: effectiveBody,
              ),
              bottomNavigationBar: resolvedAdaptiveBottomNavigationBar,
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
