import 'package:mini_app_sdk/mini_app_sdk.dart';

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
