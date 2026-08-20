/// Request body for resolving a bank account holder name.
class CheckAcntNameByAcntCodeApiReq {
  /// Source account id, defaulting to `0` when none is selected.
  final int srcAcntId;

  /// Destination financial institution code.
  final String dstFiCode;

  /// Destination account number/code.
  final String dstAcntCode;

  /// CAM financial institution code required by the account-name check.
  final int camCheckFiCode;

  /// Creates an account-name lookup request.
  const CheckAcntNameByAcntCodeApiReq({
    this.srcAcntId = 0,
    required this.dstFiCode,
    required this.dstAcntCode,
    required this.camCheckFiCode,
  });

  /// Converts this request to backend JSON with trimmed strings.
  Map<String, Object?> toJson() {
    return <String, Object?>{
      'srcAcntId': srcAcntId,
      'dstFiCode': dstFiCode.trim(),
      'dstAcntCode': dstAcntCode.trim(),
      'camCheckFiCode': camCheckFiCode,
    };
  }
}
