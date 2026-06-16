import 'dart:async';

import 'package:flutter/material.dart';
import 'package:apex_mini_app_sdk/apex_mini_app_sdk.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Profile tab in the overview bottom navigation.
class OverviewProfileTab extends StatelessWidget {
  /// Account/bootstrap state used to enable or disable profile menu items.
  final AcntBootstrapState data;

  /// Current user rendered in the profile header.
  final UserEntityDto? user;

  /// Optional portfolio context passed to statements.
  final SdkPortfolioContext? portfolioContext;

  /// Creates the overview profile tab.
  const OverviewProfileTab({
    super.key,
    required this.data,
    required this.user,
    this.portfolioContext,
  });

  @override
  Widget build(BuildContext context) {
    final responsive = context.responsive;
    final l10n = context.l10n;

    return SingleChildScrollView(
      padding: EdgeInsets.all(AppSpacing.xl),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          OverviewProfileHeaderCard(user: user, verified: data.hasOpenSecAcnt),
          SizedBox(height: responsive.space(AppSpacing.lg)),
          OverviewProfileMenuCard(
            items: <OverviewProfileMenuItemData>[
              /// Personal Information
              OverviewProfileMenuItemData(
                image: Img.profileBlue,
                title: l10n.ipsOverviewProfileMenuPersonalInfo,
                subtitle: data.hasIpsAcnt ? null : l10n.ipsOverviewProfilePersonalInfoMissing,
                subtitleColor: DesignTokens.danger,
                onTap: data.hasIpsAcnt ? () => launchIpsRoute(
                  context,
                  route: data.hasIpsAcnt ? MiniAppRoutes.personalInfo : MiniAppRoutes.secAcnt,
                  arguments: data,
                ) : null,
              ),

              /// Statement
              OverviewProfileMenuItemData(
                image: Img.ticketBlue,
                title: l10n.ipsPortfolioStatements,
                onTap: data.hasIpsAcnt
                    ? () => launchIpsRoute(
                        context,
                        route: MiniAppRoutes.statements,
                        arguments: portfolioContext,
                      )
                    : null,
              ),

              /// Pack information
              OverviewProfileMenuItemData(
                image: Img.faxBlue,
                title: l10n.ipsOverviewProfileMenuPackInfo,
                onTap: data.hasIpsAcnt
                    ? () => launchIpsRoute(
                        context,
                        route: MiniAppRoutes.portfolio,
                      )
                    : null,
              ),

              /// Pack orders
              OverviewProfileMenuItemData(
                image: Img.ticketBlue,
                title: l10n.ipsPortfolioOrderList,
                onTap: data.hasIpsAcnt
                    ? () async {
                        await launchIpsRoute(context, route: MiniAppRoutes.orders);
                        if (context.mounted) {
                          unawaited(
                            context.read<IpsOverviewCubit>().refreshPendingOrderStatus(),
                          );
                        }
                      }
                    : null,
              ),

              OverviewProfileMenuItemData(
                image: Img.medalBlue,
                title: l10n.ipsOverviewProfileMenuAchievements,
                onTap: () => launchIpsRoute(
                  context,
                  route: MiniAppRoutes.reward,
                ),
              ),

              /// Term condition
              OverviewProfileMenuItemData(
                image: Img.noteBlue,
                title: l10n.ipsOverviewProfileMenuTerms,
              ),

              /// Help
              OverviewProfileMenuItemData(
                image: Img.questionBlue,
                title: l10n.ipsHelpTitle,
                onTap: () => launchIpsRoute(context, route: MiniAppRoutes.help),
              ),
            ],
          ),
          SizedBox(height: responsive.space(AppSpacing.lg)),
        ],
      ),
    );
  }
}

/// Header card showing profile avatar, name, and verification status.
class OverviewProfileHeaderCard extends StatelessWidget {
  /// Current user shown in the card.
  final UserEntityDto? user;

  /// Whether the account/profile is verified.
  final bool verified;

  /// Creates the profile header card.
  const OverviewProfileHeaderCard({
    super.key,
    required this.user,
    required this.verified,
  });

