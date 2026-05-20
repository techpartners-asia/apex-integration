/// Request for account-level yield/profit holdings.
class GetAcntYieldProfitApiReq {
  /// Source financial institution code.
  final String srcFiCode;

  /// Optional security filter.
  final String? securityCode;

  /// Securities account code.
  final String acntCode;

  /// Creates an account yield-profit request.
  const GetAcntYieldProfitApiReq({
    required this.srcFiCode,
    this.securityCode,
    required this.acntCode,
  });

  /// Converts this request to backend JSON.
  Map<String, Object?> toJson() {
    return <String, Object?>{
      'srcFiCode': srcFiCode,
      'securityCode': securityCode,
      'acntCode': acntCode,
    };
  }
}
