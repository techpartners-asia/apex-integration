import '../../../../../core/api/api_endpoints.dart';
import '../../../../../core/api/req_context.dart';
import '../dto/ips_response_dtos.dart';
import '../req/add_sec_acnt_api_req.dart';
import '../req/get_fi_bom_inst_api_req.dart';
import '../req/get_acnt_name_by_acnt_code_api_req.dart';
import '../req/get_sec_acnt_bal_api_req.dart';
import '../req/get_sec_acnt_list_api_req.dart';
import 'ips_backend_api_base.dart';

extension IpsBackendBootstrapApi on IpsBackendApi {
  Future<List<FiBomInstDto>> getFiBomInst(GetFiBomInstApiReq req) async {
    final Map<String, Object?> json = await protectedExecutor.postJson(
      ApiEndpoints.getFiBomInst,
      body: req.toJson(),
      context: const ReqContext(operName: 'getFiBomInst'),
    );

    return GetFiBomInstResDto.fromJson(json).items;
  }

  Future<GetSecuritiesAccountListResDto> getSecuritiesAcntList(
    GetSecuritiesAcntListApiReq req,
  ) async {
    final Map<String, Object?> json = await protectedExecutor.postJson(
      ApiEndpoints.getSecuritiesAcntList,
      body: req.toJson(),
      context: const ReqContext(operName: 'getSecAcntList'),
    );

    return GetSecuritiesAccountListResDto.fromJson(json);
  }

  Future<AddSecuritiesAcntResDto> addSecuritiesAcntReq(
    AddSecuritiesAcntApiReq req,
  ) async {
    final Map<String, Object?> json = await protectedExecutor.postJson(
      ApiEndpoints.addSecuritiesAcntReq,
      body: req.toJson(),
      context: const ReqContext(operName: 'addSecuritiesAcntReq'),
    );

    return AddSecuritiesAcntResDto.fromJson(json);
  }

  Future<GetSecuritiesAccountListResDto> getSecAcntBalState(
    GetSecAcntBalApiReq req,
  ) async {
    final Map<String, Object?> json = await protectedExecutor.postJson(
      ApiEndpoints.getSecAcntBalance,
      body: req.toJson(),
      context: const ReqContext(operName: 'getSecAcntBalance'),
    );

    return GetSecuritiesAccountListResDto.fromJson(json);
  }

  Future<AcntNameLookupDto> getAcntNameByAcntCode(
    GetAcntNameByAcntCodeApiReq req,
  ) async {
    final Map<String, Object?> json = await protectedExecutor.postJson(
      ApiEndpoints.getAcntNameByAcntCode,
      body: req.toJson(),
      context: const ReqContext(operName: 'getAcntNameByAcntCode'),
    );

    return AcntNameLookupDto.fromJson(json);
  }
}
