import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mini_app_sdk/mini_app_sdk.dart';

void main() {
  final SdkLocalizations l10n = lookupSdkLocalizations(const Locale('en'));

  test('loadPricing uses packQty from getIpsBalance', () async {
    final IpsSellCubit cubit = IpsSellCubit(
      service: _FakeOrdersService(),
      l10n: l10n,
      portfolioService: _FakePortfolioService(
        overview: const PortfolioOverview(
          currency: 'MNT',
          packQty: 97,
          packAmount: 120000,
          packFee: 1500,
        ),
      ),
    );

    await cubit.loadPricing();

    expect(cubit.state.packQty, 97);
    expect(cubit.state.canSubmit, isTrue);
  });

  test(
    'loadPricing derives profit from holdings value when API omits it',
    () async {
      final IpsSellCubit cubit = IpsSellCubit(
        service: _FakeOrdersService(),
        l10n: l10n,
        portfolioService: _FakePortfolioService(
          overview: const PortfolioOverview(
            currency: 'MNT',
            packQty: 97,
            packAmount: 100000,
            packFee: 999.66,
            stockTotal: 5816638.8918,
            bondTotal: 3880000,
            cashTotal: 206402.29,
          ),
        ),
      );

      await cubit.loadPricing();

      expect(cubit.state.profit, closeTo(203041.1818, 0.0001));
      expect(cubit.state.totalAmount, 9700000);
      expect(cubit.state.payoutAmount, closeTo(9902041.5218, 0.0001));
    },
  );

  test(
    'submit creates the close order when owned package quantity exists',
    () async {
      final _FakeOrdersService ordersService = _FakeOrdersService();
      final IpsSellCubit cubit = IpsSellCubit(
        service: ordersService,
        l10n: l10n,
        portfolioService: _FakePortfolioService(
          overview: const PortfolioOverview(
            currency: 'MNT',
            packQty: 12,
            packAmount: 100000,
          ),
        ),
      );

      cubit.updatePackQty('12');
      await cubit.submit();

      expect(ordersService.createSellOrderCallCount, 1);
      expect(cubit.state.isSuccess, isTrue);
      expect(cubit.state.errorMessage, isNull);
    },
  );

  test(
    'refreshPacksAfterSuccess reloads packs once and returns refreshed packs',
    () async {
      final _FakeOrdersService ordersService = _FakeOrdersService();
      final _FakePackService packService = _FakePackService(
        completer: Completer<List<IpsPack>>(),
      );
      final IpsSellCubit cubit = IpsSellCubit(
        service: ordersService,
        l10n: l10n,
        portfolioService: _FakePortfolioService(
          overview: const PortfolioOverview(
            currency: 'MNT',
            packQty: 12,
            packAmount: 100000,
          ),
        ),
        packService: packService,
      );

      cubit.updatePackQty('12');
      await cubit.submit();

      final Future<List<IpsPack>?> firstRefresh = cubit
          .refreshPacksAfterSuccess();
      final Future<List<IpsPack>?> secondRefresh = cubit
          .refreshPacksAfterSuccess();

      expect(packService.getPacksCallCount, 1);
      expect(packService.lastForceRefresh, isTrue);
      expect(cubit.state.isRefreshingPacks, isTrue);
      expect(await secondRefresh, isNull);

      packService.completer!.complete(_testPacks);
      final List<IpsPack>? refreshedPacks = await firstRefresh;

      expect(refreshedPacks, _testPacks);
      expect(cubit.state.isRefreshingPacks, isFalse);
      expect(cubit.state.refreshErrorMessage, isNull);
    },
  );

  test(
    'refreshPacksAfterSuccess keeps success screen usable on pack load error',
    () async {
      final _FakePackService packService = _FakePackService(
        error: const ApiBusinessException(
          responseCode: 9999,
          message: 'Pack load failed',
        ),
      );
      final IpsSellCubit cubit = IpsSellCubit(
        service: _FakeOrdersService(),
        l10n: l10n,
        portfolioService: _FakePortfolioService(
          overview: const PortfolioOverview(
            currency: 'MNT',
            packQty: 12,
            packAmount: 100000,
          ),
        ),
        packService: packService,
      );

      cubit.updatePackQty('12');
      await cubit.submit();
      final List<IpsPack>? refreshedPacks = await cubit
          .refreshPacksAfterSuccess();

      expect(refreshedPacks, isNull);
      expect(packService.getPacksCallCount, 1);
      expect(cubit.state.isSuccess, isTrue);
      expect(cubit.state.isRefreshingPacks, isFalse);
      expect(cubit.state.refreshErrorMessage, 'Pack load failed');
      expect(cubit.state.canCompleteSuccessFlow, isTrue);
    },
  );
}

const List<IpsPack> _testPacks = <IpsPack>[
  IpsPack(
    packCode: '1',
    name: 'Pack 1',
    isRecommended: 1,
    bondPercent: 85,
    stockPercent: 15,
    assetPercent: 0,
  ),
];

class _FakeOrdersService implements OrdersService {
  int createSellOrderCallCount = 0;

  @override
  Future<ActionRes> createSellOrder(SellOrderReq req) async {
    createSellOrderCallCount += 1;
    return const ActionRes(message: 'ok');
  }

  @override
  Future<ActionRes> cancelOrder(IpsOrder order) {
    throw UnimplementedError();
  }

  @override
  Future<ActionRes> chargeIpsAcnt(RechargeReq req) {
    throw UnimplementedError();
  }

  @override
  Future<List<IpsOrder>> getOrders() {
    throw UnimplementedError();
  }
}

class _FakePortfolioService implements PortfolioService {
  _FakePortfolioService({required this.overview});

  final PortfolioOverview overview;

  @override
  Future<PortfolioOverview> getOverview({SdkPortfolioContext? context}) async {
    return overview;
  }

  @override
  Future<PortfolioOverview> getIpsBalance({
    SdkPortfolioContext? context,
  }) async {
    return overview;
  }

  @override
  Future<PortfolioDashboardData> getDashboardData({
    SdkPortfolioContext? context,
  }) {
    throw UnimplementedError();
  }

  @override
  Future<List<PortfolioHolding>> getHoldings({SdkPortfolioContext? context}) {
    throw UnimplementedError();
  }

  @override
  Future<PortfolioStatementsData> getStatements({
    SdkPortfolioContext? context,
  }) {
    throw UnimplementedError();
  }
}

class _FakePackService implements PackService {
  _FakePackService({
    this.packs = _testPacks,
    this.error,
    this.completer,
  });

  final List<IpsPack> packs;
  final Object? error;
  final Completer<List<IpsPack>>? completer;
  int getPacksCallCount = 0;
  bool? lastForceRefresh;

  @override
  Future<List<IpsPack>> getPacks({
    String? srcFiCode,
    bool forceRefresh = false,
  }) async {
    getPacksCallCount += 1;
    lastForceRefresh = forceRefresh;

    final Object? resolvedError = error;
    if (resolvedError != null) {
      throw resolvedError;
    }

    final Completer<List<IpsPack>>? pending = completer;
    if (pending != null) {
      return pending.future;
    }

    return packs;
  }
}
