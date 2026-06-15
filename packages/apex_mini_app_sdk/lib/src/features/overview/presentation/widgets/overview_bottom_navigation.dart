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

  /// Whether the trailing action button is disabled (no IPS account).
  final bool isButtonDisabled;

  /// Creates the overview bottom navigation bar.
  const OverviewBottomNavigationBar({
    super.key,
    required this.items,
    required this.selectedIndex,
    required this.onSelected,
    this.onActionPressed,
    this.isActionEnabled = true,
    this.isButtonDisabled = false,
  });

  static const double _barIconSize = AppComponentSize.icon2xl;
  static const double _barHeight = 72;
  static const double _barBorderRadius = 32;
  static final Color _indicatorTint = DesignTokens.softPeach.withAlpha(30);
  static final LiquidGlassSettings _indicatorGlassSettings =
    LiquidGlassSettings(
      glassColor: DesignTokens.softPeach,
      blur: 1.5,
      thickness: 0,
      saturation: 1.0,
      lightIntensity: 0,
      chromaticAberration: 0,
      specularSharpness: GlassSpecularSharpness.soft,
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
                    onTabSelected: (int index) {
                      if (index == selectedIndex) return;
                      onSelected(index);
                    },
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
                    maskingQuality: MaskingQuality.high,

                    // Tap/press үед bar амьтай мэдрэмжтэй болно.
                    interactionBehavior: GlassInteractionBehavior.full,
                    pressScale: 1.03,
                    interactionGlowColor: _indicatorTint,
                    interactionGlowRadius: 1.8,

                    // Icon glow-г арай хурдан, зөөлөн болгоно.
                    glowDuration: const Duration(milliseconds: 260),
                    glowBlurRadius: 28,
                    glowSpreadRadius: 6,
                    glowOpacity: 0.5,

                    selectedIconColor: DesignTokens.rose,
                    unselectedIconColor: DesignTokens.ink,
                    indicatorColor: _indicatorTint,
                    indicatorSettings: _indicatorGlassSettings,

                    // Танай package хувилбар дээр энэ нэрээр ажиллаж байгаа бол хэвээр нь үлдээ.
                    glassSettings: const LiquidGlassSettings(
                      glassColor: Color.fromARGB(160, 255, 255, 255),
                      thickness: 18,
                      blur: 10,
                      saturation: 1.25,
                      lightIntensity: 0.45,
                      specularSharpness: GlassSpecularSharpness.medium,
                    ),

                    tabs: items
                        .map(
                          (OverviewBottomNavigationItem item) => GlassBottomBarTab(
                            label: item.label,
                            icon: _iconWidget(item.icon, DesignTokens.ink),
                            activeIcon: _gradientIconWidget(item.icon),
                            glowColor: DesignTokens.softPeach.withAlpha(90),
                          ),
                        )
                        .toList(),
                                ),
                              ),
                            ),
                          ), 
            const SizedBox(width: 12),
            InvestXFloatingButton(
              disabled: isButtonDisabled,
              onTap: isButtonDisabled ? null : () => _handleActionPressed(context),
            ),
          ],
        ),
      ),
    );
  }

  void _handleActionPressed(BuildContext context) {
    if (isActionEnabled) {
      onActionPressed?.call();
      return;
    }

    MiniAppToast.showWarning(
      context,
      message: context.l10n.ipsOverviewActionPendingOrderMessage,
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
  bool isButtonDisabled = false,
}) {
  final l10n = context.l10n;

  return OverviewBottomNavigationBar(
    selectedIndex: selectedIndex,
    onSelected: onSelected,
    onActionPressed: onActionPressed,
    isActionEnabled: isActionEnabled,
    isButtonDisabled: isButtonDisabled,
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

  /// When true, the button is rendered in a disabled (greyed-out) state and
  /// does not respond to taps.
  final bool disabled;

  /// Creates the InvestX floating action button.
  const InvestXFloatingButton({super.key, this.onTap, this.disabled = false});

  @override
  Widget build(BuildContext context) {
    final responsive = context.responsive;

    return Semantics(
      button: true,
      enabled: !disabled,
      label: context.l10n.ipsOverviewActionTitle,
      child: GestureDetector(
        onTap: disabled ? null : onTap,
        behavior: HitTestBehavior.opaque,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          curve: Curves.easeOut,
          width: responsive.dp(62),
          height: responsive.dp(62),
          decoration: BoxDecoration(
            gradient: disabled ? null : DesignTokens.primaryGradient,
            color: disabled ? DesignTokens.ink.withAlpha(40) : null,
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.trending_up_rounded,
            color: disabled
                ? DesignTokens.ink.withAlpha(100)
                : DesignTokens.white,
            size: 37,
          ),
        ),
      ),
    );
  }
}
