part of '../reward_screen.dart';

/// Reward streak progress card.
class _StreakCard extends StatelessWidget {
  /// Creates the streak card.
  const _StreakCard({
    required this.l10n,
    required this.streakCount,
    this.nextReward,
  });

  /// Localized streak labels.
  final SdkLocalizations l10n;

  /// Current streak month count from user account.
  final int streakCount;

  /// Formatted bonus label for the next milestone (e.g. "+2%", "10000₮ Купон").
  final String? nextReward;

  static const int _totalMonths = 12;

  @override
  Widget build(BuildContext context) {
    final responsive = context.responsive;

    return Container(
      decoration: BoxDecoration(
        color: Color(0xFFF2EAEA),
        border: Border.all(color: DesignTokens.coral),
        borderRadius: BorderRadius.circular(responsive.radius(20)),
        boxShadow: DesignTokens.cardShadow,
      ),
      padding: EdgeInsets.all(responsive.dp(18)),
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            CustomText(
              l10n.ipsRewardStreakTitle,
              variant: MiniAppTextVariant.title1,
              color: DesignTokens.ink,
            ),
            SizedBox(height: responsive.dp(26)),
            CustomText(
                  l10n.ipsRewardStreakMonths(streakCount, _totalMonths),
                  variant: MiniAppTextVariant.title1,
                  color: DesignTokens.ink,
                ),
            SizedBox(height: responsive.dp(8)),
            RewardProgressBar(
              months: streakCount,
              total: _totalMonths,
            ),
            SizedBox(height: responsive.dp(10)),
            Row(
              children: <Widget>[
                CustomText(
                  l10n.ipsRewardStreakNextRewardLabel,
                  variant: MiniAppTextVariant.body3,
                  color: const Color(0xFF4A5565),
                ),
                SizedBox(width: responsive.dp(4)),
                if (nextReward != null)
                  ShaderMask(
                    shaderCallback: (Rect bounds) => const LinearGradient(
                      colors: <Color>[Color(0xFFDD4F80), Color(0xFFFB9D6C)],
                    ).createShader(bounds),
                    blendMode: BlendMode.srcIn,
                    child: CustomText(
                      nextReward!,
                      variant: MiniAppTextVariant.body3,
                      color: Colors.white,
                    ),
                  ),
              ],
            ),
          ],
        ),
    );
  }
}

/// Card that explains the next reward goal.
class _NextGoalCard extends StatelessWidget {
  /// Creates the next-goal card.
  const _NextGoalCard({required this.l10n, this.goal});

  /// Localized next-goal labels.
  final SdkLocalizations l10n;

  /// Next goal description from the user account.
  final String? goal;

  @override
  Widget build(BuildContext context) {
    final responsive = context.responsive;
    final String body = goal?.isNotEmpty == true ? goal! : l10n.ipsRewardNextGoalBody;

    return Container(
      decoration: BoxDecoration(
        gradient: DesignTokens.primaryGradient,
        borderRadius: BorderRadius.circular(responsive.radius(20)),
        border: Border.all(color: DesignTokens.white, width: 2),
      ),
      padding: EdgeInsets.all(responsive.dp(18)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            width: responsive.dp(40),
            height: responsive.dp(40),
            decoration: BoxDecoration(
              color: DesignTokens.white.withValues(alpha: 0.2),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Image.asset(
                Img.fireWhite,
                package: packageName,
                width: responsive.dp(18),
                height: responsive.dp(18),
                fit: BoxFit.contain,
              ),
            ),
          ),
          SizedBox(width: responsive.dp(16)),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                CustomText(
                  l10n.ipsRewardNextGoalTitle,
                  variant: MiniAppTextVariant.body1,
                  color: DesignTokens.white,
                ),
                SizedBox(height: responsive.dp(4)),
                CustomText(
                  body,
                  variant: MiniAppTextVariant.body3,
                  color: DesignTokens.white,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
