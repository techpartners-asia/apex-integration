import 'package:mini_app_sdk/mini_app_sdk.dart';

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
