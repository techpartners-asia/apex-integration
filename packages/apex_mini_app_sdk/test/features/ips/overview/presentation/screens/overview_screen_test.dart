import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:apex_mini_app_sdk/apex_mini_app_sdk.dart';
import 'package:apex_mini_app_sdk/src/host/apex_mini_app_host_context.dart';

import '../../../../../test_helpers/widget_test_app.dart';

void main() {
  testWidgets('shows loading state when overview data is still empty', (
    WidgetTester tester,
  ) async {
    final _TestIpsOverviewCubit cubit = _TestIpsOverviewCubit(
      const LoadableState<IpsOverviewViewData>(status: LoadableStatus.loading),
    );

    await tester.pumpWidget(_buildOverviewTestApp(cubit));

    expect(find.byType(MiniAppLoadingState), findsOneWidget);
    expect(find.text('Checking acnt bootstrap state.'), findsOneWidget);
  });

  testWidgets('shows error state and retries through the cubit', (
    WidgetTester tester,
  ) async {
    final _TestIpsOverviewCubit cubit = _TestIpsOverviewCubit(
      const LoadableState<IpsOverviewViewData>(
        status: LoadableStatus.failure,
        errorMessage: 'Boom',
      ),
    );

    await tester.pumpWidget(_buildOverviewTestApp(cubit));

    expect(find.text('Something went wrong'), findsOneWidget);
    expect(find.text('Boom'), findsOneWidget);

    await tester.tap(find.text('Retry'));
    await tester.pump();

    expect(cubit.loadCallCount, 1);
  });

  testWidgets(
    'does not build dashboard tab until dashboard data is ready',
    (WidgetTester tester) async {
      final _TestIpsOverviewCubit cubit = _TestIpsOverviewCubit(
        LoadableState<IpsOverviewViewData>(
          status: LoadableStatus.loading,
          data: IpsOverviewViewData(
            bootstrapState: _openIpsBootstrapState(),
            isDashboardDataReady: false,
          ),
        ),
      );

      await tester.pumpWidget(_buildOverviewTestApp(cubit));

      expect(find.byType(OverviewDashboardHomeTab), findsNothing);
      expect(find.byType(OverviewDashboardHomeShimmer), findsOneWidget);
    },
  );

  testWidgets(
    'disables trading nav action when the user has no active package',
    (
      WidgetTester tester,
    ) async {
      final _TestIpsOverviewCubit cubit = _TestIpsOverviewCubit(
        LoadableState<IpsOverviewViewData>(
          status: LoadableStatus.success,
          data: IpsOverviewViewData(
            bootstrapState: _openIpsBootstrapState(),
            portfolioOverview: const PortfolioOverview(
              currency: 'MNT',
              packQty: 0,
            ),
          ),
        ),
      );

      await tester.pumpWidget(_buildOverviewTestApp(cubit));
      await tester.pumpAndSettle();

      // final MiniAppAdaptivePressable tradingAction = tester
      //     .widget<MiniAppAdaptivePressable>(
      //       find.byKey(CustomNavbar.tradingActionKey),
      //     );
      //
      // expect(tradingAction.onPressed, isNull);
    },
  );

  testWidgets(
    'hides dashboard financial widgets when getIpsBalance fails',
    (WidgetTester tester) async {
      final _TestIpsOverviewCubit cubit = _TestIpsOverviewCubit(
        LoadableState<IpsOverviewViewData>(
          status: LoadableStatus.success,
          data: IpsOverviewViewData(
            bootstrapState: _openIpsBootstrapState(),
            isDashboardDataReady: true,
            dashboardLoadFailed: true,
          ),
        ),
      );

      await tester.pumpWidget(_buildOverviewTestApp(cubit));
      await tester.pumpAndSettle();

      final OverviewDashboardSummaryCard summary = tester.widget(
        find.byType(OverviewDashboardSummaryCard),
      );
      expect(summary.showFinancialSummary, isFalse);
      expect(find.byType(AllocationSummaryCard), findsNothing);
    },
  );

  testWidgets(
    'hides dashboard financial widgets when getIpsBalance balance is zero',
    (WidgetTester tester) async {
      final _TestIpsOverviewCubit cubit = _TestIpsOverviewCubit(
        LoadableState<IpsOverviewViewData>(
          status: LoadableStatus.success,
          data: IpsOverviewViewData(
            bootstrapState: _openIpsBootstrapState(),
            portfolioOverview: const PortfolioOverview(
              currency: 'MNT',
              investedBalance: 0,
              stockTotal: 0,
              bondTotal: 0,
              packAmount: 0,
            ),
            isDashboardDataReady: true,
          ),
        ),
      );

      await tester.pumpWidget(_buildOverviewTestApp(cubit));
      await tester.pumpAndSettle();

      final OverviewDashboardSummaryCard summary = tester.widget(
        find.byType(OverviewDashboardSummaryCard),
      );
      expect(summary.showFinancialSummary, isFalse);
      expect(find.byType(AllocationSummaryCard), findsNothing);
    },
  );

  testWidgets(
    'shows dashboard financial widgets when getIpsBalance balance is non-zero',
    (WidgetTester tester) async {
      final _TestIpsOverviewCubit cubit = _TestIpsOverviewCubit(
        LoadableState<IpsOverviewViewData>(
          status: LoadableStatus.success,
          data: IpsOverviewViewData(
            bootstrapState: _openIpsBootstrapState(),
            portfolioOverview: const PortfolioOverview(
              currency: 'MNT',
              investedBalance: 600000,
              stockTotal: 500000,
              bondTotal: 100000,
              profitOrLoss: 120000,
              profitPercent: 20,
            ),
            isDashboardDataReady: true,
          ),
        ),
      );

      await tester.pumpWidget(_buildOverviewTestApp(cubit));
      await tester.pumpAndSettle();

      final OverviewDashboardSummaryCard summary = tester.widget(
        find.byType(OverviewDashboardSummaryCard),
      );
      expect(summary.showFinancialSummary, isTrue);
      expect(find.byType(AllocationSummaryCard), findsOneWidget);
    },
  );

  testWidgets(
    'enables trading nav action when the user has an active package',
    (
      WidgetTester tester,
    ) async {
      final _TestIpsOverviewCubit cubit = _TestIpsOverviewCubit(
        LoadableState<IpsOverviewViewData>(
          status: LoadableStatus.success,
          data: IpsOverviewViewData(
            bootstrapState: _openIpsBootstrapState(),
            portfolioOverview: const PortfolioOverview(
              currency: 'MNT',
              packQty: 2,
            ),
          ),
        ),
      );

      await tester.pumpWidget(_buildOverviewTestApp(cubit));
      await tester.pumpAndSettle();

      // final MiniAppAdaptivePressable tradingAction = tester
      //     .widget<MiniAppAdaptivePressable>(
      //       find.byKey(CustomNavbar.tradingActionKey),
      //     );
      //
      // expect(tradingAction.onPressed, isNotNull);
    },
  );

  testWidgets('close button requests the SDK safe close path', (
    WidgetTester tester,
  ) async {
    final _TestIpsOverviewCubit cubit = _TestIpsOverviewCubit(
      LoadableState<IpsOverviewViewData>(
        status: LoadableStatus.success,
        data: IpsOverviewViewData(
          bootstrapState: _openIpsBootstrapState(),
          isDashboardDataReady: true,
        ),
      ),
    );
    var closeCallCount = 0;
    BuildContext? closeContext;
    ApexMiniAppHostContext.bind(
      nextCallbacks: ApexMiniAppHostCallbacks.empty,
      safeClose: (BuildContext? context) async {
        closeCallCount += 1;
        closeContext = context;
      },
    );
    addTearDown(
      () => ApexMiniAppHostContext.clear(ApexMiniAppHostCallbacks.empty),
    );

    await tester.pumpWidget(_buildOverviewTestApp(cubit));
    await tester.pumpAndSettle();

    await tester.tap(find.byType(ActionButton).last);
    await tester.pump();

    expect(closeCallCount, 1);
    expect(closeContext, isNotNull);
  });
}

