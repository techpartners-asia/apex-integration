/// Request body for resolving a bank account holder name.
class GetAcntNameByAcntCodeApiReq {
  /// Source account id, defaulting to `0` when none is selected.
  final int srcAcntId;

  /// Destination financial institution code.
  final String dstFiCode;

  /// Destination account number/code.
  final String dstAcntCode;

  /// Creates an account-name lookup request.
  const GetAcntNameByAcntCodeApiReq({
    this.srcAcntId = 0,
    required this.dstFiCode,
    required this.dstAcntCode,
  });

  /// Converts this request to backend JSON with trimmed strings.
  Map<String, Object?> toJson() {
    return <String, Object?>{
      'srcAcntId': srcAcntId,
      'dstFiCode': dstFiCode.trim(),
      'dstAcntCode': dstAcntCode.trim(),
    };
  }
}
