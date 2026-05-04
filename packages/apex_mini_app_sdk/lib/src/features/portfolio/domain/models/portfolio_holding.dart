enum HoldingType { getStockAcntYieldDtl, getAcntYieldProfit }
enum HoldingAssetType { stock, bond }

class PortfolioHolding {
  final String securityName;
  final String? symbol;
  final HoldingAssetType? assetType;
  final HoldingType holdingType;

  /// getStockAcntYieldDtl
  final String? securityCode;
  final double quantity;
  final double? currentValue;
  final double? investmentValue;
  final double? todaysYield;
  final double? totalYield;
  final double? totalPercent;
  final double? todaysPercent;

  /// getAcntYieldProfit
  final String? acntCode;
  final double? buyAmount;
  final String? custCode;
  final double? balance;
  final double? profit;
  final double? profitPercent;

  const PortfolioHolding({
    required this.holdingType,
    required this.securityName,
    this.symbol,
    this.assetType,

    /// getStockAcntYieldDtl
    this.securityCode,
    this.quantity = 0,
    this.currentValue,
    this.investmentValue,
    this.todaysYield,
    this.totalYield,
    this.totalPercent,
    this.todaysPercent,

    /// getAcntYieldProfit
    this.acntCode,
    this.buyAmount,
    this.custCode,
    this.balance,
    this.profit,
    this.profitPercent,
  });
}