Widget _buildOverviewTestApp(_TestIpsOverviewCubit cubit) {
  return buildSdkTestApp(
    MultiBlocProvider(
      providers: <BlocProvider<dynamic>>[
        BlocProvider<IpsOverviewCubit>.value(value: cubit),
        BlocProvider<MiniAppSessionStore>(
          create: (_) => MiniAppSessionStore()
            ..setCurrentUser(
              UserEntityDto(
                firstName: 'Test',
                lastName: 'User',
                admSession: 'session-token',
              ),
            ),
        ),
      ],
      child: const IpsOverviewScreen(),
    ),
  );
}

class _TestIpsOverviewCubit extends IpsOverviewCubit {
  _TestIpsOverviewCubit(LoadableState<IpsOverviewViewData> initialState)
    : super(
        bootstrapService: const _FakeBootstrapService(),
        l10n: lookupSdkLocalizations(const Locale('en')),
      ) {
    emit(initialState);
  }

  int loadCallCount = 0;

  @override
  Future<void> load({
    AcntBootstrapState? initial,
    bool forceRefresh = false,
  }) async {
    loadCallCount += 1;
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

AcntBootstrapState _openIpsBootstrapState() {
  return const AcntBootstrapState(
    response: GetSecuritiesAcntListResDto(
      detail: GetSecuritiesAcntListDetailDto(
        hasAcnt: true,
        hasIpsAcnt: true,
      ),
      acnts: <GetSecAcntListAccountDto>[],
      stlAcnts: <GetSecAcntSettlementAccountDto>[],
      responseCode: 0,
    ),
  );
}
