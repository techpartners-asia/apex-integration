import 'package:apex_mini_app_sdk/apex_mini_app_sdk.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:liquid_glass_widgets/liquid_glass_widgets.dart';

/// Tab indexes used by the overview bottom navigation shell.
final class OverviewBottomNavigation {
  /// Home/dashboard tab index.
  static const int homeIndex = 0;

  /// Profile tab index.
  static const int profileIndex = 1;

  const OverviewBottomNavigation._();
}

/// Glass-style bottom navigation used by the overview screen.
class OverviewBottomNavigationBar extends StatelessWidget {
  /// Tab definitions rendered inside the glass bar.
  final List<OverviewBottomNavigationItem> items;

  /// Currently selected tab index.
  final int selectedIndex;

  /// Called when the user selects a tab.
  final ValueChanged<int> onSelected;

  /// Called when the trailing action button is pressed.
  final VoidCallback? onActionPressed;

  /// Whether the trailing action button is shown and tappable.
  final bool isActionEnabled;

  /// Creates the overview bottom navigation bar.
  const OverviewBottomNavigationBar({
    super.key,
    required this.items,
    required this.selectedIndex,
    required this.onSelected,
    this.onActionPressed,
    this.isActionEnabled = true,
  });

  static const double _barIconSize = AppComponentSize.icon2xl;
  static const double _barHeight = 72;
  static const double _barBorderRadius = 32;
  static final Color _indicatorTint = DesignTokens.softPeach.withAlpha(30);
  static final LiquidGlassSettings _indicatorGlassSettings =
      LiquidGlassSettings(
        glassColor: _indicatorTint,
        blur: 0,
        thickness: 0,
        saturation: 1,
        lightIntensity: 0,
        chromaticAberration: 0,
        specularSharpness: GlassSpecularSharpness.medium,
      );

  Widget _iconWidget(Object icon, Color color) {
    if (icon is IconData) {
      return Icon(icon, color: color, size: _barIconSize);
    }
    if (icon is String) {
      if (icon.endsWith('.svg')) {
        return SvgPicture.asset(
          icon,
          package: packageName,
          width: _barIconSize,
          height: _barIconSize,
          colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
        );
      }
      return Image.asset(
        icon,
        package: packageName,
        width: _barIconSize,
        height: _barIconSize,
        color: color,
      );
    }
    throw ArgumentError(
      'Bottom nav icon must be IconData or asset path String',
    );
  }

  Widget _gradientIconWidget(Object icon) {
    return ShaderMask(
      blendMode: BlendMode.srcIn,
      shaderCallback: (Rect bounds) =>
          DesignTokens.primaryGradient.createShader(bounds),
      child: _iconWidget(icon, DesignTokens.white),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: <Widget>[
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(_barBorderRadius),
                clipBehavior: Clip.antiAlias,
                child: SizedBox(
                  height: _barHeight,
                  child: GlassBottomBar(
                    selectedIndex: selectedIndex,
                    onTabSelected: onSelected,
                    barHeight: _barHeight,
                    barBorderRadius: _barBorderRadius,
                    horizontalPadding: 0,
                    verticalPadding: 0,
                    spacing: 0,
                    tabPadding: EdgeInsets.zero,
                    iconLabelSpacing: 2,
                    iconSize: _barIconSize,
                    labelFontSize: 13,
                    indicatorExpansion: 8,
                    selectedIconColor: DesignTokens.rose,
                    unselectedIconColor: DesignTokens.ink,
                    indicatorColor: _indicatorTint,
                    indicatorSettings: _indicatorGlassSettings,
                    interactionGlowColor: _indicatorTint,
                    glassSettings: const LiquidGlassSettings(
                      glassColor: Color.fromARGB(160, 255, 255, 255),
                      thickness: 14,
                      blur: 8,
                      saturation: 1.2,
                      lightIntensity: 0.35,
                      specularSharpness: GlassSpecularSharpness.medium,
                    ),
                    tabs: items
                        .map(
                          (OverviewBottomNavigationItem item) =>
                              GlassBottomBarTab(
                            label: item.label,
                            icon: _iconWidget(item.icon, DesignTokens.ink),
                            activeIcon: _gradientIconWidget(item.icon),
                          ),
                        )
                        .toList(),
                  ),
                ),
              ),
            ),
            if (isActionEnabled) ...<Widget>[
              const SizedBox(width: 12),
              InvestXFloatingButton(onTap: onActionPressed),
            ],
          ],
        ),
      ),
    );
  }
}

/// Builds the overview bottom navigation bar with default home/profile tabs.
OverviewBottomNavigationBar buildOverviewBottomNavigationBar(
  BuildContext context, {
  required int selectedIndex,
  required ValueChanged<int> onSelected,
  VoidCallback? onActionPressed,
  bool isActionEnabled = true,
}) {
  final l10n = context.l10n;

  return OverviewBottomNavigationBar(
    selectedIndex: selectedIndex,
    onSelected: onSelected,
    onActionPressed: onActionPressed,
    isActionEnabled: isActionEnabled,
    items: <OverviewBottomNavigationItem>[
      OverviewBottomNavigationItem(
        label: l10n.commonHome,
        icon: Img.house,
      ),
      OverviewBottomNavigationItem(
        label: l10n.commonProfile,
        icon: Img.userCircle,
      ),
    ],
  );
}

/// Circular gradient InvestX action button shown beside the overview glass bar.
class InvestXFloatingButton extends StatelessWidget {
  /// Callback invoked when the action button is tapped.
  final VoidCallback? onTap;

  /// Creates the InvestX floating action button.
  const InvestXFloatingButton({super.key, this.onTap});

  @override
  Widget build(BuildContext context) {
    final responsive = context.responsive;

    return Semantics(
      button: true,
      label: context.l10n.ipsOverviewActionTitle,
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          curve: Curves.easeOut,
          width: responsive.dp(62),
          height: responsive.dp(62),
          decoration: const BoxDecoration(
            gradient: DesignTokens.primaryGradient,
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.trending_up_rounded,
            color: DesignTokens.white,
            size: 37,
          ),
        ),
      ),
    );
  }
}
