import 'package:mini_app_sdk/mini_app_sdk.dart';

class ApiPortfolioService implements PortfolioService {
  final IpsBackendApi api;
  final SdkBackendConfig config;
  final MiniAppSessionController session;
  final InvestmentBootstrapService? bootstrapService;

  const ApiPortfolioService({
    required this.api,
    required this.config,
    required this.session,
    this.bootstrapService,
  });

  @override
  Future<List<PortfolioHolding>> getHoldings({
    SdkPortfolioContext? context,
  }) async {
    final SdkRuntimeConfig runtime = config.runtime;
    final SdkPortfolioContext portfolio = await _resolvePortfolioContext(
      override: context,
    );
    ApiException? lastError;

    if (_hasYieldProfitContext(runtime)) {
      try {
        return await _fetchYieldProfitHoldings(runtime, portfolio);
      } on ApiException catch (error) {
        lastError = error;
      }
    }

    if (_hasStockYieldDetailContext(portfolio)) {
      try {
        return await _fetchStockYieldDetails(runtime, portfolio);
      } on ApiException catch (error) {
        lastError = error;
      }
    }

    if (lastError != null) {
      throw lastError;
    }

    return const <PortfolioHolding>[];
  }

  @override
  Future<PortfolioOverview> getIpsBalance({
    SdkPortfolioContext? context,
  }) async {
    final SdkRuntimeConfig runtime = config.runtime;
    final SdkPortfolioContext portfolio = (context ?? const SdkPortfolioContext()).merge(config.portfolio).normalized(fallbackSrcFiCode: runtime.defaultSrcFiCode);
    await session.ensureLoginSession();

    final PortfolioOverviewDto overviewDto = await api.getIpsOverview(
      srcFiCode: portfolio.resolveSrcFiCode(runtime.defaultSrcFiCode),
    );
    return overviewDto.toDomain();
  }

  @override
  Future<PortfolioOverview> getOverview({SdkPortfolioContext? context}) async {
    return getIpsBalance(context: context);
  }

  @override
  Future<PortfolioDashboardData> getDashboardData({
    SdkPortfolioContext? context,
  }) async {
    final SdkRuntimeConfig runtime = config.runtime;
    final SdkPortfolioContext portfolio = await _resolvePortfolioContext(
      override: context,
    );
    final PortfolioOverview overview = await getIpsBalance(context: portfolio);
    final List<PortfolioHolding> yieldProfitHoldings = await _loadYieldProfitHoldings(runtime, portfolio);
    final List<PortfolioHolding> stockYieldDetails = await _loadStockYieldDetails(runtime, portfolio);

    final PortfolioOverview resolvedOverview = _mergeOverview(
      overview,
      yieldProfitHoldings: yieldProfitHoldings,
      stockYieldDetails: stockYieldDetails,
    );

    return PortfolioDashboardData(
      overview: resolvedOverview,
      yieldProfitHoldings: yieldProfitHoldings,
      stockYieldDetails: stockYieldDetails,
      portfolioContext: portfolio,
    );
  }

  @override
  Future<PortfolioStatementsData> getStatements({SdkPortfolioContext? context}) async {
    final SdkPortfolioContext portfolio = await _resolvePortfolioContext(
      override: context,
      requireStatementContext: true,
    );
    if (!_hasStatementContext(portfolio)) {
      return const PortfolioStatementsData(
        summary: '',
        currency: 'MNT',
        startDate: '',
        endDate: '',
      );
    }

    await session.ensureLoginSession();
    final CasaStatementResponseDto response = await api.getCasaStatements(
      GetCasaStmtApiReq(
        acntId: portfolio.casaAcntId!,
        startDate: portfolio.normalizedStmtStartDate!,
        endDate: portfolio.normalizedStmtEndDate!,
        pack: true,
        mode: '',
        isLastX: 0,
        scrType: '',
        exportType: '',
      ),
    );
    return response.toDomain();
  }

