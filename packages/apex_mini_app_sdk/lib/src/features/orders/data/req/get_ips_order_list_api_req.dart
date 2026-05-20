/// Request for fetching IPS orders.
class GetIpsOrderListApiReq {
  /// Source financial institution code.
  final String srcFiCode;

  /// Optional package quantity filter expected by the backend.
  final int packQty;

  /// Creates an order-list request.
  const GetIpsOrderListApiReq({required this.srcFiCode, this.packQty = 0});

  /// Converts this request to backend JSON.
  Map<String, Object?> toJson() {
    return <String, Object?>{'srcFiCode': srcFiCode, 'packQty': packQty};
  }
}
