class IpsPack {
  final String packCode;
  final String name;
  final String? name2;
  final String? packDesc;
  final int isRecommended;
  final double bondPercent;
  final double stockPercent;
  final double assetPercent;

  const IpsPack({
    required this.packCode,
    required this.name,
    this.name2,
    this.packDesc,
    required this.isRecommended,
    required this.bondPercent,
    required this.stockPercent,
    required this.assetPercent,
  });
}
