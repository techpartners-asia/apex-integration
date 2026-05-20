/// Request for cancelling an IPS order.
class CancelIpsOrderApiReq {
  /// Source financial institution code.
  final String srcFiCode;

  /// Package quantity associated with the order.
  final int packQty;

  /// Backend order number to cancel.
  final int orderNo;

  /// Creates a cancel-order request.
  const CancelIpsOrderApiReq({
    required this.srcFiCode,
    required this.packQty,
    required this.orderNo,
  });

  /// Converts this cancellation request to backend JSON.
  Map<String, Object?> toJson() {
    return <String, Object?>{
      'srcFiCode': srcFiCode,
      'packQty': packQty,
      'orderNo': orderNo,
    };
  }
}
