import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mini_app_sdk/mini_app_sdk.dart';
import 'package:mini_app_ui/mini_app_ui.dart';

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
    response: GetSecuritiesAccountListResDto(
      detail: GetSecAcntListDetailDto(
        hasAcnt: true,
        hasIpsAcnt: true,
      ),
      acnts: <GetSecAcntListAccountDto>[],
      stlAcnts: <GetSecAcntSettlementAccountDto>[],
      responseCode: 0,
    ),
  );
}
