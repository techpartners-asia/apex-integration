import 'package:mini_app_sdk/mini_app_sdk.dart';

class PortfolioDashboardData {
  final PortfolioOverview overview;
  final List<PortfolioHolding> yieldProfitHoldings;
  final List<PortfolioHolding> stockYieldDetails;
  final SdkPortfolioContext portfolioContext;

  const PortfolioDashboardData({
    required this.overview,
    this.yieldProfitHoldings = const <PortfolioHolding>[],
    this.stockYieldDetails = const <PortfolioHolding>[],
    this.portfolioContext = const SdkPortfolioContext(),
  });
}
