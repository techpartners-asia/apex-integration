class GetAcntNameByAcntCodeApiReq {
  final int srcAcntId;
  final String dstFiCode;
  final String dstAcntCode;

  const GetAcntNameByAcntCodeApiReq({
    this.srcAcntId = 0,
    required this.dstFiCode,
    required this.dstAcntCode,
  });

  Map<String, Object?> toJson() {
    return <String, Object?>{
      'srcAcntId': srcAcntId,
      'dstFiCode': dstFiCode.trim(),
      'dstAcntCode': dstAcntCode.trim(),
    };
  }
}