  @override
  Widget build(BuildContext context) {
    final responsive = context.responsive;
    final l10n = context.l10n;
    final String displayName = user?.displayName.trim().isNotEmpty ?? false ? user!.displayName : l10n.ipsOverviewProfileGuestName;
    final String initials = displayName.split(RegExp(r'\s+')).where((String part) => part.trim().isNotEmpty).take(2).map((String part) => part.substring(0, 1).toUpperCase()).join();

    return MiniAppGlassCard(
      radius: responsive.radius(16),
      padding: EdgeInsets.all(responsive.dp(14)),
      child: Row(
        children: <Widget>[
          Stack(
            clipBehavior: Clip.none,
            children: <Widget>[
              Container(
                width: responsive.dp(48),
                height: responsive.dp(48),
                decoration: BoxDecoration(
                  color: const Color(0xFFF4F6FB),
                  borderRadius: BorderRadius.circular(responsive.radius(16)),
                ),
                clipBehavior: Clip.antiAlias,
                child: CustomImage(
                  path: Img.profileBlue,
                  fit: BoxFit.cover,
                  errorBuilder:
                      (
                        BuildContext context,
                        Object error,
                        StackTrace? stackTrace,
                      ) => Container(
                        decoration: const BoxDecoration(
                          gradient: DesignTokens.primaryGradient,
                        ),
                        alignment: Alignment.center,
                        child: CustomText(
                          initials.isEmpty ? 'I' : initials,
                          variant: MiniAppTextVariant.subtitle2,
                          color: Colors.white,
                        ),
                      ),
                ),
              ),
              // Positioned(
              //   right: -responsive.dp(2),
              //   bottom: -responsive.dp(2),
              //   child: Container(
              //     width: responsive.dp(24),
              //     height: responsive.dp(24),
              //     decoration: BoxDecoration(
              //       color: const Color(0xFF232A3A),
              //       shape: BoxShape.circle,
              //       border: Border.all(color: Colors.white, width: 2),
              //       boxShadow: const <BoxShadow>[
              //         BoxShadow(
              //           color: Color(0x140F172A),
              //           blurRadius: 8,
              //           offset: Offset(0, 4),
              //         ),
              //       ],
              //     ),
              //     child: Center(
              //       child: CustomImage(
              //         path: Img.camera,
              //         width: responsive.dp(16),
              //         height: responsive.dp(16),
              //         fit: BoxFit.contain,
              //       ),
              //     ),
              //   ),
              // ),
            ],
          ),
          SizedBox(width: responsive.dp(12)),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                CustomText(
                  displayName,
                  variant: MiniAppTextVariant.subtitle3,
                ),
                SizedBox(height: responsive.dp(4)),
                Row(
                  children: <Widget>[
                    Icon(
                      Icons.verified_rounded,
                      size: responsive.dp(16),
                      color: verified ? DesignTokens.success : DesignTokens.muted,
                    ),
                    SizedBox(width: responsive.dp(6)),
                    CustomText(
                      verified ? l10n.ipsOverviewProfileVerified : l10n.ipsStatusPending,
                      variant: MiniAppTextVariant.caption1,
                      color: verified ? DesignTokens.success : DesignTokens.muted,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Container for the profile menu rows.
class OverviewProfileMenuCard extends StatelessWidget {
  /// Menu rows to render.
  final List<OverviewProfileMenuItemData> items;

  /// Creates a profile menu card.
  const OverviewProfileMenuCard({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    final responsive = context.responsive;

    return MiniAppGlassCard(
      radius: responsive.radius(16),
      padding: EdgeInsets.zero,
      child: Column(
        children: items.map((e) => OverviewProfileMenuRow(item: e)).toList(growable: false),
      ),
    );
  }
}

/// One tappable row in the profile menu.
class OverviewProfileMenuRow extends StatelessWidget {
  /// Row data.
  final OverviewProfileMenuItemData item;

  /// Creates a profile menu row.
  const OverviewProfileMenuRow({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    final responsive = context.responsive;
    final bool isEnabled = item.enabled && item.onTap != null;
    final Color titleColor = item.enabled ? DesignTokens.ink : DesignTokens.muted;
    final Color subtitleColor = item.subtitleColor ?? (item.enabled ? DesignTokens.muted : DesignTokens.border);
    final Color chevronColor = isEnabled ? DesignTokens.muted : DesignTokens.border;

    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(responsive.radius(16)),
      child: InkWell(
        borderRadius: BorderRadius.circular(responsive.radius(16)),
        onTap: isEnabled ? item.onTap : null,
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: responsive.dp(18),
            vertical: responsive.dp(16),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              // Icon(item.icon, color: iconColor, size: responsive.dp(20)),
              CustomImage(
                path: item.image,
                width: responsive.dp(20),
                height: responsive.dp(20),
                fit: BoxFit.contain,
              ),
              SizedBox(width: responsive.dp(14)),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    CustomText(
                      item.title,
                      variant: MiniAppTextVariant.subtitle3,
                      color: titleColor,
                    ),
                    if (item.subtitle != null && item.subtitle!.trim().isNotEmpty) ...<Widget>[
                      SizedBox(height: responsive.dp(2)),
                      CustomText(
                        item.subtitle!,
                        variant: MiniAppTextVariant.caption1,
                        color: subtitleColor,
                      ),
                    ],
                  ],
                ),
              ),
              SizedBox(width: responsive.dp(8)),
              Visibility(
                visible: !item.isProfile,
                child: Icon(
                  Icons.chevron_right_rounded,
                  color: chevronColor,
                  size: responsive.dp(20),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Data model for one profile menu row.
class OverviewProfileMenuItemData {
  /// Leading image asset.
  final String image;

  /// Row title.
  final String title;

  /// Optional row subtitle.
  final String? subtitle;

  /// Optional subtitle color override.
  final Color? subtitleColor;

  /// Row tap action.
  final VoidCallback? onTap;

  /// Whether the row is visually enabled.
  final bool enabled;

  /// Whether this row represents the profile header/action.
  final bool isProfile;

  /// Creates a profile menu item.
  const OverviewProfileMenuItemData({
    required this.image,
    required this.title,
    this.subtitle,
    this.subtitleColor,
    this.onTap,
    this.enabled = true,
    this.isProfile = false,
  });
}
