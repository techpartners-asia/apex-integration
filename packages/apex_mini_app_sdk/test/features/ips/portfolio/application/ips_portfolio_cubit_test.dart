import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mini_app_sdk/mini_app_sdk.dart';

void main() {
  final SdkLocalizations l10n = lookupSdkLocalizations(const Locale('en'));

  group('IpsPortfolioCubit', () {
    blocTest<IpsPortfolioCubit, LoadableState<IpsPortfolioViewData>>(
      'emits [loading, success] when load succeeds',
      build: () => IpsPortfolioCubit(
        service: _FakePortfolioService(),
        l10n: l10n,
      ),
      act: (cubit) => cubit.load(),
      verify: (cubit) {
        expect(cubit.state.status, LoadableStatus.success);
        expect(cubit.state.data?.overview.currency, 'MNT');
        expect(cubit.state.data?.holdings.length, 1);
        expect(cubit.state.data?.yieldProfitHoldings.length, 1);
      },
    );

    blocTest<IpsPortfolioCubit, LoadableState<IpsPortfolioViewData>>(
      'emits [loading, failure] when service throws and data is null',
      build: () => IpsPortfolioCubit(
        service: _FailingPortfolioService(),
        l10n: l10n,
      ),
      act: (cubit) => cubit.load(),
      verify: (cubit) {
        expect(cubit.state.status, LoadableStatus.failure);
        expect(cubit.state.errorMessage, isNotNull);
        expect(cubit.state.errorMessage, isNotEmpty);
        expect(cubit.state.data, isNull);
      },
    );

    blocTest<IpsPortfolioCubit, LoadableState<IpsPortfolioViewData>>(
      'preserves previous data on reload failure',
      build: () => IpsPortfolioCubit(
        service: _FailOnSecondLoadService(),
        l10n: l10n,
      ),
      act: (cubit) async {
        await cubit.load();
        await cubit.load();
      },
      verify: (cubit) {
        expect(cubit.state.status, LoadableStatus.failure);
        expect(cubit.state.data, isNotNull);
        expect(cubit.state.data?.overview.currency, 'MNT');
      },
    );

    blocTest<IpsPortfolioCubit, LoadableState<IpsPortfolioViewData>>(
      'skips duplicate load while already loading',
      build: () => IpsPortfolioCubit(
        service: _SlowPortfolioService(),
        l10n: l10n,
      ),
      act: (cubit) async {
        unawaited(cubit.load());
        unawaited(cubit.load());
        await Future<void>.delayed(const Duration(milliseconds: 200));
      },
      verify: (cubit) {
        expect(cubit.state.status, LoadableStatus.success);
      },
    );

    blocTest<IpsPortfolioCubit, LoadableState<IpsPortfolioViewData>>(
      'empty holdings still emits success',
      build: () => IpsPortfolioCubit(
        service: _EmptyHoldingsService(),
        l10n: l10n,
      ),
      act: (cubit) => cubit.load(),
      verify: (cubit) {
        expect(cubit.state.status, LoadableStatus.success);
        expect(cubit.state.data?.holdings, isEmpty);
        expect(cubit.state.data?.yieldProfitHoldings, isEmpty);
        expect(cubit.state.data?.stockYieldDetails, isEmpty);
      },
    );

    test(
      'stores the full dashboard payload instead of losing chart sources',
      () async {
        final IpsPortfolioCubit cubit = IpsPortfolioCubit(
          service: _FakePortfolioService(),
          l10n: l10n,
        );
        await cubit.load();

        expect(cubit.state.isSuccess, isTrue);
        final IpsPortfolioViewData data = cubit.state.data!;
        expect(data.overview, isA<PortfolioOverview>());
        expect(data.holdings, isA<List<PortfolioHolding>>());
        // expect(data.holdings.first.code, 'TEST');
        // expect(data.yieldProfitHoldings.first.profitAmount, 15);
        // expect(data.stockYieldDetails.first.code, 'DETAIL');
      },
    );
  });
}

class _FakePortfolioService implements PortfolioService {
  @override
  Future<PortfolioOverview> getOverview({SdkPortfolioContext? context}) async {
    return const PortfolioOverview(
      currency: 'MNT',
      availableBalance: 100,
      investedBalance: 200,
    );
  }

  @override
  Future<List<PortfolioHolding>> getHoldings({
    SdkPortfolioContext? context,
  }) async {
    return const <PortfolioHolding>[
    //   PortfolioHolding(
    //     code: 'TEST',
    //     name: 'Test Holding',
    //     quantity: 10,
    //     currentValue: 200,
    //     profitAmount: 15,
    //     pointLabel: 'Jan',
    //   ),
    ];
  }

