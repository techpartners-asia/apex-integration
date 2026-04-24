import 'package:mini_app_sdk/mini_app_sdk.dart';

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
