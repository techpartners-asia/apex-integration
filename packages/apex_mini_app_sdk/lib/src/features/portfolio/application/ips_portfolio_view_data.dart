import 'package:apex_mini_app_sdk/apex_mini_app_sdk_internal.dart';

class IpsPortfolioViewData {
  final PortfolioOverview overview;
  final List<PortfolioHolding> holdings;
  final List<PortfolioHolding> yieldProfitHoldings;
  final List<PortfolioHolding> stockYieldDetails;
  final SdkPortfolioContext portfolioContext;

  const IpsPortfolioViewData({
    required this.overview,
    required this.holdings,
    this.yieldProfitHoldings = const <PortfolioHolding>[],
    this.stockYieldDetails = const <PortfolioHolding>[],
    this.portfolioContext = const SdkPortfolioContext(),
  });
}
