class GetSecAcntBalApiReq {
  final String? sessionId;
  final String srcFiCode;
  final int? flag;
  final String? scAcntCode;

  const GetSecAcntBalApiReq({
    this.sessionId,
    required this.srcFiCode,
    this.flag,
    this.scAcntCode,
  });

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
