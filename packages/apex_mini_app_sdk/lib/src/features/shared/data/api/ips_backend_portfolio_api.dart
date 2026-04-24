import 'package:mini_app_sdk/mini_app_sdk.dart';

extension IpsBackendPortfolioApi on IpsBackendApi {
  Future<ContractResDto> addBkrCustContract(AddBkrCustContractApiReq req) async {
    final Map<String, Object?> json = await protectedExecutor.postJson(
      ApiEndpoints.addBkrCustContract,
      body: req.toJson(),
      context: const ReqContext(operName: 'addBkrCustContract'),
    );

    return ContractResDto.fromJson(json);
  }

  Future<PortfolioOverviewDto> getIpsOverview({String? srcFiCode}) async {
    final Map<String, Object?> json = await protectedExecutor.postJson(
      ApiEndpoints.getIpsBalance,
      body: <String, Object?>{'srcFiCode': resolveSrcFiCode(srcFiCode)},
      context: const ReqContext(operName: 'getIpsBalance'),
    );

    return PortfolioOverviewDto.fromJson(json);
  }

  Future<List<PortfolioHoldingDto>> getYieldProfitHoldings(GetAcntYieldProfitApiReq req) async {
    final Map<String, Object?> json = await protectedExecutor.postJson(
      ApiEndpoints.getAcntYieldProfit,
      body: req.toJson(),
      context: const ReqContext(operName: 'getAcntYieldProfit'),
    );

    return PortfolioHoldingDto.listFromYieldProfitResponse(json);
  }

  Future<List<PortfolioHoldingDto>> getStockYieldDetail(GetStockAcntYieldDtlApiReq req) async {
    final Map<String, Object?> json = await protectedExecutor.postJson(
      ApiEndpoints.getStockAcntYieldDtl,
      body: req.toJson(),
      context: const ReqContext(operName: 'getStockAcntYieldDtl'),
    );

    return PortfolioHoldingDto.listFromStockYieldDetailResponse(json);
  }

  Future<CasaStatementResponseDto> getCasaStatements(GetCasaStmtApiReq req) async {
    final Map<String, Object?> json = await protectedExecutor.postJson(
      ApiEndpoints.getBkrPublicCasaAcntStmt,
      body: req.toJson(),
      context: const ReqContext(operName: 'getBkrPublicCasaAcntStmt'),
    );

    return CasaStatementResponseDto.fromJson(
      json,
      fallbackStartDate: req.startDate,
      fallbackEndDate: req.endDate,
    );
  }
}
