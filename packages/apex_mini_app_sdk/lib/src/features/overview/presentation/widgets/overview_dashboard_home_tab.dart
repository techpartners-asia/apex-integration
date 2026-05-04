import 'package:flutter/material.dart';
import 'package:mini_app_ui/mini_app_ui.dart';
import 'package:mini_app_sdk/mini_app_sdk.dart';

class OverviewDashboardHomeTab extends StatelessWidget {
  final AcntBootstrapState bootstrapState;
  final PortfolioOverview? portfolioOverview;
  final List<PortfolioHolding> yieldProfitHoldings;
  final List<PortfolioHolding> stockYieldDetails;
  final UserEntityDto? user;
  final VoidCallback? onRecharge;
  final VoidCallback? onStatements;
  final VoidCallback? onWithdraw;
  final VoidCallback? onViewDetails;
  final RefreshCallback? onRefresh;

  const OverviewDashboardHomeTab({
    super.key,
    required this.bootstrapState,
    required this.user,
    this.portfolioOverview,
    this.yieldProfitHoldings = const <PortfolioHolding>[],
    this.stockYieldDetails = const <PortfolioHolding>[],
    this.onRecharge,
    this.onStatements,
    this.onWithdraw,
    this.onViewDetails,
    this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    final responsive = context.responsive;
    final OverviewDashboardMetrics metrics = OverviewDashboardMetrics.resolve(
      context,
      bootstrapState: bootstrapState,
      overview: portfolioOverview,
      yieldProfitHoldings: yieldProfitHoldings,
      stockYieldDetails: stockYieldDetails,
      user: user,
    );

    final Widget scrollView = Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        /// Dashboard summary card
        OverviewDashboardSummaryCard(
          metrics: metrics,
          onRecharge: onRecharge,
          onStatements: onStatements,
          onWithdraw: onWithdraw,
        ),
        SizedBox(height: responsive.dp(14)),

        /// Dashboard yield card
        AllocationSummaryCard(
          variant: AllocationSummaryCardVariant.dashboard,
          data: _buildAllocationSummaryData(context, metrics),
          detailsLabel: context.l10n.ipsOverviewDashboardDetails,
          onViewDetails: onViewDetails,
        ),
        SizedBox(height: responsive.dp(14)),

        /// Dashboard reminder card
        ReminderCard(
          title: context.l10n.ipsOverviewDashboardReminderTitle,
          message: context.l10n.ipsOverviewDashboardReminderBody,
        ),
        SizedBox(height: responsive.dp(14)),

        /// Dashboard goal card
        OverviewDashboardGoalCard(metrics: metrics),
        SizedBox(height: responsive.dp(14)),

        /// Dashboard reward card
        OverviewDashboardRewardCard(streakMonths: metrics.streakMonths),
        SizedBox(height: responsive.dp(100)),
      ],
    );

    return MiniAppRefreshContainer(
      onRefresh: onRefresh,
      padding: EdgeInsets.all(AppSpacing.xl),
      child: scrollView,
    );
  }
}

class OverviewDashboardHomeShimmer extends StatelessWidget {
  final RefreshCallback? onRefresh;

  const OverviewDashboardHomeShimmer({
    super.key,
    this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    return MiniAppRefreshContainer(
      onRefresh: onRefresh,
      padding: EdgeInsets.only(top: 8),
      child: SkeletonLoader(),
    );
  }
}

AllocationSummaryData _buildAllocationSummaryData(
  BuildContext context,
  OverviewDashboardMetrics metrics,
) {
  final l10n = context.l10n;

  return AllocationSummaryData(
    stockValue: metrics.stockTotal,
    bondValue: metrics.bondTotal,
    barFallbackTotal: metrics.totalInvestment,
    stockLabel: l10n.ipsOverviewDashboardAllocationStocks,
    stockValueLabel: metrics.stockTotalLabel,
    bondLabel: l10n.ipsOverviewDashboardAllocationBonds,
    bondValueLabel: metrics.bondTotalLabel,
    totalLabel: l10n.ipsOverviewDashboardAllocationTotal,
    totalValueLabel: metrics.totalInvestmentLabel,
    yieldSectionLabel: l10n.ipsOverviewDashboardYieldLabel,
    yieldBadges: <AllocationBadgeData>[
      AllocationBadgeData(
        label: metrics.profitLabel,
        tone: metrics.profitTone,
      ),
      AllocationBadgeData(
        label: metrics.profitPercentLabel,
        tone: metrics.profitTone,
      ),
    ],
  );
}

class OverviewDashboardActionSheetContent extends StatelessWidget {
  final VoidCallback? onRecharge;
  final VoidCallback? onClosePack;

  const OverviewDashboardActionSheetContent({
    super.key,
    this.onRecharge,
    this.onClosePack,
  });

  @override
  Widget build(BuildContext context) {
    final responsive = context.responsive;
    final l10n = context.l10n;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Divider(
          color: DesignTokens.border,
          height: 1,
          thickness: 1,
        ),
        SizedBox(height: responsive.dp(20)),
        PrimaryButton(
          label: l10n.ipsOverviewDashboardActionRecharge,
          onPressed: onRecharge,
          icon: Icons.add_rounded,
          height: responsive.dp(50),
          borderRadius: BorderRadius.circular(responsive.radius(14)),
        ),
        SizedBox(height: responsive.dp(12)),
        SecondaryButton(
          label: l10n.ipsOverviewDashboardActionSell,
          onPressed: onClosePack ?? () {},
          height: responsive.dp(50),
          borderRadius: BorderRadius.circular(responsive.radius(14)),
          foregroundColor: DesignTokens.rose,
          boxShadow: DesignTokens.cardShadow,
        ),
      ],
    );
  }
}
