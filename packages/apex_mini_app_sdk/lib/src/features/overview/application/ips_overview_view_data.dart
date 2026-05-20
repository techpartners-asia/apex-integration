import 'package:apex_mini_app_sdk/apex_mini_app_sdk.dart';

/// View model consumed by the overview screen.
class IpsOverviewViewData {
  /// Account/bootstrap state for onboarding and dashboard decisions.
  final AcntBootstrapState bootstrapState;

  /// Portfolio overview summary, when available.
  final PortfolioOverview? portfolioOverview;

  /// Yield-profit holdings for dashboard cards.
  final List<PortfolioHolding> yieldProfitHoldings;

  /// Stock-yield details for dashboard cards.
  final List<PortfolioHolding> stockYieldDetails;

  /// Recommended investment packs.
  final List<IpsPack> packs;

  /// Portfolio context resolved from bootstrap account data.
  final SdkPortfolioContext portfolioContext;

  /// Whether dashboard data loading has completed.
  final bool isDashboardDataReady;

  /// Whether dashboard enrichment failed while base overview still loaded.
  final bool dashboardLoadFailed;

  /// Creates the overview view model.
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
