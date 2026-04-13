import 'package:flutter/material.dart';
import '../../../../../app/investx_api/dto/user_entity_dto.dart';
import 'package:mini_app_ui/mini_app_ui.dart';

import '../../../../../shared/l10n/sdk_localizations_x.dart';
import '../../../shared/domain/models/ips_models.dart';
import '../../../shared/presentation/widgets/widgets.dart';
import '../models/overview_dashboard_metrics.dart';
import 'overview_dashboard_cards.dart';

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
        InvestXAllocationSummaryCard(
          variant: InvestXAllocationSummaryCardVariant.dashboard,
          data: _buildAllocationSummaryData(context, metrics),
          detailsLabel: context.l10n.ipsOverviewDashboardDetails,
          onViewDetails: onViewDetails,
        ),
        SizedBox(height: responsive.dp(14)),

        /// Dashboard reminder card
        InvestXReminderCard(
          title: context.l10n.ipsOverviewDashboardReminderTitle,
          message: context.l10n.ipsOverviewDashboardReminderBody,
        ),
        SizedBox(height: responsive.dp(14)),

        /// Dashboard goal card
        OverviewDashboardGoalCard(metrics: metrics),
        SizedBox(height: responsive.dp(14)),

        /// Dashboard reward card
        OverviewDashboardRewardCard(streakMonths: metrics.streakMonths),
        SizedBox(height: responsive.dp(50)),
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
      child: InvestXSkeletonLoader(),
    );
  }
}

InvestXAllocationSummaryData _buildAllocationSummaryData(BuildContext context, OverviewDashboardMetrics metrics) {
  final l10n = context.l10n;

  return InvestXAllocationSummaryData(
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
    yieldBadges: <InvestXAllocationBadgeData>[
      InvestXAllocationBadgeData(
        label: metrics.profitLabel,
        tone: metrics.profitTone,
      ),
      InvestXAllocationBadgeData(
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
          color: InvestXDesignTokens.border,
          height: 1,
          thickness: 1,
        ),
        SizedBox(height: responsive.dp(20)),
        InvestXPrimaryButton(
          label: l10n.ipsOverviewDashboardActionRecharge,
          onPressed: onRecharge,
          icon: Icons.add_rounded,
          height: responsive.dp(50),
          borderRadius: BorderRadius.circular(responsive.radius(14)),
        ),
        SizedBox(height: responsive.dp(12)),
        InvestXSecondaryButton(
          label: l10n.ipsOverviewDashboardActionSell,
          onPressed: onClosePack ?? () {},
          height: responsive.dp(50),
          borderRadius: BorderRadius.circular(responsive.radius(14)),
          foregroundColor: InvestXDesignTokens.rose,
          boxShadow: InvestXDesignTokens.cardShadow,
        ),
      ],
    );
  }
}
