import 'package:mini_app_sdk/mini_app_sdk.dart';

class PortfolioService {
  const PortfolioService();

  Future<PortfolioOverview> getIpsBalance({SdkPortfolioContext? context}) {
    throw UnimplementedError();
  }

  Future<PortfolioOverview> getOverview({SdkPortfolioContext? context}) {
    throw UnimplementedError();
  }

  Future<PortfolioDashboardData> getDashboardData({
    SdkPortfolioContext? context,
  }) {
    throw UnimplementedError();
  }

  Future<PortfolioStatementsData> getStatements({
    SdkPortfolioContext? context,
  }) {
    throw UnimplementedError();
  }

  Future<List<PortfolioHolding>> getHoldings({SdkPortfolioContext? context}) {
    throw UnimplementedError();
  }
}
