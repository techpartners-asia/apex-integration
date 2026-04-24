import 'package:mini_app_sdk/mini_app_sdk.dart';

InvestmentServices buildIpsFeatureServices({
  required SdkBackendConfig backendConfig,
  required MiniAppSessionController sessionController,
  required IpsBackendApi? api,
  required FiBomInstRepository? fiBomInstRepository,
}) {
  if (api == null || fiBomInstRepository == null) {
    return const InvestmentServices();
  }

  final ApiInvestmentBootstrapService bootstrapService =
      ApiInvestmentBootstrapService(
        api: api,
        config: backendConfig,
        session: sessionController,
        fiBomInstRepository: fiBomInstRepository,
      );

  return InvestmentServices(
    bootstrapService: bootstrapService,
    questionnaireService: ApiQuestionnaireService(
      api: api,
      config: backendConfig,
      session: sessionController,
    ),
    packService: ApiPackService(api: api, session: sessionController),
    contractService: ApiContractService(
      api: api,
      config: backendConfig,
      session: sessionController,
      fiBomInstRepository: fiBomInstRepository,
    ),
    portfolioService: ApiPortfolioService(
      api: api,
      config: backendConfig,
      session: sessionController,
      bootstrapService: bootstrapService,
    ),
    ordersService: ApiOrdersService(
      api: api,
      config: backendConfig,
      session: sessionController,
    ),
  );
}
