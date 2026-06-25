import 'package:apex_mini_app_sdk/apex_mini_app_sdk.dart';

/// Backend API methods used by the securities-account bootstrap flow.
extension IpsBackendBootstrapApi on IpsBackendApi {
  /// Fetches broker/institution metadata needed for account setup.
  Future<List<FiBomInstDto>> getFiBomInst(GetFiBomInstApiReq req) async {
    final Map<String, Object?> json = await protectedExecutor.postJson(
      ApiEndpoints.getFiBomInst,
      body: req.toJson(),
      context: const ReqContext(operName: 'getFiBomInst'),
    );

    return GetFiBomInstResDto.fromJson(json).items;
  }

  /// Fetches the user's securities accounts.
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

  /// Submits a request to open a securities account.
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

  /// Fetches the account/balance state for an existing securities account.
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

  /// Resolves account holder name for an account code.
  Future<AcntNameLookupDto> checkAcntNameByAcntCode(
    CheckAcntNameByAcntCodeApiReq req,
  ) async {
    final Map<String, Object?> json = await protectedExecutor.postJson(
      ApiEndpoints.checkAcntNameByAcntCode,
      body: req.toJson(),
      context: const ReqContext(operName: 'checkAcntNameByAcntCode'),
    );

    return AcntNameLookupDto.fromJson(json);
  }
}
