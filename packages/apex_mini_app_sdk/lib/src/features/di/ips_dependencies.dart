import 'package:mini_app_ui/mini_app_ui.dart';
import 'package:mini_app_sdk/mini_app_sdk.dart';

class IpsDependencies {
  final InvestmentBootstrapService? bootstrapService;
  final QuestionnaireService? questionnaireService;
  final PackService? packService;
  final ContractService? contractService;
  final PortfolioService? portfolioService;
  final OrdersService? ordersService;
  final MiniAppPaymentExecutor paymentExecutor;
  final MiniAppSessionStore sessionStore;
  final MiniAppSessionController sessionController;
  final MiniAppApiRepository appApi;
  final SecAcntBankOptionsRepository bankOptionsRepository;
  final SecAcntBankAccountLookupRepository bankAccountLookupRepository;
  final MiniAppBootstrapFlow? bootstrapFlow;
  final MiniAppLogger logger;

  IpsDependencies({
    this.bootstrapService,
    this.questionnaireService,
    this.packService,
    this.contractService,
    this.portfolioService,
    this.ordersService,
    required this.paymentExecutor,
    required this.sessionStore,
    required this.sessionController,
    required this.appApi,
    required this.bankOptionsRepository,
    required this.bankAccountLookupRepository,
    this.bootstrapFlow,
    this.logger = const SilentMiniAppLogger(),
  });

  void prepareLaunch(MiniAppLaunchContext context) {
    sessionController.prepareLaunch(userToken: context.userToken);
  }
}
