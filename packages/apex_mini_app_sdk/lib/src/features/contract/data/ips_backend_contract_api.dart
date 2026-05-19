import 'package:apex_mini_app_sdk/apex_mini_app_sdk_internal.dart';

extension IpsBackendContractApi on IpsBackendApi {
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
