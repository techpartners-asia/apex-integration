/// Domain request for submitting a sell order.
class SellOrderReq {
  /// Quantity of packs to sell.
  final int packQty;

  /// Creates a sell-order request from selected pack quantity.
  const SellOrderReq({required this.packQty});
}