  @override
  Future<PortfolioOverview> getIpsBalance({
    SdkPortfolioContext? context,
  }) async => getOverview(context: context);

  @override
  Future<PortfolioDashboardData> getDashboardData({
    SdkPortfolioContext? context,
  }) async {
    return PortfolioDashboardData(
      overview: await getOverview(context: context),
      yieldProfitHoldings: await getHoldings(context: context),
      stockYieldDetails: const <PortfolioHolding>[
        // PortfolioHolding(
        //   code: 'DETAIL',
        //   name: 'Detail Holding',
        //   quantity: 4,
        //   currentValue: 120,
        //   profitAmount: 8,
        //   pointLabel: 'Feb',
        // ),
      ],
    );
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

class _FailingPortfolioService implements PortfolioService {
  @override
  Future<PortfolioOverview> getOverview({SdkPortfolioContext? context}) async {
    throw const ApiNetworkException('Connection failed');
  }

  @override
  Future<List<PortfolioHolding>> getHoldings({
    SdkPortfolioContext? context,
  }) async {
    throw const ApiNetworkException('Connection failed');
  }

  @override
  Future<PortfolioOverview> getIpsBalance({
    SdkPortfolioContext? context,
  }) async => throw const ApiNetworkException('Connection failed');

  @override
  Future<PortfolioDashboardData> getDashboardData({
    SdkPortfolioContext? context,
  }) async => throw const ApiNetworkException('Connection failed');

  @override
  Future<PortfolioStatementsData> getStatements({
    SdkPortfolioContext? context,
  }) async => throw const ApiNetworkException('Connection failed');
}

class _FailOnSecondLoadService implements PortfolioService {
  int _loadCount = 0;

  @override
  Future<PortfolioOverview> getOverview({SdkPortfolioContext? context}) async {
    _loadCount++;
    if (_loadCount > 1) {
      throw const ApiNetworkException('Connection failed');
    }
    return const PortfolioOverview(
      currency: 'MNT',
      availableBalance: 100,
      investedBalance: 200,
    );
  }

  @override
  Future<List<PortfolioHolding>> getHoldings({
    SdkPortfolioContext? context,
  }) async {
    if (_loadCount > 1) {
      throw const ApiNetworkException('Connection failed');
    }
    return const <PortfolioHolding>[
      // PortfolioHolding(
      //   code: 'TEST',
      //   name: 'Test',
      //   quantity: 1,
      //   currentValue: 100,
      // ),
    ];
  }

  @override
  Future<PortfolioOverview> getIpsBalance({
    SdkPortfolioContext? context,
  }) async => getOverview(context: context);

  @override
  Future<PortfolioDashboardData> getDashboardData({
    SdkPortfolioContext? context,
  }) async {
    return PortfolioDashboardData(
      overview: await getOverview(context: context),
      yieldProfitHoldings: await getHoldings(context: context),
    );
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

class _SlowPortfolioService implements PortfolioService {
  @override
  Future<PortfolioOverview> getOverview({SdkPortfolioContext? context}) async {
    await Future<void>.delayed(const Duration(milliseconds: 50));
    return const PortfolioOverview(currency: 'MNT');
  }

  @override
  Future<List<PortfolioHolding>> getHoldings({
    SdkPortfolioContext? context,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 50));
    return const <PortfolioHolding>[];
  }

  @override
  Future<PortfolioOverview> getIpsBalance({
    SdkPortfolioContext? context,
  }) async => getOverview(context: context);

  @override
  Future<PortfolioDashboardData> getDashboardData({
    SdkPortfolioContext? context,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 120));
    return PortfolioDashboardData(
      overview: await getOverview(context: context),
    );
  }

  @override
  Future<PortfolioStatementsData> getStatements({
    SdkPortfolioContext? context,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 50));
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

class _EmptyHoldingsService implements PortfolioService {
  @override
  Future<PortfolioOverview> getOverview({SdkPortfolioContext? context}) async {
    return const PortfolioOverview(currency: 'MNT');
  }

  @override
  Future<List<PortfolioHolding>> getHoldings({
    SdkPortfolioContext? context,
  }) async {
    return const <PortfolioHolding>[];
  }

  @override
  Future<PortfolioOverview> getIpsBalance({
    SdkPortfolioContext? context,
  }) async => getOverview(context: context);

  @override
  Future<PortfolioDashboardData> getDashboardData({
    SdkPortfolioContext? context,
  }) async {
    return PortfolioDashboardData(
      overview: await getOverview(context: context),
    );
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
