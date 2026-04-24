import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mini_app_sdk/mini_app_sdk.dart';

void main() {
  test('loadPricing uses the focused IPS balance path', () async {
    final _FakePortfolioService portfolioService = _FakePortfolioService(
      overview: const PortfolioOverview(
        currency: 'MNT',
        packAmount: 120000,
        packFee: 1500,
      ),
    );
    final IpsRechargeCubit cubit = IpsRechargeCubit(
      service: _FakeOrdersService(),
      portfolioService: portfolioService,
      paymentExecutor: _FakePaymentExecutor(
        result: const MiniAppPaymentRes.success(),
      ),
      l10n: lookupSdkLocalizations(const Locale('en')),
    );

    await cubit.loadPricing();

    expect(portfolioService.getIpsBalanceCallCount, 1);
    expect(portfolioService.getOverviewCallCount, 0);
    expect(cubit.state.unitPrice, 120000);
    expect(cubit.state.serviceFee, 1500);
  });

  test('submit refreshes IPS balance after charge success', () async {
    final _FakeOrdersService ordersService = _FakeOrdersService();
    final _FakePortfolioService portfolioService = _FakePortfolioService(
      overview: const PortfolioOverview(
        currency: 'MNT',
        availableBalance: 1500,
        investedBalance: 3000,
      ),
    );
    final IpsRechargeCubit cubit = IpsRechargeCubit(
      service: ordersService,
      portfolioService: portfolioService,
      paymentExecutor: _FakePaymentExecutor(
        result: const MiniAppPaymentRes.success(),
      ),
      l10n: lookupSdkLocalizations(const Locale('en')),
      unitPrice: 150000,
      serviceFee: 2500,
    );

    cubit.updatePackQty('3');
    await cubit.submit();

    final IpsRechargeState state = cubit.state;
    expect(ordersService.chargeCallCount, 1);
    expect(portfolioService.getIpsBalanceCallCount, 1);
    expect(state.paymentRes?.status, MiniAppPaymentStatus.success);
    expect(state.refreshedOverview?.availableBalance, 1500);
    expect(state.refreshedOverview?.investedBalance, 3000);
    expect(state.errorMessage, isNull);
  });
}

class _FakeOrdersService implements OrdersService {
  int chargeCallCount = 0;

  @override
  Future<ActionRes> chargeIpsAcnt(RechargeReq req) async {
    chargeCallCount += 1;
    return const ActionRes(message: 'ok');
  }

  @override
  Future<ActionRes> cancelOrder(IpsOrder order) {
    throw UnimplementedError();
  }

  @override
  Future<ActionRes> createSellOrder(SellOrderReq req) {
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
  int getIpsBalanceCallCount = 0;
  int getOverviewCallCount = 0;

  @override
  Future<PortfolioOverview> getIpsBalance({
    SdkPortfolioContext? context,
  }) async {
    getIpsBalanceCallCount += 1;
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
  Future<PortfolioOverview> getOverview({SdkPortfolioContext? context}) async {
    getOverviewCallCount += 1;
    return overview;
  }

  @override
  Future<PortfolioStatementsData> getStatements({
    SdkPortfolioContext? context,
  }) {
    throw UnimplementedError();
  }
}

class _FakePaymentExecutor extends MiniAppPaymentExecutor {
  _FakePaymentExecutor({required this.result})
    : super(
        appApi: const MiniAppApiRepository(),
        walletPaymentHandler: _unusedWalletHandler,
      );

  final MiniAppPaymentRes result;

  @override
  Future<MiniAppPaymentRes> execute({
    required MiniAppWalletPaymentFlow flow,
    required CreateInvoiceApiReq invoiceRequest,
  }) async {
    return result;
  }

  static Future<MiniAppPaymentRes> _unusedWalletHandler(
    MiniAppWalletPaymentRequest request,
  ) async {
    return const MiniAppPaymentRes.unsupported();
  }
}
