class ChargeIpsAcntApiReq {
  final String srcFiCode;
  final String wallet;
  final int packQty;

  const ChargeIpsAcntApiReq({
    required this.srcFiCode,
    required this.wallet,
    required this.packQty,
  });

  Map<String, Object?> toJson() {
    return <String, Object?>{
      'srcFiCode': srcFiCode,
      'wallet': wallet,
      'packQty': packQty,
    };
  }
}
