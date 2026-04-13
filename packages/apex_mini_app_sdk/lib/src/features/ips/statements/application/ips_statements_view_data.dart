import '../../../../core/backend/sdk_portfolio_context.dart';
import '../../shared/domain/models/ips_models.dart';

class IpsStatementsViewData {
  final PortfolioStatementsData statements;
  final SdkPortfolioContext portfolioContext;

  const IpsStatementsViewData({
    required this.statements,
    this.portfolioContext = const SdkPortfolioContext(),
  });
}
