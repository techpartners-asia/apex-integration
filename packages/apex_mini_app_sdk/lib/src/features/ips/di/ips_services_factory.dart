import '../../../app/session/mini_app_session_controller.dart';
import '../../../core/backend/sdk_backend_config.dart';
import '../shared/data/api/ips_backend_api.dart';
import '../shared/data/services/api_bootstrap_service.dart';
import '../shared/data/services/api_contract_service.dart';
import '../shared/data/services/api_orders_service.dart';
import '../shared/data/services/api_pack_service.dart';
import '../shared/data/services/api_portfolio_service.dart';
import '../shared/data/services/api_questionnaire_service.dart';
import '../shared/data/services/fi_bom_inst_repository.dart';
import '../shared/domain/services/investment_services.dart';

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
