import 'package:mini_app_sdk/mini_app_sdk.dart';

abstract interface class PortfolioService {
  Future<PortfolioOverview> getIpsBalance({SdkPortfolioContext? context});

  Future<PortfolioOverview> getOverview({SdkPortfolioContext? context});

  Future<PortfolioDashboardData> getDashboardData({
    SdkPortfolioContext? context,
  });

  Future<PortfolioStatementsData> getStatements({SdkPortfolioContext? context});

  Future<List<PortfolioHolding>> getHoldings({SdkPortfolioContext? context});
}
