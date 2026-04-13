import '../../../../../core/backend/sdk_runtime_config.dart';

import '../../../../../app/session/mini_app_session_controller.dart';
import '../../../../../core/backend/sdk_backend_config.dart';
import '../../constants/ips_defaults.dart';
import '../../domain/services/investment_services.dart';
import '../api/ips_backend_api.dart';
import '../dto/ips_response_dtos.dart';
import '../req/add_bkr_cust_contract_api_req.dart';
import 'fi_bom_inst_repository.dart';

class ApiContractService implements ContractService {
  final IpsBackendApi api;
  final SdkBackendConfig config;
  final MiniAppSessionController session;
  final FiBomInstRepository fiBomInstRepository;

  const ApiContractService({
    required this.api,
    required this.config,
    required this.session,
    required this.fiBomInstRepository,
  });

  @override
  Future<ContractRes> addBrokerCustContract() async {
    final SdkRuntimeConfig runtime = config.runtime;

    // if (!contract.isConfigured) {
    //   throw const ApiIntegrationException(
    //     'Contract defaults are not configured inside the SDK.',
    //   );
    // }

    await session.ensureLoginSession();
    final FiBomInstDto fiBomInst = await fiBomInstRepository
        .getDefaultFiBomInst();

    final ContractResDto contractRes = await api.addBkrCustContract(
      AddBkrCustContractApiReq(
        srcFiCode: runtime.defaultSrcFiCode,
        bankCode: fiBomInst.fiCode,
        bankAcntCode: '55855555555', // contract.bankAcntCode!,
        bankAcntName: 'sadf', // contract.bankAcntName!,
        verfType: IpsDefaults.contractVerificationType,
      ),
    );

    return contractRes.toDomain();
  }
}
