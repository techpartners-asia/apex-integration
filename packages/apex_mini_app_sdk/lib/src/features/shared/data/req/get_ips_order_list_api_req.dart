class GetIpsOrderListApiReq {
  final String srcFiCode;
  final int packQty;

  const GetIpsOrderListApiReq({required this.srcFiCode, this.packQty = 0});

  Map<String, Object?> toJson() {
    return <String, Object?>{'srcFiCode': srcFiCode, 'packQty': packQty};
  }
}
