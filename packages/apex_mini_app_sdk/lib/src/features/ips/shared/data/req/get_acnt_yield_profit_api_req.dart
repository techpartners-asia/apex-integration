class GetAcntYieldProfitApiReq {
  final String srcFiCode;

  const GetAcntYieldProfitApiReq({required this.srcFiCode});

  Map<String, Object?> toJson() {
    return <String, Object?>{'srcFiCode': srcFiCode};
  }
}
