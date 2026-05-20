/// Request for charging an IPS account from a selected wallet.
class ChargeIpsAcntApiReq {
  /// Source financial institution code.
  final String srcFiCode;

  /// Wallet identifier selected for payment/recharge.
  final String wallet;

  /// Package quantity to charge.
  final int packQty;

  /// Creates an IPS account charge request.
  const ChargeIpsAcntApiReq({
    required this.srcFiCode,
    required this.wallet,
    required this.packQty,
  });

  /// Converts this request to backend JSON.
  Map<String, Object?> toJson() {
    return <String, Object?>{
      'srcFiCode': srcFiCode,
      'wallet': wallet,
      'packQty': packQty,
    };
  }
}
