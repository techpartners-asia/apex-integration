import 'package:mini_app_sdk/mini_app_sdk.dart';

class OrdersService {
  const OrdersService();

  Future<List<IpsOrder>> getOrders() {
    throw UnimplementedError();
  }

  Future<ActionRes> chargeIpsAcnt(RechargeReq req) {
    throw UnimplementedError();
  }

  Future<ActionRes> cancelOrder(IpsOrder order) {
    throw UnimplementedError();
  }

  Future<ActionRes> createSellOrder(SellOrderReq req) {
    throw UnimplementedError();
  }
}
