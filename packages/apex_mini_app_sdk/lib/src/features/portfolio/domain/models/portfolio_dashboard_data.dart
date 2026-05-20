import 'package:apex_mini_app_sdk/apex_mini_app_sdk.dart';

/// Aggregated data needed to render the portfolio dashboard.
class PortfolioDashboardData {
  /// Portfolio balance and allocation overview.
  final PortfolioOverview overview;

  /// Holdings returned from the account yield/profit endpoint.
  final List<PortfolioHolding> yieldProfitHoldings;

  /// Holdings returned from the stock account yield detail endpoint.
  final List<PortfolioHolding> stockYieldDetails;

  /// Resolved account/context values used by downstream portfolio APIs.
  final SdkPortfolioContext portfolioContext;

  /// Creates portfolio dashboard aggregate data.
  const PortfolioDashboardData({
    required this.overview,
    this.yieldProfitHoldings = const <PortfolioHolding>[],
    this.stockYieldDetails = const <PortfolioHolding>[],
    this.portfolioContext = const SdkPortfolioContext(),
  });
}
