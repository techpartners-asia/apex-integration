import 'package:mini_app_sdk/mini_app_sdk.dart';

extension IpsBackendBootstrapApi on IpsBackendApi {
  Future<List<FiBomInstDto>> getFiBomInst(GetFiBomInstApiReq req) async {
    final Map<String, Object?> json = await protectedExecutor.postJson(
      ApiEndpoints.getFiBomInst,
      body: req.toJson(),
      context: const ReqContext(operName: 'getFiBomInst'),
    );

    return GetFiBomInstResDto.fromJson(json).items;
  }

  Future<GetSecuritiesAcntListResDto> getSecuritiesAcntList(
    GetSecuritiesAcntListApiReq req,
  ) async {
    final Map<String, Object?> json = await protectedExecutor.postJson(
      ApiEndpoints.getSecuritiesAcntList,
      body: req.toJson(),
      context: const ReqContext(operName: 'getSecAcntList'),
    );

    return GetSecuritiesAcntListResDto.fromJson(json);
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

  Future<GetSecuritiesAcntListResDto> getSecAcntBalState(
    GetSecAcntBalApiReq req,
  ) async {
    final Map<String, Object?> json = await protectedExecutor.postJson(
      ApiEndpoints.getSecAcntBalance,
      body: req.toJson(),
      context: const ReqContext(operName: 'getSecAcntBalance'),
    );

    return GetSecuritiesAcntListResDto.fromJson(json);
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
