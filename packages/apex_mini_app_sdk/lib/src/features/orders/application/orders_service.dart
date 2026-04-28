import 'package:mini_app_sdk/mini_app_sdk.dart';

abstract interface class OrdersService {
  Future<List<IpsOrder>> getOrders();

  Future<ActionRes> chargeIpsAcnt(RechargeReq req);

  Future<ActionRes> cancelOrder(IpsOrder order);

  Future<ActionRes> createSellOrder(SellOrderReq req);
}
