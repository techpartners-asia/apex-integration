class GetSecuritiesAcntListApiReq {
  final String registerCode;
  final String? ipoCode;
  final String? mobile;
  final List<String> acnts;
  final String srcFiCode;

  const GetSecuritiesAcntListApiReq({
    required this.registerCode,
    this.ipoCode,
    this.mobile,
    this.acnts = const <String>[],
    required this.srcFiCode,
  });

  Map<String, Object?> toJson() {
    return <String, Object?>{
      'registerCode': registerCode,
      if (ipoCode case final String value when value.trim().isNotEmpty)
        'ipoCode': value.trim(),
      if (mobile case final String value when value.trim().isNotEmpty)
        'mobile': value.trim(),
      'acnts': acnts,
      'srcFiCode': srcFiCode,
    };
  }
}
