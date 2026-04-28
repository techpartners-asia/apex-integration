class GetStockAcntYieldDtlApiReq {
  final String brokerId;
  final String securityCode;
  final String srcFiCode;
  final bool isIps;

  const GetStockAcntYieldDtlApiReq({
    required this.brokerId,
    required this.securityCode,
    required this.srcFiCode,
    required this.isIps,
  });

  Map<String, Object?> toJson() {
    return <String, Object?>{
      'brokerId': brokerId,
      'securityCode': securityCode,
      'srcFiCode': srcFiCode,
      'isIps': isIps,
    };
  }
}
