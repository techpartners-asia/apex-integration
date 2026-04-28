class GetFiBomInstApiReq {
  final String fiBomInst;
  final int dicVersion;

  const GetFiBomInstApiReq({required this.fiBomInst, this.dicVersion = 0});

  Map<String, Object?> toJson() => <String, Object?>{
    'fiBomInst': fiBomInst.trim(),
    'dicVersion': dicVersion,
  };
}
