import 'contract_service.dart';
import 'investment_bootstrap_service.dart';
import 'orders_service.dart';
import 'pack_service.dart';
import 'portfolio_service.dart';
import 'questionnaire_service.dart';

class InvestmentServices {
  final InvestmentBootstrapService? bootstrapService;
  final QuestionnaireService? questionnaireService;
  final PackService? packService;
  final ContractService? contractService;
  final PortfolioService? portfolioService;
  final OrdersService? ordersService;

  const InvestmentServices({
    this.bootstrapService,
    this.questionnaireService,
    this.packService,
    this.contractService,
    this.portfolioService,
    this.ordersService,
  });
}
