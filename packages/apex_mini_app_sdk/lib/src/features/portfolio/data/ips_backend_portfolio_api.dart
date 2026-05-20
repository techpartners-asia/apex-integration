import 'package:apex_mini_app_sdk/apex_mini_app_sdk.dart';

/// Backend API methods for IPS portfolio and statement endpoints.
extension IpsBackendPortfolioApi on IpsBackendApi {
  /// Fetches the current portfolio overview/balance snapshot.
  Future<PortfolioOverviewDto> getIpsOverview({String? srcFiCode}) async {
    final Map<String, Object?> json = await protectedExecutor.postJson(
      ApiEndpoints.getIpsBalance,
      body: <String, Object?>{'srcFiCode': resolveSrcFiCode(srcFiCode)},
      context: const ReqContext(operName: 'getIpsBalance'),
    );

    return PortfolioOverviewDto.fromJson(json);
  }

  /// Fetches yield/profit holdings and returns only the holding rows.
  Future<List<PortfolioHoldingDto>> getYieldProfitHoldings(
    GetAcntYieldProfitApiReq req,
  ) async {
    final PortfolioYieldProfitResponseDto response =
        await getYieldProfitResponse(req);
    return response.profit;
  }

  /// Fetches the full yield/profit response including totals.
  Future<PortfolioYieldProfitResponseDto> getYieldProfitResponse(
    GetAcntYieldProfitApiReq req,
  ) async {
    final Map<String, Object?> json = await protectedExecutor.postJson(
      ApiEndpoints.getAcntYieldProfit,
      body: req.toJson(),
      context: const ReqContext(operName: 'getAcntYieldProfit'),
    );

    return PortfolioYieldProfitResponseDto.fromJson(json);
  }

  /// Fetches detailed stock-yield rows for the selected securities account.
  Future<List<PortfolioHoldingDto>> getStockYieldDetail(
    GetStockAcntYieldDtlApiReq req,
  ) async {
    final Map<String, Object?> json = await protectedExecutor.postJson(
      ApiEndpoints.getStockAcntYieldDtl,
      body: req.toJson(),
      context: const ReqContext(operName: 'getStockAcntYieldDtl'),
    );

    return PortfolioHoldingDto.listFromStockYieldDetailResponse(json);
  }

  /// Fetches CASA statement rows for the requested account/date range.
  Future<CasaStatementResponseDto> getCasaStatements(
    GetCasaStmtApiReq req,
  ) async {
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
