import 'package:mini_app_sdk/mini_app_sdk.dart';

class IpsStatementsViewData {
  final PortfolioStatementsData statements;
  final SdkPortfolioContext portfolioContext;

  const IpsStatementsViewData({
    required this.statements,
    this.portfolioContext = const SdkPortfolioContext(),
  });
}
