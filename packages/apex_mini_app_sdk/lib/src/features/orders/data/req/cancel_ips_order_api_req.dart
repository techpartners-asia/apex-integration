class CancelIpsOrderApiReq {
  final String srcFiCode;
  final int packQty;
  final int orderNo;

  const CancelIpsOrderApiReq({
    required this.srcFiCode,
    required this.packQty,
    required this.orderNo,
  });

  Map<String, Object?> toJson() {
    return <String, Object?>{
      'srcFiCode': srcFiCode,
      'packQty': packQty,
      'orderNo': orderNo,
    };
  }
}
