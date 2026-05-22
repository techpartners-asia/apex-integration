import 'package:apex_mini_app_sdk/apex_mini_app_sdk.dart';

/// Contract service implementation backed by the IPS backend API.
class ApiContractService implements ContractService {
  /// Backend API facade.
  final IpsBackendApi api;

  /// SDK backend/runtime configuration.
  final SdkBackendConfig config;

  /// Session controller used to ensure login before contract creation.
  final MiniAppSessionController session;

  /// Repository that provides the broker institution defaults.
  final FiBomInstRepository fiBomInstRepository;

  /// Creates an API-backed contract service.
  const ApiContractService({
    required this.api,
    required this.config,
    required this.session,
    required this.fiBomInstRepository,
  });

  /// Creates the broker customer contract using current session/runtime data.
  @override
  Future<ContractRes> addBrokerCustContract() async {
    final SdkRuntimeConfig runtime = config.runtime;

    // if (!contract.isConfigured) {
    //   throw const ApiIntegrationException(
    //     'Contract defaults are not configured inside the SDK.',
    //   );
    // }

    await session.ensureLoginSession();

    UserEntityDto a = await session.ensureCurrentUser();
    final FiBomInstDto fiBomInst = await fiBomInstRepository.getDefaultFiBomInst();

    final ContractResDto contractRes = await api.addBkrCustContract(
      AddBkrCustContractApiReq(
        srcFiCode: runtime.defaultSrcFiCode,
        bankCode: fiBomInst.fiCode,
        bankAcntCode: a.account?.acntCode ?? '',
        bankAcntName: '',
        verfType: IpsDefaults.contractVerificationType,
      ),
    );

    return contractRes.toDomain();
  }
}
