import 'package:mini_app_ui/mini_app_ui.dart';
import 'package:mini_app_sdk/mini_app_sdk.dart';

UiMiniAppModule buildMiniAppFeature(MiniAppSdkConfig config) {
  final MiniAppLogger logger = config.logger;
  final MiniAppSessionRuntime appSession = buildMiniAppSessionRuntime(
    initialUserToken: config.userToken,
    logger: logger,
    userDataSourceMode: config.userDataSourceMode,
  );
  final MiniAppApiRepository appApi = appSession.appApi;
  final MiniAppPaymentExecutor paymentExecutor = MiniAppPaymentExecutor(
    appApi: appApi,
    walletPaymentHandler: config.walletPaymentHandler,
    paymentTimeout: config.paymentTimeout,
    logger: logger,
  );
  final protectedExecutor = appSession.protectedExecutor;
  final IpsBackendApi? ipsApi = protectedExecutor == null
      ? null
      : IpsBackendApi(
          backendConfig: appSession.backendConfig,
          protectedExecutor: protectedExecutor,
        );
  final FiBomInstRepository? fiBomInstRepository = ipsApi == null
      ? null
      : CachedFiBomInstRepository(
          loadFiBomInst: (req) => ipsApi.getFiBomInst(req),
          fiBomInst: appSession.backendConfig.runtime.defaultFiCode,
        );
  final InvestmentBootstrapService? bootstrapService =
      ipsApi == null || fiBomInstRepository == null
      ? null
      : ApiInvestmentBootstrapService(
          api: ipsApi,
          config: appSession.backendConfig,
          session: appSession.controller,
          fiBomInstRepository: fiBomInstRepository,
          userDataSourceMode: config.userDataSourceMode,
        );
  final QuestionnaireService? questionnaireService = ipsApi == null
      ? null
      : ApiQuestionnaireService(
          api: ipsApi,
          appApi: appApi,
          config: appSession.backendConfig,
          session: appSession.controller,
        );
  final PackService? packService = ipsApi == null
      ? null
      : ApiPackService(
          api: ipsApi,
          session: appSession.controller,
        );
  final ContractService? contractService =
      ipsApi == null || fiBomInstRepository == null
      ? null
      : ApiContractService(
          api: ipsApi,
          config: appSession.backendConfig,
          session: appSession.controller,
          fiBomInstRepository: fiBomInstRepository,
        );
  final PortfolioService? portfolioService = ipsApi == null
      ? null
      : ApiPortfolioService(
          api: ipsApi,
          config: appSession.backendConfig,
          session: appSession.controller,
          bootstrapService: bootstrapService,
        );
  final OrdersService? ordersService = ipsApi == null
      ? null
      : ApiOrdersService(
          api: ipsApi,
          config: appSession.backendConfig,
          session: appSession.controller,
        );

  final IpsDependencies ipsDependencies = IpsDependencies(
    bootstrapService: bootstrapService,
    questionnaireService: questionnaireService,
    packService: packService,
    contractService: contractService,
    portfolioService: portfolioService,
    ordersService: ordersService,
    sessionStore: appSession.store,
    sessionController: appSession.controller,
    appApi: appApi,
    bankOptionsRepository: fiBomInstRepository == null
        ? const UnavailableSecAcntBankOptionsRepository()
        : ApiSecAcntBankOptionsRepository(
            fiBomInstRepository: fiBomInstRepository,
          ),
    bankAccountLookupRepository: ipsApi == null
        ? const UnavailableSecAcntBankAccountLookupRepository()
        : ApiSecAcntBankAccountLookupRepository(api: ipsApi),
    bootstrapFlow: bootstrapService == null
        ? null
        : MiniAppBootstrapFlow(
            sessionController: appSession.controller,
            bootstrapService: bootstrapService,
          ),
    paymentExecutor: paymentExecutor,
    logger: logger,
  );

  return InvestXFeature(dependencies: ipsDependencies);
}