  Future<SdkPortfolioContext> _resolvePortfolioContext({
    SdkPortfolioContext? override,
    bool requireStatementContext = false,
  }) async {
    final SdkPortfolioContext seed = (override ?? const SdkPortfolioContext()).merge(config.portfolio).normalized(fallbackSrcFiCode: config.runtime.defaultSrcFiCode);
    final bool hasRequiredSeedContext = requireStatementContext ? seed.hasStatementContext : (seed.hasStockYieldDetailContext && seed.hasStatementContext);
    if (hasRequiredSeedContext && !requireStatementContext) {
      return seed;
    }

    AcntBootstrapState? bootstrapState;
    try {
      final InvestmentBootstrapService? service = bootstrapService;
      if (service != null) {
        bootstrapState = await service.getSecAcntListState();
      }
    } on ApiException {
      bootstrapState = null;
    }

    UserEntityDto? user;
    try {
      user = await session.ensureCurrentUser();
    } on ApiException {
      user = null;
    }

    final SdkPortfolioContext resolved = PortfolioContextResolver(
      seed: seed,
      defaultSrcFiCode: config.runtime.defaultSrcFiCode,
    ).resolve(bootstrapState: bootstrapState, user: user);

    if (!requireStatementContext || bootstrapState == null) {
      return resolved;
    }

    final SdkPortfolioContext bootstrapStatementContext = const PortfolioContextResolver().resolve(
      bootstrapState: bootstrapState,
    );

    return resolved.copyWith(
      casaAcntId: bootstrapStatementContext.normalizedCasaAcntId ?? resolved.normalizedCasaAcntId,
      stmtStartDate: bootstrapStatementContext.normalizedStmtStartDate ?? resolved.normalizedStmtStartDate,
      stmtEndDate: bootstrapStatementContext.normalizedStmtEndDate ?? resolved.normalizedStmtEndDate,
    );
  }

  Future<List<PortfolioHolding>> _loadYieldProfitHoldings(
    SdkRuntimeConfig runtime,
    SdkPortfolioContext portfolio,
  ) async {
    if (!_hasYieldProfitContext(runtime)) {
      return const <PortfolioHolding>[];
    }

    try {
      return await _fetchYieldProfitHoldings(runtime, portfolio);
    } on ApiException {
      return const <PortfolioHolding>[];
    }
  }

  Future<List<PortfolioHolding>> _loadStockYieldDetails(
    SdkRuntimeConfig runtime,
    SdkPortfolioContext portfolio,
  ) async {
    if (!_hasStockYieldDetailContext(portfolio)) {
      return const <PortfolioHolding>[];
    }

    try {
      return await _fetchStockYieldDetails(runtime, portfolio);
    } on ApiException {
      return const <PortfolioHolding>[];
    }
  }

  Future<List<PortfolioHolding>> _fetchYieldProfitHoldings(
    SdkRuntimeConfig runtime,
    SdkPortfolioContext portfolio,
  ) async {
    await session.ensureLoginSession();

    final List<PortfolioHoldingDto> holdings = await api.getYieldProfitHoldings(
      GetAcntYieldProfitApiReq(srcFiCode: runtime.defaultSrcFiCode),
    );

    return holdings.map((PortfolioHoldingDto dto) => dto.toDomain()).toList(growable: false);
  }

  Future<List<PortfolioHolding>> _fetchStockYieldDetails(
    SdkRuntimeConfig runtime,
    SdkPortfolioContext portfolio,
  ) async {
    if (!_hasStockYieldDetailContext(portfolio)) {
      return const <PortfolioHolding>[];
    }

    await session.ensureLoginSession();

    final List<PortfolioHoldingDto> holdings = await api.getStockYieldDetail(
      GetStockAcntYieldDtlApiReq(
        brokerId: portfolio.normalizedBrokerId!,
        securityCode: portfolio.normalizedSecurityCode!,
        srcFiCode: portfolio.resolveSrcFiCode(runtime.defaultSrcFiCode),
        isIps: true,
      ),
    );

    return holdings.map((PortfolioHoldingDto dto) => dto.toDomain()).toList(growable: false);
  }

