import 'package:apex_mini_app_sdk/apex_mini_app_sdk_internal.dart';

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
