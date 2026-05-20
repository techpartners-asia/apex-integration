/// Request body for securities account balance lookup.
class GetSecAcntBalApiReq {
  /// Optional Apex session id.
  final String? sessionId;

  /// Source financial institution code.
  final String srcFiCode;

  /// Optional backend flag controlling lookup mode.
  final int? flag;

  /// Optional securities account code filter.
  final String? scAcntCode;

  /// Creates a securities balance lookup request.
  const GetSecAcntBalApiReq({
    this.sessionId,
    required this.srcFiCode,
    this.flag,
    this.scAcntCode,
  });

  /// Converts this request to JSON and omits blank optional values.
  Map<String, Object?> toJson() {
    return <String, Object?>{
      if (sessionId case final String value when value.trim().isNotEmpty)
        'sessionId': value.trim(),
      if (srcFiCode case final String value when value.trim().isNotEmpty)
        'srcFiCode': value.trim(),
      if (flag case final int value) 'flag': value,
      if (scAcntCode case final String value when value.trim().isNotEmpty)
        'scAcntCode': value.trim(),
    };
  }
}
