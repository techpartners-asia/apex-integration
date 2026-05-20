import 'package:apex_mini_app_sdk/apex_mini_app_sdk.dart';

/// Contract-specific backend calls on top of [IpsBackendApi].
extension IpsBackendContractApi on IpsBackendApi {
  /// Adds/creates a broker customer contract.
  Future<ContractResDto> addBkrCustContract(
    AddBkrCustContractApiReq req,
  ) async {
    final Map<String, Object?> json = await protectedExecutor.postJson(
      ApiEndpoints.addBkrCustContract,
      body: req.toJson(),
      context: const ReqContext(operName: 'addBkrCustContract'),
    );

    return ContractResDto.fromJson(json);
  }
}
