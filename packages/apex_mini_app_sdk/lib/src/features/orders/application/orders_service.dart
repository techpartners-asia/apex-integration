import 'package:apex_mini_app_sdk/apex_mini_app_sdk.dart';

abstract interface class OrdersService {
  Future<List<IpsOrder>> getOrders();

  Future<ActionRes> chargeIpsAcnt(RechargeReq req);

  Future<ActionRes> cancelOrder(IpsOrder order);

  Future<ActionRes> createSellOrder(SellOrderReq req);
}
