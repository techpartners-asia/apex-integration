import 'package:apex_mini_app_sdk/apex_mini_app_sdk.dart';

/// Dependency bundle shared by all InvestX/IPS feature pages.
class IpsDependencies {
  /// Startup/bootstrap service. Null means startup dependencies are unavailable.
  final InvestmentBootstrapService? bootstrapService;

  /// Risk questionnaire service.
  final QuestionnaireService? questionnaireService;

  /// Investment pack service.
  final PackService? packService;

  /// Contract purchase/setup service.
  final ContractService? contractService;

  /// Portfolio service.
  final PortfolioService? portfolioService;

  /// Orders service.
  final OrdersService? ordersService;

  /// Host-payment coordinator.
  final MiniAppPaymentExecutor paymentExecutor;

  /// Session state store provided to pages through Bloc.
  final MiniAppSessionStore sessionStore;

  /// Session controller used by services to load/refresh user/session data.
  final MiniAppSessionController sessionController;

  /// General Apex mini-app API repository.
  final MiniAppApiRepository appApi;

  /// Securities account bank-options repository.
  final SecAcntBankOptionsRepository bankOptionsRepository;

  /// Securities account-name lookup repository.
  final SecAcntBankAccountLookupRepository bankAccountLookupRepository;

  /// Startup bootstrap flow orchestrator.
  final MiniAppBootstrapFlow? bootstrapFlow;

  /// Logger used by feature-level diagnostics.
  final MiniAppLogger logger;

  /// Creates the feature dependency bundle.
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

  /// Prepares session state for a new launch context.
  void prepareLaunch(MiniAppLaunchContext context) {
    sessionController.prepareLaunch(userToken: context.userToken);
  }
}