  PortfolioOverview _mergeOverview(
    PortfolioOverview overview, {
    required List<PortfolioHolding> yieldProfitHoldings,
    required List<PortfolioHolding> stockYieldDetails,
  }) {
    final double? stockTotalFromDetails = _sumHoldingValues(
      stockYieldDetails,
      (PortfolioHolding holding) => holding.currentValue,
    );
    final double? stockTotalFromYieldProfit = _sumHoldingValues(
      yieldProfitHoldings,
      (PortfolioHolding holding) => holding.currentValue,
    );
    final double? resolvedStockTotal = _firstMeaningful(
      overview.stockTotal,
      stockTotalFromDetails,
      stockTotalFromYieldProfit,
    );
    final double? resolvedBondTotal = overview.bondTotal;
    final double? resolvedInvestedBalance = _firstMeaningful(
      overview.investedBalance,
      _sumIfAny(resolvedStockTotal, resolvedBondTotal),
      stockTotalFromDetails,
      stockTotalFromYieldProfit,
    );
    final double? resolvedCashTotal = _firstMeaningful(
      overview.cashTotal,
      overview.availableBalance,
    );
    final double? resolvedAvailableBalance = _firstMeaningful(
      overview.availableBalance,
      overview.cashTotal,
    );
    final double? resolvedYieldAmount = _firstMeaningful(
      overview.yieldAmount,
      _sumHoldingValues(
        yieldProfitHoldings,
        (PortfolioHolding holding) => holding.profitAmount,
      ),
      _sumHoldingValues(
        stockYieldDetails,
        (PortfolioHolding holding) => holding.profitAmount,
      ),
    );
    final double? resolvedProfitOrLoss = _firstMeaningful(
      overview.profitOrLoss,
      resolvedYieldAmount,
      _sumHoldingValues(
        yieldProfitHoldings,
        (PortfolioHolding holding) => holding.profitAmount,
      ),
      _sumHoldingValues(
        stockYieldDetails,
        (PortfolioHolding holding) => holding.profitAmount,
      ),
    );
    final double? resolvedStockPercent = _firstMeaningful(
      overview.stockPercent,
      _derivePercent(resolvedStockTotal, resolvedInvestedBalance),
    );
    final double? resolvedBondPercent = _firstMeaningful(
      overview.bondPercent,
      _derivePercent(resolvedBondTotal, resolvedInvestedBalance),
    );

    return overview.copyWith(
      availableBalance: resolvedAvailableBalance,
      investedBalance: resolvedInvestedBalance,
      profitOrLoss: resolvedProfitOrLoss,
      yieldAmount: resolvedYieldAmount,
      stockTotal: resolvedStockTotal,
      bondTotal: resolvedBondTotal,
      stockPercent: resolvedStockPercent,
      bondPercent: resolvedBondPercent,
      cashTotal: resolvedCashTotal,
    );
  }

  bool _hasYieldProfitContext(SdkRuntimeConfig runtime) {
    return runtime.defaultSrcFiCode.trim().isNotEmpty;
  }

  bool _hasStockYieldDetailContext(SdkPortfolioContext portfolio) {
    return portfolio.hasStockYieldDetailContext;
  }

  bool _hasStatementContext(SdkPortfolioContext portfolio) {
    return portfolio.hasStatementContext;
  }

  double? _firstMeaningful(
    double? first, [
    double? second,
    double? third,
    double? fourth,
  ]) {
    for (final double? value in <double?>[first, second, third, fourth]) {
      if (value != null && value.isFinite) {
        return value;
      }
    }
    return null;
  }

  double? _sumHoldingValues(
    List<PortfolioHolding> holdings,
    double? Function(PortfolioHolding holding) selector,
  ) {
    if (holdings.isEmpty) {
      return null;
    }

    double total = 0;
    bool hasValue = false;
    for (final PortfolioHolding holding in holdings) {
      final double? value = selector(holding);
      if (value == null || !value.isFinite) {
        continue;
      }
      total += value;
      hasValue = true;
    }

    if (!hasValue) {
      return null;
    }

    return total;
  }

  double? _sumIfAny(double? first, double? second) {
    if (first == null && second == null) {
      return null;
    }
    return (first ?? 0) + (second ?? 0);
  }

  double? _derivePercent(double? value, double? total) {
    if (value == null || total == null || total <= 0) {
      return null;
    }
    return (value / total) * 100;
  }
}
