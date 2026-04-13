import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mini_app_sdk/l10n/sdk_localizations.dart';
import 'package:mini_app_sdk/src/core/backend/sdk_portfolio_context.dart';
import 'package:mini_app_sdk/src/features/ips/sell/application/ips_sell_cubit.dart';
import 'package:mini_app_sdk/src/features/ips/shared/domain/services/investment_services.dart';

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

      await cubit.loadPricing();
      await cubit.submit();

      expect(ordersService.createSellOrderCallCount, 1);
      expect(cubit.state.isSuccess, isTrue);
      expect(cubit.state.errorMessage, isNull);
    },
  );
}

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
