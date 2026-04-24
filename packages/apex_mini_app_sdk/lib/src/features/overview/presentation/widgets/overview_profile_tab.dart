import 'package:flutter/material.dart';
import 'package:mini_app_ui/mini_app_ui.dart';
import 'package:mini_app_sdk/mini_app_sdk.dart';

class OverviewProfileTab extends StatelessWidget {
  final AcntBootstrapState data;
  final UserEntityDto? user;
  final SdkPortfolioContext? portfolioContext;

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
                onTap: () => launchIpsRoute(
                  context,
                  route: data.hasIpsAcnt ? MiniAppRoutes.personalInfo : MiniAppRoutes.secAcnt,
                  arguments: data,
                ),
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

              /// Achievements
              /// todo admin deer bolsni daraa oruulah
              OverviewProfileMenuItemData(
                image: Img.medalBlue,
                title: l10n.ipsOverviewProfileMenuAchievements,
                // onTap: () => launchIpsRoute(
                //   context,
                //   route: MiniAppRoutes.reward,
                // ),
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
                onTap: () => launchIpsRoute(
                  context,
                  route: MiniAppRoutes.help,
                ),
              ),

              /// Liquid Glass Demo Screen
              // OverviewProfileMenuItemData(
              //   image: Img.callBlue,
              //   title: 'Liquid Glass Demo Screen',
              //   onTap: () => launchIpsRoute(
              //     context,
              //     route: MiniAppRoutes.liquidGlassDemo,
              //   ),
              // ),
            ],
          ),
          SizedBox(height: responsive.space(AppSpacing.lg)),
        ],
      ),
    );
  }
}

class OverviewProfileHeaderCard extends StatelessWidget {
  final UserEntityDto? user;
  final bool verified;

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

    return Container(
      padding: EdgeInsets.all(responsive.dp(14)),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(responsive.radius(16)),
      ),
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
                          variant: MiniAppTextVariant.body,
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: Colors.white,
                            fontWeight: MiniAppTypography.bold,
                          ),
                        ),
                      ),
                ),
              ),
              Positioned(
                right: -responsive.dp(2),
                bottom: -responsive.dp(2),
                child: Container(
                  width: responsive.dp(24),
                  height: responsive.dp(24),
                  decoration: BoxDecoration(
                    color: const Color(0xFF232A3A),
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2),
                    boxShadow: const <BoxShadow>[
                      BoxShadow(
                        color: Color(0x140F172A),
                        blurRadius: 8,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Center(
                    child: CustomImage(
                      path: Img.camera,
                      width: responsive.dp(16),
                      height: responsive.dp(16),
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(width: responsive.dp(12)),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                CustomText(
                  displayName,
                  variant: MiniAppTextVariant.body,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: MiniAppTypography.semiBold,
                  ),
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
                      variant: MiniAppTextVariant.caption,
                      style: Theme.of(context).textTheme.labelMedium?.copyWith(
                        color: verified ? DesignTokens.success : DesignTokens.muted,
                        fontWeight: MiniAppTypography.semiBold,
                      ),
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

class OverviewProfileMenuCard extends StatelessWidget {
  final List<OverviewProfileMenuItemData> items;

  const OverviewProfileMenuCard({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    final responsive = context.responsive;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(responsive.radius(16)),
      ),
      child: Column(
        children: items.map((e) => OverviewProfileMenuRow(item: e)).toList(growable: false),
      ),
    );
  }
}

class OverviewProfileMenuRow extends StatelessWidget {
  final OverviewProfileMenuItemData item;

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
                      variant: MiniAppTextVariant.body,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: titleColor,
                        fontWeight: MiniAppTypography.semiBold,
                      ),
                    ),
                    if (item.subtitle != null && item.subtitle!.trim().isNotEmpty) ...<Widget>[
                      SizedBox(height: responsive.dp(2)),
                      CustomText(
                        item.subtitle!,
                        variant: MiniAppTextVariant.caption,
                        style: Theme.of(
                          context,
                        ).textTheme.bodySmall?.copyWith(color: subtitleColor),
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

class OverviewProfileMenuItemData {
  final String image;
  final String title;
  final String? subtitle;
  final Color? subtitleColor;
  final VoidCallback? onTap;
  final bool enabled;
  final bool isProfile;

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
