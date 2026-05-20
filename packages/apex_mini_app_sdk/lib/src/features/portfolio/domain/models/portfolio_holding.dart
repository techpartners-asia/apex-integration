/// Source endpoint/type that produced a portfolio holding row.
enum HoldingType { getStockAcntYieldDtl, getAcntYieldProfit }

/// Asset class used for portfolio grouping and chart coloring.
enum HoldingAssetType { stock, bond }

/// Unified portfolio holding row.
///
/// The backend returns similar investment data from multiple endpoints. This
/// model keeps endpoint-specific fields nullable and tags each instance with
/// [holdingType] so UI code can render the correct metrics.
class PortfolioHolding {
  /// Raw result value from the backend when needed for diagnostics.
  final Object? resultValue;

  /// Display name of the security/asset.
  final String securityName;

  /// Optional ticker or short symbol.
  final String? symbol;

  /// Asset class for chart and allocation grouping.
  final HoldingAssetType? assetType;

  /// Backend source represented by this holding.
  final HoldingType holdingType;

  /// getStockAcntYieldDtl
  /// Security code from stock-account yield detail.
  final String? securityCode;

  /// Quantity held.
  final double quantity;

  /// Current market value.
  final double? currentValue;

  /// Original investment value.
  final double? investmentValue;

  /// Today's yield amount.
  final double? todaysYield;

  /// Total yield amount.
  final double? totalYield;

  /// Total yield percentage.
  final double? totalPercent;

  /// Today's yield percentage.
  final double? todaysPercent;

  /// getAcntYieldProfit
  /// Account code from account yield/profit response.
  final String? acntCode;

  /// Total buy amount.
  final double? buyAmount;

  /// Total buy fee amount.
  final double? buyFeeAmt;

  /// Total sell amount.
  final double? sellAmount;

  /// Total sell fee amount.
  final double? sellFeeAmt;

  /// Average buy price.
  final double? buyAvg;

  /// Average sell price.
  final double? sellAvg;

  /// Customer code.
  final String? custCode;

  /// Current balance.
  final double? balance;

  /// Profit amount.
  final double? profit;

  /// Profit percentage.
  final double? profitPercent;

  /// Creates a normalized portfolio holding row.
  const PortfolioHolding({
    required this.holdingType,
    this.resultValue,
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
    this.buyFeeAmt,
    this.sellAmount,
    this.sellFeeAmt,
    this.buyAvg,
    this.sellAvg,
    this.custCode,
    this.balance,
    this.profit,
    this.profitPercent,
  });
}
