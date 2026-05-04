class GetAcntYieldProfitApiReq {
  final String srcFiCode;
  final String? securityCode;
  final String acntCode;

  const GetAcntYieldProfitApiReq({required this.srcFiCode, this.securityCode, required this.acntCode});

  Map<String, Object?> toJson() {
    return <String, Object?>{
      'srcFiCode': srcFiCode,
      'securityCode': securityCode,
      'acntCode': acntCode,
    };
  }
}
