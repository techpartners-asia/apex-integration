part of '../reward_screen.dart';

class _GoalCard extends StatelessWidget {
  const _GoalCard({required this.l10n});

  final SdkLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    final responsive = context.responsive;

    return SectionCard(
      padding: EdgeInsets.all(responsive.dp(18)),
      children: <Widget>[
        Row(
          children: <Widget>[
            Container(
              width: responsive.dp(40),
              height: responsive.dp(40),
              decoration: BoxDecoration(
                color: DesignTokens.softSurface,
                borderRadius: BorderRadius.circular(responsive.radius(12)),
              ),
              child: Icon(
                Icons.flag_outlined,
                size: responsive.dp(22),
                color: DesignTokens.ink,
              ),
            ),
            SizedBox(width: responsive.dp(12)),
            Expanded(
              child: CustomText(
                l10n.ipsRewardGoalTitle,
                variant: MiniAppTextVariant.subtitle3,
              ),
            ),
          ],
        ),
        SizedBox(height: responsive.dp(14)),
        Row(
          children: <Widget>[
            CustomText(
              l10n.ipsRewardGoalProgress,
              variant: MiniAppTextVariant.caption1,
              color: DesignTokens.muted,
            ),
            const Spacer(),
            CustomText(
              '500,000₮ / 1,000,000₮',
              variant: MiniAppTextVariant.subtitle3,
            ),
          ],
        ),
        SizedBox(height: responsive.dp(8)),
        ClipRRect(
          borderRadius: BorderRadius.circular(responsive.radius(6)),
          child: LinearProgressIndicator(
            value: 0.5,
            minHeight: responsive.dp(6),
            backgroundColor: DesignTokens.border,
            valueColor: const AlwaysStoppedAnimation<Color>(
              DesignTokens.success,
            ),
          ),
        ),
      ],
    );
  }
}

class _StreakCard extends StatelessWidget {
  const _StreakCard({required this.l10n});

  final SdkLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    final responsive = context.responsive;

    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: <Color>[Color(0xFFFFF0EC), Color(0xFFFFF6F0)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(responsive.radius(20)),
        border: Border.all(color: DesignTokens.border),
        boxShadow: DesignTokens.cardShadow,
      ),
      padding: EdgeInsets.all(responsive.dp(18)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          CustomText(
            l10n.ipsRewardStreakTitle,
            variant: MiniAppTextVariant.subtitle3,
          ),
          SizedBox(height: responsive.dp(12)),
          Row(
            children: <Widget>[
              CustomText(
                l10n.ipsRewardStreakMonths(6, 12),
                variant: MiniAppTextVariant.title1,
              ),
              SizedBox(width: responsive.dp(10)),
              _StreakDots(responsive: responsive, streakCount: 6, total: 12),
              SizedBox(width: responsive.dp(6)),
              CustomText(
                '🔥',
                variant: MiniAppTextVariant.subtitle2,
              ),
            ],
          ),
          SizedBox(height: responsive.dp(8)),
          ClipRRect(
            borderRadius: BorderRadius.circular(responsive.radius(6)),
            child: LinearProgressIndicator(
              value: 0.5,
              minHeight: responsive.dp(6),
              backgroundColor: DesignTokens.border,
              valueColor: const AlwaysStoppedAnimation<Color>(
                DesignTokens.rose,
              ),
            ),
          ),
          SizedBox(height: responsive.dp(10)),
          CustomText(
            l10n.ipsRewardStreakNextReward('+2% хүү'),
            variant: MiniAppTextVariant.caption1,
            color: DesignTokens.muted,
          ),
        ],
      ),
    );
  }
}

class _StreakDots extends StatelessWidget {
  const _StreakDots({
    required this.responsive,
    required this.streakCount,
    required this.total,
  });

  final MiniAppResponsiveData responsive;
  final int streakCount;
  final int total;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List<Widget>.generate(
        total > 8 ? 8 : total,
        (int index) => Container(
          width: responsive.dp(8),
          height: responsive.dp(8),
          margin: EdgeInsets.only(right: responsive.dp(3)),
          decoration: BoxDecoration(
            color: index < streakCount
                ? DesignTokens.rose
                : DesignTokens.border,
            shape: BoxShape.circle,
          ),
        ),
      ),
    );
  }
}

class _NextGoalCard extends StatelessWidget {
  const _NextGoalCard({required this.l10n});

  final SdkLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    final responsive = context.responsive;

    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: <Color>[Color(0xFFE8F8F5), Color(0xFFF0FBF8)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(responsive.radius(20)),
        border: Border.all(color: DesignTokens.border),
      ),
      padding: EdgeInsets.all(responsive.dp(18)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          CustomText(
            l10n.ipsRewardNextGoalTitle,
            variant: MiniAppTextVariant.subtitle3,
            color: DesignTokens.primaryTeal,
          ),
          SizedBox(height: responsive.dp(6)),
          CustomText(
            l10n.ipsRewardNextGoalBody,
            variant: MiniAppTextVariant.caption1,
            color: DesignTokens.muted,
          ),
        ],
      ),
    );
  }
}
