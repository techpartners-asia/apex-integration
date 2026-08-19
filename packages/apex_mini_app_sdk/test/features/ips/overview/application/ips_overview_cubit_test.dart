import 'package:apex_mini_app_sdk/apex_mini_app_sdk.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';


void main() {
  test(
    'load stores dashboard yield and profit responses separately in state',
    () async {
      const PortfolioHolding yieldProfitHolding = PortfolioHolding(
        holdingType: HoldingType.getAcntYieldProfit,
        securityName: 'Yield Profit',
        acntCode: 'AAA',
        quantity: 1,
        currentValue: 100,
        profit: 15,
      );
      const PortfolioHolding stockYieldDetail = PortfolioHolding(
        holdingType: HoldingType.getStockAcntYieldDtl,
        securityName: 'Stock Yield Detail',
        securityCode: 'BBB',
        quantity: 2,
        currentValue: 200,
      );
      final _FakePortfolioService portfolioService = _FakePortfolioService(
        dashboardData: PortfolioDashboardData(
          overview: const PortfolioOverview(
            currency: 'MNT',
            investedBalance: 300,
            availableBalance: 50,
            profitOrLoss: 15,
          ),
          yieldProfitHoldings: const <PortfolioHolding>[yieldProfitHolding],
          stockYieldDetails: const <PortfolioHolding>[stockYieldDetail],
        ),
      );
      final IpsOverviewCubit cubit = IpsOverviewCubit(
        bootstrapService: const _FakeBootstrapService(),
        portfolioService: portfolioService,
        l10n: lookupSdkLocalizations(const Locale('mn')),
      );

      await cubit.load(
        initial: const AcntBootstrapState(
          response: GetSecuritiesAcntListResDto(
            detail: GetSecuritiesAcntListDetailDto(
              hasAcnt: true,
              hasIpsAcnt: true,
            ),
            acnts: <GetSecAcntListAccountDto>[
              GetSecAcntListAccountDto(
                flag: 3,
                brokerId: 'BROKER-1',
                instrumentCode: 'SEC-1',
              ),
              GetSecAcntListAccountDto(
                flag: 12,
                acntId: 77,
                statementMaxDay: '30',
              ),
            ],
            stlAcnts: <GetSecAcntSettlementAccountDto>[],
            responseCode: 0,
          ),
        ),
      );

      final IpsOverviewViewData? stateData = cubit.state.data;

      expect(cubit.state.isSuccess, isTrue);
      expect(stateData, isNotNull);
      expect(stateData?.portfolioOverview?.currency, 'MNT');
      expect(stateData?.yieldProfitHoldings, hasLength(1));
      expect(stateData!.yieldProfitHoldings.first.acntCode, 'AAA');
      expect(stateData.stockYieldDetails, hasLength(1));
      expect(stateData.stockYieldDetails.first.securityCode, 'BBB');
      expect(portfolioService.getDashboardDataCallCount, 1);
      expect(portfolioService.lastContext?.normalizedBrokerId, 'BROKER-1');
      // expect(portfolioService.lastContext?.normalizedSecurityCode, 'SEC-1');
      expect(portfolioService.lastContext?.normalizedCasaAcntId, 77);
      expect(portfolioService.lastContext?.hasStatementContext, isTrue);
    },
  );

  test('load(forceRefresh: true) bypasses cached bootstrap metadata', () async {
    final _TrackableBootstrapService bootstrapService =
        _TrackableBootstrapService();
    final IpsOverviewCubit cubit = IpsOverviewCubit(
      bootstrapService: bootstrapService,
      l10n: lookupSdkLocalizations(const Locale('mn')),
    );

    await cubit.load(forceRefresh: true);

    expect(bootstrapService.lastForceRefresh, isTrue);
  });
}

class _FakePortfolioService implements PortfolioService {
  _FakePortfolioService({required this.dashboardData});

  final PortfolioDashboardData dashboardData;
  int getDashboardDataCallCount = 0;
  SdkPortfolioContext? lastContext;

  @override
  Future<PortfolioDashboardData> getDashboardData({
    SdkPortfolioContext? context,
  }) async {
    getDashboardDataCallCount += 1;
    lastContext = context;
    return dashboardData;
  }

  @override
  Future<List<PortfolioHolding>> getHoldings({
    SdkPortfolioContext? context,
  }) async {
    return dashboardData.yieldProfitHoldings;
  }

  @override
  Future<PortfolioOverview> getIpsBalance({
    SdkPortfolioContext? context,
  }) async {
    return dashboardData.overview;
  }

  @override
  Future<PortfolioOverview> getOverview({
    SdkPortfolioContext? context,
  }) async {
    return dashboardData.overview;
  }

  @override
  Future<PortfolioStatementsData> getStatements({
    SdkPortfolioContext? context,
  }) async {
    return const PortfolioStatementsData(
      summary: '',
      currency: 'MNT',
      startDate: '',
      endDate: '',
      pageCount: 0,
      totalPage: 0,
    );
  }
}

class _FakeBootstrapService implements InvestmentBootstrapService {
  const _FakeBootstrapService();

  @override
  Future<SecAcntRequestResult> addSecuritiesAcntReq({
    SecAcntPersonalInfoData? personalInfo,
  }) {
    throw UnimplementedError();
  }

  @override
  Future<AcntBootstrapState> getSecAcntBalanceState({
    required AcntBootstrapState currentState,
  }) {
    throw UnimplementedError();
  }

  @override
  Future<AcntBootstrapState> getSecAcntListState({
    bool forceRefresh = false,
  }) {
    throw UnimplementedError();
  }
}

class _TrackableBootstrapService implements InvestmentBootstrapService {
  bool? lastForceRefresh;

  @override
  Future<SecAcntRequestResult> addSecuritiesAcntReq({
    SecAcntPersonalInfoData? personalInfo,
  }) {
    throw UnimplementedError();
  }

  @override
  Future<AcntBootstrapState> getSecAcntBalanceState({
    required AcntBootstrapState currentState,
  }) async {
    return currentState;
  }

  @override
  Future<AcntBootstrapState> getSecAcntListState({
    bool forceRefresh = false,
  }) async {
    lastForceRefresh = forceRefresh;
    return _openBootstrapState();
  }
}

AcntBootstrapState _openBootstrapState() {
  return const AcntBootstrapState(
    response: GetSecuritiesAcntListResDto(
      detail: GetSecuritiesAcntListDetailDto(
        hasAcnt: true,
        hasIpsAcnt: false,
      ),
      acnts: <GetSecAcntListAccountDto>[],
      stlAcnts: <GetSecAcntSettlementAccountDto>[],
      responseCode: 0,
    ),
  );
}
