import 'package:flutter/material.dart';
import 'package:apex_mini_app_sdk/apex_mini_app_sdk.dart';

/// Main dashboard tab shown after the user has an InvestX account context.
class OverviewDashboardHomeTab extends StatelessWidget {
  /// Account/bootstrap state for the dashboard.
  final AcntBootstrapState bootstrapState;

  /// Portfolio overview values.
  final PortfolioOverview? portfolioOverview;

  /// Whether `getIpsBalance` loaded successfully with a non-zero balance.
  final bool hasValidIpsBalance;

  /// Holdings used to derive yield/profit metrics.
  final List<PortfolioHolding> yieldProfitHoldings;

  /// Stock yield holdings used to derive current value.
  final List<PortfolioHolding> stockYieldDetails;

  /// Current user for greeting display.
  final UserEntityDto? user;

  /// Recharge quick action.
  final VoidCallback? onRecharge;

  /// Statements quick action.
  final VoidCallback? onStatements;

  /// Withdraw quick action.
  final VoidCallback? onWithdraw;

  /// Opens portfolio detail.
  final VoidCallback? onViewDetails;

  /// Pull-to-refresh callback.
  final RefreshCallback? onRefresh;

  /// Pending order (status "N") to show in the dashboard, if any.
  final IpsOrder? pendingOrder;

  /// Creates the overview dashboard tab.
  const OverviewDashboardHomeTab({
    super.key,
    required this.bootstrapState,
    required this.user,
    this.hasValidIpsBalance = false,
    this.portfolioOverview,
    this.yieldProfitHoldings = const <PortfolioHolding>[],
    this.stockYieldDetails = const <PortfolioHolding>[],
    this.onRecharge,
    this.onStatements,
    this.onWithdraw,
    this.onViewDetails,
    this.onRefresh,
    this.pendingOrder,
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
    final bool showFinancialData = hasValidIpsBalance;

    final Widget scrollView = Stack(
      clipBehavior: Clip.none,
      children: <Widget>[
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            /// Dashboard summary card
            OverviewDashboardSummaryCard(
              metrics: metrics,
              showFinancialSummary: showFinancialData,
              onRecharge: onRecharge,
              onStatements: onStatements,
              onWithdraw: onWithdraw,
            ),
            if (pendingOrder != null) ...<Widget>[
              SizedBox(height: responsive.dp(14)),
              OverviewPendingOrderCard(
                order: pendingOrder!,
                packAmount: portfolioOverview?.packAmount,
                packFee: portfolioOverview?.packFee,
                currency: portfolioOverview?.currency ?? '',
              ),
            ],
            SizedBox(height: responsive.dp(14)),
            if (showFinancialData) ...<Widget>[
              /// Dashboard asset breakdown card
              AllocationSummaryCard(
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
            ],
          if (metrics.streakMonths > 0 || metrics.activeLoyalty != null) ...<Widget>[
            SizedBox(height: responsive.dp(16)),
            OverviewDashboardRewardCard(
              streakMonths: metrics.streakMonths,
              activeLoyalty: metrics.activeLoyalty,
            ),
          ],
            SizedBox(height: responsive.dp(100)),
          ],
        ),
      ],
    );

    return MiniAppRefreshContainer(
      onRefresh: onRefresh,
      padding: EdgeInsets.all(AppSpacing.xl),
      child: scrollView,
    );
  }
}

/// Loading skeleton for the dashboard tab.
class OverviewDashboardHomeShimmer extends StatelessWidget {
  /// Pull-to-refresh callback while loading.
  final RefreshCallback? onRefresh;

  /// Creates the dashboard loading shimmer.
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

/// Converts overview metrics into allocation-card data.
AllocationSummaryData _buildAllocationSummaryData(
  BuildContext context,
  OverviewDashboardMetrics metrics,
) {
  final l10n = context.l10n;

  return AllocationSummaryData(
    stockValue: metrics.stockTotal,
    bondValue: metrics.bondTotal,
    cashValue: metrics.cashTotal,
    barFallbackTotal: metrics.totalInvestment,
    stockLabel: l10n.ipsOverviewDashboardAllocationStocks,
    stockValueLabel: metrics.stockTotalLabel,
    bondLabel: l10n.ipsOverviewDashboardAllocationBonds,
    bondValueLabel: metrics.bondTotalLabel,
    cashLabel: l10n.ipsOverviewDashboardAllocationCash,
    cashValueLabel: metrics.cashTotalLabel,
    totalLabel: l10n.ipsOverviewDashboardAllocationTotal,
    totalValueLabel: metrics.allocationTotalLabel,
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

/// Bottom sheet content for dashboard quick actions.
class OverviewDashboardActionSheetContent extends StatelessWidget {
  /// Recharge action.
  final VoidCallback? onRecharge;

  /// Sell-pack action.
  final VoidCallback? onSellPack;

  /// Creates dashboard action sheet content.
  const OverviewDashboardActionSheetContent({
    super.key,
    this.onRecharge,
    this.onSellPack,
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
          onPressed: onSellPack ?? () {},
          height: responsive.dp(50),
          borderRadius: BorderRadius.circular(responsive.radius(14)),
          foregroundColor: DesignTokens.rose,
          boxShadow: DesignTokens.cardShadow,
        ),
      ],
    );
  }
}
