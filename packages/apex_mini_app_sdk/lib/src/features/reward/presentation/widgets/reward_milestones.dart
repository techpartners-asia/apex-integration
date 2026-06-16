part of '../reward_screen.dart';

/// Loyalty milestone list from the API.
class _MilestonesList extends StatelessWidget {
  const _MilestonesList({required this.l10n, required this.items});

  final SdkLocalizations l10n;
  final List<LoyaltyItemDto> items;

  @override
  Widget build(BuildContext context) {
    final responsive = context.responsive;

    if (items.isEmpty) return const SizedBox.shrink();

    return MiniAppGlassCard(
      radius: responsive.radius(20),
      padding: EdgeInsets.all(responsive.dp(16)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(left: responsive.dp(4)),
            child: CustomText(
              l10n.ipsRewardTitle,
              variant: MiniAppTextVariant.subtitle3,
            ),
          ),
          SizedBox(height: responsive.dp(16)),
          for (int i = 0; i < items.length; i++) ...<Widget>[
            _RewardMilestoneRow(item: items[i], l10n: l10n),
            if (i < items.length - 1)
              _MilestoneConnector(responsive: responsive),
          ],
        ],
      ),
    );
  }
}

/// Card row for one loyalty milestone.
class _RewardMilestoneRow extends StatelessWidget {
  const _RewardMilestoneRow({required this.item, required this.l10n});

  final LoyaltyItemDto item;
  final SdkLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    final responsive = context.responsive;

    final bool isCompleted = item.status == LoyaltyStatus.passed;
    final bool isActive = item.status == LoyaltyStatus.active;

    return Row(
      children: <Widget>[
          _StatusIcon(
            isCompleted: isCompleted,
            isActive: isActive,
            responsive: responsive,
          ),
          SizedBox(width: responsive.dp(12)),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    CustomText(
                      item.name,
                      variant: MiniAppTextVariant.subtitle3,
                    ),
                    SizedBox(width: responsive.dp(16)),
                    if (isActive) ...<Widget>[
                      SizedBox(width: responsive.dp(8)),
                      _StatusBadge(
                        label: l10n.ipsStatusActive,
                        textColor: DesignTokens.successDeep,
                        bgColor: DesignTokens.success.withValues(alpha: 0.12),
                        responsive: responsive,
                      ),
                    ],
                  ],
                ),
                if (item.bonus > 0) ...<Widget>[
                  SizedBox(height: responsive.dp(2)),
                  CustomText(
                    _formatBonus(item.bonus, item.bonusType, l10n),
                    variant: MiniAppTextVariant.caption1,
                    color: DesignTokens.muted,
                  ),
                ],
              ],
            ),
          ),
      ],
    );
  }
}

String _formatBonus(int bonus, String bonusType, SdkLocalizations l10n) {
  switch (bonusType.toUpperCase()) {
    case 'CUPON':
      return '$bonus₮ ${l10n.ipsRewardBonusCupon}';
    case 'PERCENT':
      return '+$bonus%';
    case 'INTEREST':
      return '${l10n.ipsRewardBonusInterest} +$bonus';
    default:
      return '$bonus $bonusType';
  }
}

/// Vertical connector line between two milestone rows, aligned to icon center.
class _MilestoneConnector extends StatelessWidget {
  const _MilestoneConnector({required this.responsive});

  final MiniAppResponsiveData responsive;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: responsive.dp(48),
      child: Center(
        child: Container(
          width: 2,
          height: responsive.dp(24),
          color: DesignTokens.agreementUnchecked,
        ),
      ),
    );
  }
}

/// Circular status icon for a milestone row.
class _StatusIcon extends StatelessWidget {
  const _StatusIcon({
    required this.isCompleted,
    required this.isActive,
    required this.responsive,
  });

  final bool isCompleted;
  final bool isActive;
  final MiniAppResponsiveData responsive;

  @override
  Widget build(BuildContext context) {
    final double size = responsive.dp(48);

    if (isActive) {
      return Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          gradient: DesignTokens.primaryGradient,
          color: DesignTokens.rose,
          shape: BoxShape.circle,
          border: Border.all(
            color: DesignTokens.coral,
            width: 2,
          ),
          boxShadow: const <BoxShadow>[
            BoxShadow(
              color: Color(0x3BC87530),
              offset: Offset(0, 6.16),
              blurRadius: 9.23,
            ),
          ],
        ),
        child: Center(
          child: Image.asset(
            Img.fireWhite,
            package: packageName,
            width: responsive.dp(20),
            height: responsive.dp(20),
            fit: BoxFit.contain,
          ),
        ),
      );
    }

    if (isCompleted) {
      return Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: DesignTokens.success.withValues(alpha: 0.12),
          shape: BoxShape.circle,
          border: Border.all(
            color: DesignTokens.successStrong,
            width: 2,
          ),
        ),
        child: Icon(
          Icons.check_rounded,
          size: responsive.dp(22),
          color: DesignTokens.successDeep,
        ),
      );
    }

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: DesignTokens.softSurface,
        shape: BoxShape.circle,
        border: Border.all(
          color: DesignTokens.border,
          width: 2,
        ),
      ),
      child: Icon(
        Icons.lock_outline_rounded,
        size: responsive.dp(22),
        color: DesignTokens.muted,
      ),
    );
  }
}

/// Small badge showing the milestone status label.
class _StatusBadge extends StatelessWidget {
  const _StatusBadge({
    required this.label,
    required this.textColor,
    required this.bgColor,
    required this.responsive,
  });

  final String label;
  final Color textColor;
  final Color bgColor;
  final MiniAppResponsiveData responsive;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: responsive.dp(10),
        vertical: responsive.dp(4),
      ),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(responsive.radius(12)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
            width: responsive.dp(4),
            height: responsive.dp(4),
            decoration: BoxDecoration(
              color: textColor,
              shape: BoxShape.circle,
            ),
          ),
          SizedBox(width: responsive.dp(4)),
          CustomText(
            label,
            variant: MiniAppTextVariant.caption2,
            color: textColor,
          ),
        ],
      ),
    );
  }
}
