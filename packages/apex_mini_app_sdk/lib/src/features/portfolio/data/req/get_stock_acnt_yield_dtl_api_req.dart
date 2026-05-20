/// Request for stock-account yield detail for a single security.
class GetStockAcntYieldDtlApiReq {
  /// Optional broker identifier.
  final String? brokerId;

  /// Security code to query.
  final String securityCode;

  /// Source financial institution code.
  final String srcFiCode;

  /// Whether to query IPS-specific data.
  final bool isIps;

  /// Creates a stock account yield-detail request.
  const GetStockAcntYieldDtlApiReq({
    this.brokerId,
    required this.securityCode,
    required this.srcFiCode,
    required this.isIps,
  });

  /// Converts this request to backend JSON.
  Map<String, Object?> toJson() {
    return <String, Object?>{
      'brokerId': brokerId,
      'securityCode': securityCode,
      'srcFiCode': srcFiCode,
      'isIps': isIps,
    };
  }
}
