import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mini_app_sdk/l10n/sdk_localizations.dart';
import 'package:mini_app_sdk/src/core/backend/sdk_portfolio_context.dart';
import 'package:mini_app_sdk/src/features/ips/orders/application/ips_orders_cubit.dart';
import 'package:mini_app_sdk/src/features/ips/orders/application/ips_orders_state.dart';
import 'package:mini_app_sdk/src/features/ips/shared/domain/models/ips_models.dart';
import 'package:mini_app_sdk/src/features/ips/shared/domain/services/orders_service.dart';
import 'package:mini_app_sdk/src/features/ips/shared/domain/services/portfolio_service.dart';

void main() {
  test(
    'cancelOrder refreshes IPS balance after cancellation success',
    () async {
      final IpsOrder pendingOrder = IpsOrder(
        id: '1',
        title: 'Recharge order',
        buySell: 'b',
        status: IpsOrderStatus.pending,
        amount: 1000,
        createdAt: DateTime(2026, 4, 7),
        orderNo: 22,
      );
      final _FakeOrdersService ordersService = _FakeOrdersService(
        orders: <IpsOrder>[
          IpsOrder(
            id: pendingOrder.id,
            orderNo: pendingOrder.orderNo,
            title: pendingOrder.title,
            buySell: 'b',
            status: IpsOrderStatus.cancelled,
            amount: pendingOrder.amount,
            createdAt: pendingOrder.createdAt,
            packCode: pendingOrder.packCode,
            packQty: pendingOrder.packQty,
            registerCode: pendingOrder.registerCode,
            expiresAt: pendingOrder.expiresAt,
          ),
        ],
      );
      final _FakePortfolioService portfolioService = _FakePortfolioService(
        overview: const PortfolioOverview(
          currency: 'MNT',
          availableBalance: 777,
          investedBalance: 2222,
        ),
      );
      final IpsOrdersCubit cubit = IpsOrdersCubit(
        service: ordersService,
        portfolioService: portfolioService,
        l10n: lookupSdkLocalizations(const Locale('en')),
      );

      await cubit.cancelOrder(pendingOrder);

      final IpsOrdersState state = cubit.state;
      expect(ordersService.cancelCallCount, 1);
      expect(portfolioService.getIpsBalanceCallCount, 1);
      expect(state.cancelledOrderId, pendingOrder.id);
      expect(state.refreshedOverview?.availableBalance, 777);
      expect(state.orders, hasLength(1));
      expect(state.orders.first.status, IpsOrderStatus.cancelled);
      expect(state.errorMessage, isNull);
    },
  );
}

class _FakeOrdersService implements OrdersService {
  _FakeOrdersService({required this.orders});

  final List<IpsOrder> orders;
  int cancelCallCount = 0;

  @override
  Future<ActionRes> cancelOrder(IpsOrder order) async {
    cancelCallCount += 1;
    return const ActionRes(message: 'cancelled');
  }

  @override
  Future<ActionRes> chargeIpsAcnt(RechargeReq req) {
    throw UnimplementedError();
  }

  @override
  Future<ActionRes> createSellOrder(SellOrderReq req) {
    throw UnimplementedError();
  }

  @override
  Future<List<IpsOrder>> getOrders() async {
    return orders;
  }
}

class _FakePortfolioService implements PortfolioService {
  _FakePortfolioService({required this.overview});

  final PortfolioOverview overview;
  int getIpsBalanceCallCount = 0;

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
  Future<PortfolioOverview> getOverview({SdkPortfolioContext? context}) {
    throw UnimplementedError();
  }

  @override
  Future<PortfolioStatementsData> getStatements({
    SdkPortfolioContext? context,
  }) {
    throw UnimplementedError();
  }
}
