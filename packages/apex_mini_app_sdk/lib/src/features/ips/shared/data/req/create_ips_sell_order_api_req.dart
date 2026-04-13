class CreateIpsSellOrderApiReq {
  final String srcFiCode;
  final int packQty;

  const CreateIpsSellOrderApiReq({
    required this.srcFiCode,
    required this.packQty,
  });

  Map<String, Object?> toJson() {
    return <String, Object?>{'srcFiCode': srcFiCode, 'packQty': packQty};
  }
}
