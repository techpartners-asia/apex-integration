class ChoosePackApiReq {
  final String srcFiCode;
  final String packCode;

  const ChoosePackApiReq({required this.srcFiCode, required this.packCode});

  Map<String, Object?> toJson() {
    return <String, Object?>{'srcFiCode': srcFiCode, 'packCode': packCode};
  }
}
