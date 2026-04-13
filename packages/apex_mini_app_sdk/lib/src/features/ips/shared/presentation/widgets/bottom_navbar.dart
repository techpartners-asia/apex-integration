import 'package:adaptive_platform_ui/adaptive_platform_ui.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mini_app_ui/mini_app_ui.dart';

import '../../../../../shared/l10n/sdk_localizations_x.dart';
import '../helpers/investx_design_tokens.dart';

class InvestXNavbar extends StatelessWidget {
  static const Key tradingActionKey = Key('investx_trading_nav_action');

  final int selectedIndex;
  final ValueChanged<int>? onSelected;
  final VoidCallback? onActionPressed;
  final bool isActionEnabled;

  const InvestXNavbar({
    super.key,
    required this.selectedIndex,
    this.onSelected,
    this.onActionPressed,
    this.isActionEnabled = true,
  });

  static const int homeIndex = 0;
  static const int profileIndex = 1;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final responsive = context.responsive;
    final bool actionEnabled = isActionEnabled && onActionPressed != null;

    return SafeArea(
      top: false,
      minimum: EdgeInsets.fromLTRB(
        responsive.dp(20),
        0,
        responsive.dp(20),
        responsive.dp(12),
      ),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(responsive.radius(999)),
          border: Border.all(color: const Color(0xFFF3F0EB)),
          boxShadow: const <BoxShadow>[
            BoxShadow(
              color: Color(0x140F172A),
              blurRadius: 24,
              offset: Offset(0, 10),
            ),
          ],
        ),
        child: Padding(
          padding: EdgeInsets.fromLTRB(
            responsive.dp(8),
            responsive.dp(8),
            responsive.dp(8),
            responsive.dp(8),
          ),
          child: Row(
            children: <Widget>[
              Expanded(
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: _buildNavItem(
                        context,
                        index: homeIndex,
                        icon: CupertinoIcons.home,
                        label: l10n.commonHome,
                        isSelected: selectedIndex == homeIndex,
                      ),
                    ),
                    Expanded(
                      child: _buildNavItem(
                        context,
                        index: profileIndex,
                        icon: CupertinoIcons.person_alt_circle,
                        label: l10n.commonProfile,
                        isSelected: selectedIndex == profileIndex,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: responsive.dp(10)),
              MiniAppAdaptivePressable(
                key: tradingActionKey,
                onPressed: actionEnabled ? onActionPressed : null,
                borderRadius: BorderRadius.circular(999),
                child: Container(
                  width: responsive.dp(52),
                  height: responsive.dp(52),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: actionEnabled ? InvestXDesignTokens.primaryGradient : null,
                    color: actionEnabled ? null : const Color(0xFFECE7E0),
                    border: actionEnabled ? null : Border.all(color: const Color(0xFFD9D1C5)),
                    boxShadow: actionEnabled ? InvestXDesignTokens.buttonShadow : const <BoxShadow>[],
                  ),
                  child: Icon(
                    Icons.trending_up_rounded,
                    color: actionEnabled ? Colors.white : const Color(0xFFB0A79A),
                    size: responsive.dp(24),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavIcon(
    BuildContext context, {
    required int index,
    required IconData icon,
    required bool isSelected,
  }) {
    final responsive = context.responsive;

    if (index == homeIndex && isSelected) {
      return Icon(CupertinoIcons.home, size: responsive.dp(20));
    }

    if (index == profileIndex) {
      return Icon(CupertinoIcons.person_alt_circle, size: responsive.dp(20));
    }

    return Icon(icon, size: responsive.dp(22));
  }

  Widget _buildNavItem(
    BuildContext context, {
    required int index,
    required IconData icon,
    required String label,
    required bool isSelected,
  }) {
    final responsive = context.responsive;

    return MiniAppAdaptivePressable(
      onPressed: onSelected == null ? null : () => onSelected!(index),
      borderRadius: BorderRadius.circular(999),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeOutCubic,
        padding: EdgeInsets.symmetric(
          horizontal: responsive.dp(12),
          vertical: responsive.dp(8),
        ),
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(999)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            _buildNavIcon(
              context,
              index: index,
              icon: icon,
              isSelected: isSelected,
            ),
            SizedBox(height: responsive.dp(2)),
            CustomText(
              label,
              variant: MiniAppTextVariant.caption,
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                fontWeight: isSelected ? MiniAppTypography.semiBold : MiniAppTypography.regular,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class InvestXBottomNavigationConfig {
  static const int homeIndex = InvestXNavbar.homeIndex;
  static const int profileIndex = InvestXNavbar.profileIndex;

  // static const int actionIndex = 2;

  final int selectedIndex;
  final ValueChanged<int>? onSelected;
  final VoidCallback? onActionPressed;
  final bool isActionEnabled;

  const InvestXBottomNavigationConfig({
    required this.selectedIndex,
    this.onSelected,
    this.onActionPressed,
    this.isActionEnabled = true,
  });
}

AdaptiveBottomNavigationBar adaptiveBottomNavigationBarWidget(
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
              ? (isActionEnabled ? CupertinoIcons.chart_bar_alt_fill : CupertinoIcons.chart_bar_alt_fill)
              : (isActionEnabled ? Icons.trending_up_rounded : Icons.trending_up_outlined),
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
