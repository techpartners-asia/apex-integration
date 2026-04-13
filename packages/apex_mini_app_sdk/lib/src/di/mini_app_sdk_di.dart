import 'package:mini_app_ui/mini_app_ui.dart';

import '../app/investx_api/backend/mini_app_api_repository.dart';
import '../app/bootstrap/mini_app_bootstrap_flow.dart';
import '../app/session/mini_app_session_runtime.dart';
import '../config/mini_app_sdk_config.dart';
import '../features/ips/di/ips_dependencies.dart';
import '../features/ips/di/ips_services_factory.dart';
import '../features/ips/router/investx_feature.dart';
import '../features/ips/sec_acnt/application/sec_acnt_bank_account_lookup_repository.dart';
import '../features/ips/sec_acnt/application/sec_acnt_bank_options_repository.dart';
import '../features/ips/shared/data/api/ips_backend_api.dart';
import '../features/ips/shared/data/services/fi_bom_inst_repository.dart';
import '../runtime/mini_app_payment_executor.dart';

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
