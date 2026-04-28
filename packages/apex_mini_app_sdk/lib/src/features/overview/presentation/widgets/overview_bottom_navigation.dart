import 'package:adaptive_platform_ui/adaptive_platform_ui.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mini_app_sdk/mini_app_sdk.dart';

final class OverviewBottomNavigation {
  static const int homeIndex = 0;
  static const int profileIndex = 1;

  const OverviewBottomNavigation._();
}

AdaptiveBottomNavigationBar buildOverviewBottomNavigationBar(
  BuildContext context, {
  required int selectedIndex,
  required ValueChanged<int> onSelected,
  VoidCallback? onActionPressed,
  bool isActionEnabled = true,
}) {
  final l10n = context.l10n;

  return AdaptiveBottomNavigationBar(
    useNativeBottomBar: true,
    selectedIndex: selectedIndex,
    onTap: (int index) {
      if (index == 2) {
        if (!isActionEnabled) {
          return;
        }
        onActionPressed?.call();
        return;
      }
      onSelected(index);
    },
    selectedItemColor: DesignTokens.softPeach,
    items: <AdaptiveNavigationDestination>[
      AdaptiveNavigationDestination(
        icon: PlatformInfo.isIOS26OrHigher()
            ? "house.fill"
            : PlatformInfo.isIOS
            ? CupertinoIcons.home
            : Icons.home_outlined,
        selectedIcon: PlatformInfo.isIOS26OrHigher()
            ? "house.fill"
            : PlatformInfo.isIOS
            ? CupertinoIcons.home
            : Icons.home,
        label: l10n.commonHome,
      ),
      AdaptiveNavigationDestination(
        icon: PlatformInfo.isIOS26OrHigher()
            ? "person.fill"
            : PlatformInfo.isIOS
            ? CupertinoIcons.person
            : Icons.person_outline,
        selectedIcon: PlatformInfo.isIOS26OrHigher()
            ? "person.fill"
            : PlatformInfo.isIOS
            ? CupertinoIcons.person_fill
            : Icons.person,
        label: l10n.commonProfile,
        addSpacerAfter: true,
      ),
      if (isActionEnabled)
        AdaptiveNavigationDestination(
          icon: PlatformInfo.isIOS26OrHigher()
              ? "chart.line.uptrend.xyaxis"
              : PlatformInfo.isIOS
              ? CupertinoIcons.chart_bar_alt_fill
              : Icons.trending_up_rounded,
          selectedIcon: PlatformInfo.isIOS26OrHigher()
              ? "chart.line.uptrend.xyaxis"
              : PlatformInfo.isIOS
              ? CupertinoIcons.chart_bar_alt_fill
              : Icons.trending_up_rounded,
          label: l10n.ipsOverviewActionTitle,
        ),
    ],
  );
}
