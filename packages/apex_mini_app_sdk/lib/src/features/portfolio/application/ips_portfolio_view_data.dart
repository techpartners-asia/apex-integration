import 'package:apex_mini_app_sdk/apex_mini_app_sdk.dart';

/// View data used by the portfolio screen.
class IpsPortfolioViewData {
  /// Portfolio overview/balance totals.
  final PortfolioOverview overview;

  /// Combined holdings displayed in portfolio sections.
  final List<PortfolioHolding> holdings;

  /// Holdings returned by yield-profit endpoint.
  final List<PortfolioHolding> yieldProfitHoldings;

  /// Holdings returned by stock-yield-detail endpoint.
  final List<PortfolioHolding> stockYieldDetails;

  /// Context used to request statements/detail data.
  final SdkPortfolioContext portfolioContext;

  /// Creates portfolio view data.
  const IpsPortfolioViewData({
    required this.overview,
    required this.holdings,
    this.yieldProfitHoldings = const <PortfolioHolding>[],
    this.stockYieldDetails = const <PortfolioHolding>[],
    this.portfolioContext = const SdkPortfolioContext(),
  });
}
