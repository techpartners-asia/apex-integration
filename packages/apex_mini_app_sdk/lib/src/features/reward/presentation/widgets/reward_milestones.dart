part of '../reward_screen.dart';

class _MilestonesList extends StatelessWidget {
  const _MilestonesList({required this.l10n});

  final SdkLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    final responsive = context.responsive;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(left: responsive.dp(4)),
          child: CustomText(
            l10n.ipsRewardTitle,
            variant: MiniAppTextVariant.subtitle2,
          ),
        ),
        SizedBox(height: responsive.spacing.cardGap),
        ..._rewardMilestones.map(_RewardMilestoneRow.new),
      ],
    );
  }
}

class _RewardMilestoneData {
  const _RewardMilestoneData({
    required this.months,
    required this.reward,
    required this.icon,
    required this.iconColor,
    required this.isActive,
    required this.isCompleted,
    this.statusLabel,
  });

  final int months;
  final String reward;
  final IconData icon;
  final Color iconColor;
  final bool isActive;
  final bool isCompleted;
  final String? statusLabel;
}

const List<_RewardMilestoneData> _rewardMilestones = <_RewardMilestoneData>[
  _RewardMilestoneData(
    months: 3,
    reward: '5000₮ Купон',
    icon: Icons.check_circle_rounded,
    iconColor: DesignTokens.success,
    isActive: false,
    isCompleted: true,
  ),
  _RewardMilestoneData(
    months: 6,
    reward: 'Хүү +2%',
    icon: Icons.local_fire_department_rounded,
    iconColor: DesignTokens.rose,
    isActive: true,
    isCompleted: false,
    statusLabel: 'Идэвхтэй',
  ),
  _RewardMilestoneData(
    months: 9,
    reward: 'VIP эрх',
    icon: Icons.lock_outline_rounded,
    iconColor: DesignTokens.muted,
    isActive: false,
    isCompleted: false,
  ),
  _RewardMilestoneData(
    months: 12,
    reward: '10,000₮ Купон',
    icon: Icons.lock_outline_rounded,
    iconColor: DesignTokens.muted,
    isActive: false,
    isCompleted: false,
  ),
];

class _RewardMilestoneRow extends StatelessWidget {
  const _RewardMilestoneRow(this.data);

  final _RewardMilestoneData data;

  @override
  Widget build(BuildContext context) {
    final responsive = context.responsive;

    return Padding(
      padding: EdgeInsets.only(bottom: responsive.dp(8)),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(responsive.radius(16)),
          border: Border.all(
            color: data.isActive
                ? DesignTokens.rose.withValues(alpha: 0.3)
                : DesignTokens.border,
          ),
        ),
        padding: EdgeInsets.symmetric(
          horizontal: responsive.dp(16),
          vertical: responsive.dp(14),
        ),
        child: Row(
          children: <Widget>[
            Icon(data.icon, size: responsive.dp(22), color: data.iconColor),
            SizedBox(width: responsive.dp(12)),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  CustomText(
                    '${data.months} Сар',
                    variant: MiniAppTextVariant.subtitle2,
                  ),
                  SizedBox(height: responsive.dp(2)),
                  CustomText(
                    data.reward,
                    variant: MiniAppTextVariant.caption1,
                    color: DesignTokens.muted,
                  ),
                ],
              ),
            ),
            if (data.statusLabel != null)
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: responsive.dp(10),
                  vertical: responsive.dp(4),
                ),
                decoration: BoxDecoration(
                  color: DesignTokens.rose.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(responsive.radius(12)),
                ),
                child: CustomText(
                  data.statusLabel!,
                  variant: MiniAppTextVariant.caption1,
                  color: DesignTokens.rose,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
