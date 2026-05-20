import 'package:apex_mini_app_sdk/apex_mini_app_sdk.dart';

/// Orders/recharge/sell service contract.
abstract interface class OrdersService {
  /// Loads the user's IPS orders.
  Future<List<IpsOrder>> getOrders();

  /// Creates a recharge order/charge request.
  Future<ActionRes> chargeIpsAcnt(RechargeReq req);

  /// Cancels an existing order.
  Future<ActionRes> cancelOrder(IpsOrder order);

  /// Creates a sell order.
  Future<ActionRes> createSellOrder(SellOrderReq req);
}
