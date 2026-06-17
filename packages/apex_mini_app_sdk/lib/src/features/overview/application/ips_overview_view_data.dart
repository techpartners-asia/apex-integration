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

  /// Pending order with status "N", if one exists.
  final IpsOrder? pendingOrder;

  /// Whether the grape questionnaire check-completed API returned completed=true.
  final bool isQuestionnaireCompleted;

  /// Loyalty info (streak + active loyalty) from the loyalty-info endpoint.
  final LoyaltyInfoDto? loyaltyInfo;

  /// Whether the user has an active pending order.
  bool get hasPendingOrder => pendingOrder != null;

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
    this.pendingOrder,
    this.isQuestionnaireCompleted = false,
    this.loyaltyInfo,
  });

  /// Whether `getIpsBalance` completed and returned a non-zero investment
  /// balance. Dashboard investment breakdown widgets should render only when
  /// this is true.
  bool get hasValidIpsBalance =>
      isDashboardDataReady &&
      !dashboardLoadFailed &&
      _hasNonZeroInvestmentBalance(portfolioOverview);

  static bool _hasNonZeroInvestmentBalance(PortfolioOverview? overview) {
    if (overview == null) {
      return false;
    }

    final double stockBondTotal =
        (overview.stockTotal ?? 0) + (overview.bondTotal ?? 0);

    return _isPositive(overview.investedBalance) ||
        _isPositive(stockBondTotal) ||
        _isPositive(overview.packAmount);
  }

  static bool _isPositive(double? value) {
    return value != null && value.isFinite && value > 0;
  }
}
