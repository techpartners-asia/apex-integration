import 'package:apex_mini_app_sdk/apex_mini_app_sdk.dart';

/// Portfolio data service contract.
abstract interface class PortfolioService {
  /// Loads IPS balance information.
  Future<PortfolioOverview> getIpsBalance({SdkPortfolioContext? context});

  /// Loads portfolio overview information.
  Future<PortfolioOverview> getOverview({SdkPortfolioContext? context});

  /// Loads all dashboard data needed by overview/portfolio screens.
  Future<PortfolioDashboardData> getDashboardData({
    SdkPortfolioContext? context,
  });

  /// Loads statement data.
  Future<PortfolioStatementsData> getStatements({SdkPortfolioContext? context});

  /// Loads holdings data.
  Future<List<PortfolioHolding>> getHoldings({SdkPortfolioContext? context});
}
