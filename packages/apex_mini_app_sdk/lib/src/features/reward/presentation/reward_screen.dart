import 'package:flutter/material.dart';
import 'package:mini_app_ui/mini_app_ui.dart';
import 'package:mini_app_sdk/mini_app_sdk.dart';

class RewardScreen extends StatelessWidget {
  const RewardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final responsive = context.responsive;
    final l10n = context.l10n;

    return CustomScaffold(
      appBarTitle: l10n.ipsRewardTitle,
      showCloseButton: false,
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(
          horizontal: responsive.spacing.financialCardSpacing,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            SizedBox(height: responsive.spacing.sectionSpacing),
            _GoalCard(l10n: l10n),
            SizedBox(height: responsive.spacing.cardGap),
            _StreakCard(l10n: l10n),
            SizedBox(height: responsive.spacing.cardGap),
            _NextGoalCard(l10n: l10n),
            SizedBox(height: responsive.spacing.sectionSpacing),
            _MilestonesList(l10n: l10n),
            SizedBox(height: responsive.spacing.sectionSpacing * 2),
          ],
        ),
      ),
    );
  }
}

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
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: MiniAppTypography.bold,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: responsive.dp(14)),
        Row(
          children: <Widget>[
            CustomText(
              l10n.ipsRewardGoalProgress,
              variant: MiniAppTextVariant.caption,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: DesignTokens.muted,
              ),
            ),
            const Spacer(),
            CustomText(
              '500,000₮ / 1,000,000₮',
              variant: MiniAppTextVariant.caption,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                fontWeight: MiniAppTypography.semiBold,
              ),
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
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
              fontWeight: MiniAppTypography.bold,
            ),
          ),
          SizedBox(height: responsive.dp(12)),
          Row(
            children: <Widget>[
              CustomText(
                l10n.ipsRewardStreakMonths(6, 12),
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: MiniAppTypography.bold,
                ),
              ),
              SizedBox(width: responsive.dp(10)),
              _buildStreakDots(context, responsive, streakCount: 6, total: 12),
              SizedBox(width: responsive.dp(6)),
              CustomText(
                '🔥',
                style: Theme.of(context).textTheme.titleMedium,
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
            variant: MiniAppTextVariant.caption,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: DesignTokens.muted,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStreakDots(
    BuildContext context,
    MiniAppResponsiveData responsive, {
    required int streakCount,
    required int total,
  }) {
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
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
              fontWeight: MiniAppTypography.bold,
              color: DesignTokens.primaryTeal,
            ),
          ),
          SizedBox(height: responsive.dp(6)),
          CustomText(
            l10n.ipsRewardNextGoalBody,
            variant: MiniAppTextVariant.bodySmall,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: DesignTokens.muted,
              height: 1.45,
            ),
          ),
        ],
      ),
    );
  }
}

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
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: MiniAppTypography.bold,
            ),
          ),
        ),
        SizedBox(height: responsive.spacing.cardGap),
        _MilestoneRow(
          months: 3,
          reward: '5000₮ Купон',
          icon: Icons.check_circle_rounded,
          iconColor: DesignTokens.success,
          isActive: false,
          isCompleted: true,
        ),
        _MilestoneRow(
          months: 6,
          reward: 'Хүү +2%',
          icon: Icons.local_fire_department_rounded,
          iconColor: DesignTokens.rose,
          isActive: true,
          isCompleted: false,
          statusLabel: 'Идэвхтэй',
        ),
        _MilestoneRow(
          months: 9,
          reward: 'VIP эрх',
          icon: Icons.lock_outline_rounded,
          iconColor: DesignTokens.muted,
          isActive: false,
          isCompleted: false,
        ),
        _MilestoneRow(
          months: 12,
          reward: '10,000₮ Купон',
          icon: Icons.lock_outline_rounded,
          iconColor: DesignTokens.muted,
          isActive: false,
          isCompleted: false,
        ),
      ],
    );
  }
}

class _MilestoneRow extends StatelessWidget {
  const _MilestoneRow({
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
            color: isActive
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
            Icon(icon, size: responsive.dp(22), color: iconColor),
            SizedBox(width: responsive.dp(12)),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  CustomText(
                    '$months Сар',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: MiniAppTypography.semiBold,
                    ),
                  ),
                  SizedBox(height: responsive.dp(2)),
                  CustomText(
                    reward,
                    variant: MiniAppTextVariant.caption,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: DesignTokens.muted,
                    ),
                  ),
                ],
              ),
            ),
            if (statusLabel != null)
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
                  statusLabel!,
                  variant: MiniAppTextVariant.caption,
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: DesignTokens.rose,
                    fontWeight: MiniAppTypography.semiBold,
                    fontSize: responsive.dp(11),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
