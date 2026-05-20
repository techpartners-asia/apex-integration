/// Request body for creating an IPS sell/order operation.
class CreateIpsSellOrderApiReq {
  /// Source financial institution code.
  final String srcFiCode;

  /// Selected package quantity.
  final int packQty;

  /// Creates a sell-order request.
  const CreateIpsSellOrderApiReq({
    required this.srcFiCode,
    required this.packQty,
  });

  /// Converts this request to backend JSON.
  Map<String, Object?> toJson() {
    return <String, Object?>{'srcFiCode': srcFiCode, 'packQty': packQty};
  }
}
