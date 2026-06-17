import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:apex_mini_app_sdk/apex_mini_app_sdk.dart';

part 'widgets/reward_cards.dart';
part 'widgets/reward_milestones.dart';

/// Returns the first inactive milestone that comes after the active one.
/// Falls back to the first inactive item when none are active.
LoyaltyItemDto? _nextMilestone(List<LoyaltyItemDto> items) {
  final int activeIdx = items.indexWhere((LoyaltyItemDto i) => i.status == LoyaltyStatus.active);
  if (activeIdx != -1) {
    for (int i = activeIdx + 1; i < items.length; i++) {
      if (items[i].status == LoyaltyStatus.inactive) return items[i];
    }
    return null;
  }
  try {
    return items.firstWhere((LoyaltyItemDto i) => i.status == LoyaltyStatus.inactive);
  } catch (_) {
    return null;
  }
}

/// Reward/achievement screen showing loyalty milestones.
class RewardScreen extends StatelessWidget {
  /// Creates the reward screen.
  const RewardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final responsive = context.responsive;
    final l10n = context.l10n;

    return BlocBuilder<LoyaltyCubit, LoadableState<List<LoyaltyItemDto>>>(
      builder: (BuildContext context, LoadableState<List<LoyaltyItemDto>> state) {
        final List<LoyaltyItemDto> items = state.data ?? const <LoyaltyItemDto>[];
        final LoyaltyItemDto? nextMilestone = _nextMilestone(items);

        return CustomScaffold(
          appBarTitle: l10n.ipsRewardTitle,
          showCloseButton: false,
          body: state.isLoading
              ? const Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                  padding: EdgeInsets.symmetric(
                    horizontal: responsive.spacing.financialCardSpacing,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      SizedBox(height: responsive.spacing.sectionSpacing),
                      BlocBuilder<IpsOverviewCubit, LoadableState<IpsOverviewViewData>>(
                        builder: (BuildContext context, LoadableState<IpsOverviewViewData> overviewState) {
                          final IpsOverviewViewData? viewData = overviewState.data;
                          if (viewData == null) return const SizedBox.shrink();
                          final OverviewDashboardMetrics metrics = OverviewDashboardMetrics.resolve(
                            context,
                            bootstrapState: viewData.bootstrapState,
                            overview: viewData.portfolioOverview,
                            yieldProfitHoldings: viewData.yieldProfitHoldings,
                            stockYieldDetails: viewData.stockYieldDetails,
                            user: context.read<MiniAppSessionStore>().currentUser,
                          );
                          return OverviewDashboardGoalCard(metrics: metrics);
                        },
                      ),
                      SizedBox(height: responsive.spacing.cardGap),
                      _StreakCard(
                        l10n: l10n,
                        streakCount: int.tryParse(
                          context.read<MiniAppSessionStore>().currentUser?.account?.streak ?? '',
                        ) ?? 0,
                        nextReward: nextMilestone != null
                            ? _formatBonus(nextMilestone.bonus, nextMilestone.bonusType, l10n)
                            : null,
                      ),
                      SizedBox(height: responsive.spacing.cardGap),
                      _NextGoalCard(
                        l10n: l10n,
                        goal: context.read<MiniAppSessionStore>().currentUser?.account?.goal,
                      ),
                      SizedBox(height: responsive.spacing.sectionSpacing),
                      _MilestonesList(l10n: l10n, items: items),
                      SizedBox(height: responsive.spacing.sectionSpacing * 2),
                    ],
                  ),
                ),
        );
      },
    );
  }
}
