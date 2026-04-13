import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mini_app_sdk/l10n/sdk_localizations.dart';
import 'package:mini_app_ui/mini_app_ui.dart';

import '../../../../../core/backend/sdk_portfolio_context.dart';
import '../../../../../shared/l10n/sdk_localizations_x.dart';
import '../../application/ips_portfolio_cubit.dart';
import '../../application/ips_portfolio_view_data.dart';
import '../models/portfolio_yield_chart_data.dart';
import '../widgets/portfolio_holdings_widgets.dart';
import '../widgets/portfolio_quick_actions_section.dart';
import '../widgets/portfolio_yield_widgets.dart';
import '../../../shared/application/loadable_state.dart';
import '../../../shared/domain/models/ips_models.dart';
import '../../../shared/presentation/helpers/ips_formatters.dart';
import '../../../shared/presentation/widgets/widgets.dart';

class PortfolioScreen extends StatelessWidget {
  const PortfolioScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<IpsPortfolioCubit, LoadableState<IpsPortfolioViewData>>(
      builder: (BuildContext context, LoadableState<IpsPortfolioViewData> state) {
        final SdkLocalizations l10n = context.l10n;

        if (state.isInitial || state.isLoading) {
          return InvestXPageScaffold(
            appBarTitle: l10n.ipsOverviewProfileMenuPackInfo,
            showCloseButton: false,
            body: const InvestXSkeletonLoader(),
          );
        }

        if (state.isFailure) {
          return InvestXPageScaffold(
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
          return InvestXPageScaffold(
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

        return InvestXPageScaffold(
          appBarTitle: l10n.ipsOverviewProfileMenuPackInfo,
          showCloseButton: false,
          body: RefreshIndicator(
            onRefresh: context.read<IpsPortfolioCubit>().load,
            color: InvestXDesignTokens.rose,
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: EdgeInsets.symmetric(
                horizontal: context.responsive.spacing.financialCardSpacing,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  SizedBox(height: context.responsive.spacing.sectionSpacing),

                  /// Allocation
                  InvestXAllocationSummaryCard(data: _buildAllocationSummaryData(overview, l10n)),
                  SizedBox(height: context.responsive.spacing.cardGap),

                  /// Reminder
                  InvestXReminderCard(title: l10n.ipsOverviewDashboardReminderTitle, message: l10n.ipsOverviewDashboardReminderBody),

                  /// Profit section
                  PortfolioYieldSection(overview: overview, chartData: chartData, l10n: l10n),

                  /// My portfolio
                  PortfolioMyPackSection(overview: overview, l10n: l10n),
                  SizedBox(height: context.responsive.spacing.sectionSpacing),

                  /// Quick actions
                  PortfolioQuickActionsSection(portfolioContext: data?.portfolioContext ?? const SdkPortfolioContext(), l10n: l10n),
                  SizedBox(height: context.responsive.spacing.sectionSpacing * 2),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

InvestXAllocationSummaryData _buildAllocationSummaryData(
  PortfolioOverview overview,
  SdkLocalizations l10n,
) {
  final double stockValue = overview.stockTotal ?? 0;
  final double bondValue = overview.bondTotal ?? 0;
  final List<InvestXAllocationBadgeData> yieldBadges = <InvestXAllocationBadgeData>[
    InvestXAllocationBadgeData(
      label: '${(overview.profitOrLoss ?? 0.0) >= 0 ? '+' : ''}${formatIpsPaymentAmount((overview.profitOrLoss ?? 0.0), overview.currency)}',
      tone: (overview.profitOrLoss ?? 0.0) >= 0 ? InvestXDesignTokens.success : InvestXDesignTokens.danger,
    ),
    InvestXAllocationBadgeData(
      label: '+${(overview.yieldAmount ?? 0.0).toStringAsFixed(0)}%',
      tone: InvestXDesignTokens.success,
    ),
  ];

  return InvestXAllocationSummaryData(
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
