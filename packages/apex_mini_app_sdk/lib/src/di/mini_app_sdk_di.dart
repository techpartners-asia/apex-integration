import 'package:mini_app_ui/mini_app_ui.dart';
import 'package:mini_app_sdk/mini_app_sdk.dart';

UiMiniAppModule buildMiniAppFeature(MiniAppSdkConfig config) {
  final MiniAppLogger logger = config.logger;
  final MiniAppSessionRuntime appSession = buildMiniAppSessionRuntime(
    initialUserToken: config.userToken,
    logger: logger,
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

  final featureServices = buildIpsFeatureServices(
    backendConfig: appSession.backendConfig,
    sessionController: appSession.controller,
    api: ipsApi,
    fiBomInstRepository: fiBomInstRepository,
  );

  final bootstrapService = featureServices.bootstrapService;

  final IpsDependencies ipsDependencies = IpsDependencies(
    services: featureServices,
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
