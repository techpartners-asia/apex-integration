import '../../../../core/backend/sdk_portfolio_context.dart';
import '../../shared/domain/models/ips_models.dart';

class IpsOverviewViewData {
  final AcntBootstrapState bootstrapState;
  final PortfolioOverview? portfolioOverview;
  final List<PortfolioHolding> yieldProfitHoldings;
  final List<PortfolioHolding> stockYieldDetails;
  final List<IpsPack> packs;
  final SdkPortfolioContext portfolioContext;
  final bool isDashboardDataReady;
  final bool dashboardLoadFailed;

  const IpsOverviewViewData({
    required this.bootstrapState,
    this.portfolioOverview,
    this.yieldProfitHoldings = const <PortfolioHolding>[],
    this.stockYieldDetails = const <PortfolioHolding>[],
    this.packs = const <IpsPack>[],
    this.portfolioContext = const SdkPortfolioContext(),
    this.isDashboardDataReady = true,
    this.dashboardLoadFailed = false,
  });
}
