import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:apex_mini_app_sdk/apex_mini_app_sdk.dart';

part 'widgets/reward_cards.dart';
part 'widgets/reward_milestones.dart';

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
