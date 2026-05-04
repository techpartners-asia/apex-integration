import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mini_app_ui/mini_app_ui.dart';
import 'package:mini_app_sdk/mini_app_sdk.dart';

class PortfolioScreen extends StatelessWidget {
  const PortfolioScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<IpsPortfolioCubit, LoadableState<IpsPortfolioViewData>>(
      builder: (BuildContext context, LoadableState<IpsPortfolioViewData> state) {
        final SdkLocalizations l10n = context.l10n;

        if (state.isInitial || state.isLoading) {
          return CustomScaffold(
            appBarTitle: l10n.ipsOverviewProfileMenuPackInfo,
            showCloseButton: false,
            body: const SkeletonLoader(),
          );
        }

        if (state.isFailure) {
          return CustomScaffold(
            appBarTitle: l10n.ipsOverviewProfileMenuPackInfo,
            showCloseButton: false,
            children: <Widget>[
              MiniAppErrorState(
                title: l10n.errorsGenericTitle,
                message: state.errorMessage ?? l10n.errorsActionFailed,
                retryLabel: l10n.commonRetry,
                onRetry: context.read<IpsPortfolioCubit>().load,
              ),
            ],
          );
        }

        final IpsPortfolioViewData? data = state.data;
        final PortfolioOverview? overview = data?.overview;
        final List<PortfolioHolding> yieldProfitHoldings = data?.yieldProfitHoldings ?? const <PortfolioHolding>[];
        final List<PortfolioHolding> stockYieldDetails = data?.stockYieldDetails ?? const <PortfolioHolding>[];

        if (overview == null) {
          return CustomScaffold(
            appBarTitle: l10n.ipsOverviewProfileMenuPackInfo,
            showCloseButton: false,
            children: <Widget>[
              MiniAppEmptyState(
                title: l10n.ipsPortfolioTitle,
                message: l10n.ipsPortfolioNoHoldings,
              ),
            ],
          );
        }

        final PortfolioYieldChartData chartData = PortfolioYieldChartDataMapper.fromResponses(
          yieldProfitHoldings: yieldProfitHoldings,
          stockYieldDetails: stockYieldDetails,
        );

        return CustomScaffold(
          appBarTitle: l10n.ipsOverviewProfileMenuPackInfo,
          showCloseButton: false,
          body: RefreshIndicator(
            onRefresh: context.read<IpsPortfolioCubit>().load,
            color: DesignTokens.rose,
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: EdgeInsets.symmetric(
                horizontal: context.responsive.spacing.financialCardSpacing,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  SizedBox(
                    height: context.responsive.spacing.sectionSpacing,
                  ),

                  /// Allocation
                  AllocationSummaryCard(
                    variant: AllocationSummaryCardVariant.dashboard,
                    data: _buildAllocationSummaryData(overview, l10n),
                  ),
                  SizedBox(height: context.responsive.spacing.cardGap),

                  /// Reminder
                  ReminderCard(
                    title: l10n.ipsOverviewDashboardReminderTitle,
                    message: l10n.ipsOverviewDashboardReminderBody,
                  ),

                  /// Profit section
                  PortfolioYieldSection(
                    overview: overview,
                    chartData: chartData,
                    l10n: l10n,
                  ),

                  /// My portfolio
                  PortfolioMyPackSection(overview: overview, l10n: l10n),
                  SizedBox(height: context.responsive.spacing.sectionSpacing),

                  /// Quick actions
                  // PortfolioQuickActionsSection(
                  //   portfolioContext: data?.portfolioContext ?? const SdkPortfolioContext(),
                  //   l10n: l10n,
                  // ),
                  SizedBox(
                    height: context.responsive.spacing.sectionSpacing * 2,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

AllocationSummaryData _buildAllocationSummaryData(PortfolioOverview overview, SdkLocalizations l10n) {
  final double stockValue = overview.stockTotal ?? 0;
  final double bondValue = overview.bondTotal ?? 0;
  final List<AllocationBadgeData> yieldBadges = <AllocationBadgeData>[
    AllocationBadgeData(
      label: '${(overview.profitOrLoss ?? 0.0) >= 0 ? '+' : ''}${formatIpsPaymentAmount((overview.profitOrLoss ?? 0.0), overview.currency)}',
      tone: (overview.profitOrLoss ?? 0.0) >= 0 ? DesignTokens.success : DesignTokens.danger,
    ),
    AllocationBadgeData(
      label: '+${(overview.profitPercent ?? 0.0).toStringAsFixed(0)}%',
      tone: DesignTokens.success,
    ),
  ];

  return AllocationSummaryData(
    stockValue: stockValue,
    bondValue: bondValue,
    barFallbackTotal: stockValue + bondValue,
    stockLabel: l10n.ipsOverviewDashboardAllocationStocks,
    stockValueLabel: formatIpsPaymentAmount(stockValue, overview.currency),
    bondLabel: l10n.ipsOverviewDashboardAllocationBonds,
    bondValueLabel: formatIpsPaymentAmount(bondValue, overview.currency),
    totalLabel: l10n.ipsOverviewDashboardAllocationTotal,
    totalValueLabel: formatIpsPaymentAmount(
      stockValue + bondValue,
      overview.currency,
    ),
    yieldSectionLabel: l10n.ipsOverviewDashboardYieldLabel,
    yieldBadges: yieldBadges,
  );
}
