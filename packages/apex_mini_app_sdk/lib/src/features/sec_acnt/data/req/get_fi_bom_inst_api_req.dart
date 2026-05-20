/// Request body for FI/BOM institution dictionary lookup.
class GetFiBomInstApiReq {
  /// FI institution code to fetch.
  final String fiBomInst;

  /// Dictionary version requested by the backend.
  final int dicVersion;

  /// Creates an FI/BOM institution lookup request.
  const GetFiBomInstApiReq({required this.fiBomInst, this.dicVersion = 0});

  /// Converts this request to backend JSON.
  Map<String, Object?> toJson() => <String, Object?>{
    'fiBomInst': fiBomInst.trim(),
    'dicVersion': dicVersion,
  };
}
