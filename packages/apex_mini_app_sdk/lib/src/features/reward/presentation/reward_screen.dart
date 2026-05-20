import 'package:flutter/material.dart';
import 'package:apex_mini_app_sdk/apex_mini_app_sdk.dart';

part 'widgets/reward_cards.dart';
part 'widgets/reward_milestones.dart';

/// Static reward/progress screen for the mini-app reward tab.
class RewardScreen extends StatelessWidget {
  /// Creates the reward screen.
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
