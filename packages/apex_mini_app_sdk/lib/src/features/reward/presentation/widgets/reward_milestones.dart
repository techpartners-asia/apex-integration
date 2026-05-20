part of '../reward_screen.dart';

/// Static milestone list shown on the reward screen.
class _MilestonesList extends StatelessWidget {
  /// Creates the reward milestones list.
  const _MilestonesList({required this.l10n});

  /// Localized reward labels.
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

/// View data for one reward milestone row.
class _RewardMilestoneData {
  /// Creates milestone row data.
  const _RewardMilestoneData({
    required this.months,
    required this.reward,
    required this.icon,
    required this.iconColor,
    required this.isActive,
    required this.isCompleted,
    this.statusLabel,
  });

  /// Number of months required for this milestone.
  final int months;

  /// Reward label shown for this milestone.
  final String reward;

  /// Leading icon for the milestone state.
  final IconData icon;

  /// Leading icon color.
  final Color iconColor;

  /// Whether this is the user's current active milestone.
  final bool isActive;

  /// Whether this milestone has already been completed.
  final bool isCompleted;

  /// Optional status badge label.
  final String? statusLabel;
}

/// Demo/static reward milestone data used by the reward UI.
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

/// Card row for one reward milestone.
class _RewardMilestoneRow extends StatelessWidget {
  /// Creates a reward milestone row.
  const _RewardMilestoneRow(this.data);

  /// Milestone data to render.
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
