enum HoldingAssetType { stock, bond }

class PortfolioHolding {
  final String code;
  final String name;
  final double quantity;
  final double currentValue;
  final double? yieldPercent;
  final double? profitAmount;
  final HoldingAssetType? assetType;
  final String? pointLabel;
  final DateTime? recordedAt;

  const PortfolioHolding({
    required this.code,
    required this.name,
    required this.quantity,
    required this.currentValue,
    this.yieldPercent,
    this.profitAmount,
    this.assetType,
    this.pointLabel,
    this.recordedAt,
  });
}
