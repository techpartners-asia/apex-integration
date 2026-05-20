/// Portfolio balance/allocation overview returned by dashboard APIs.
class PortfolioOverview {
  /// Backend response code, if available.
  final int? responseCode;

  /// Backend response description.
  final String? responseDesc;

  /// Raw result value for diagnostics.
  final Object? resultValue;

  /// Currency code used by dashboard amounts.
  final String currency;

  /// Available cash/balance amount.
  final double? availableBalance;

  /// Invested balance amount.
  final double? investedBalance;

  /// Profit/loss amount.
  final double? profitOrLoss;

  /// Yield amount.
  final double? yieldAmount;

  /// Profit percentage.
  final double? profitPercent;

  /// Summary text for statement/dashboard cards.
  final String? statementSummary;

  /// Total stock allocation amount.
  final double? stockTotal;

  /// Total bond allocation amount.
  final double? bondTotal;

  /// Stock allocation percentage.
  final double? stockPercent;

  /// Bond allocation percentage.
  final double? bondPercent;

  /// Cash allocation amount.
  final double? cashTotal;

  /// Selected package quantity.
  final double? packQty;

  /// Selected/current package amount.
  final double? packAmount;

  /// Package fee amount.
  final double? packFee;

  /// Optional backend description.
  final String? description;

  /// Securities included in the portfolio.
  final List<PortfolioSecurity> security;

  /// Current package details.
  final PortfolioPackDetail? packDetail;

  /// Creates a portfolio overview domain model.
  const PortfolioOverview({
    this.responseCode,
    this.responseDesc,
    this.resultValue,
    required this.currency,
    this.availableBalance,
    this.investedBalance,
    this.profitOrLoss,
    this.yieldAmount,
    this.profitPercent,
    this.statementSummary,
    this.stockTotal,
    this.bondTotal,
    this.stockPercent,
    this.bondPercent,
    this.cashTotal,
    this.packQty,
    this.packAmount,
    this.packFee,
    this.description,
    this.security = const <PortfolioSecurity>[],
    this.packDetail,
  });

  /// Internal sentinel that lets [copyWith] distinguish omitted values from
  /// explicit null assignments.
  static const Object _sentinel = Object();

  /// Returns a copy of this overview.
  ///
  /// Nullable fields use sentinel parameters so callers can intentionally clear
  /// a value by passing `null`.
  PortfolioOverview copyWith({
    Object? responseCode = _sentinel,
    Object? responseDesc = _sentinel,
    Object? resultValue = _sentinel,
    String? currency,
    Object? availableBalance = _sentinel,
    Object? investedBalance = _sentinel,
    Object? profitOrLoss = _sentinel,
    Object? yieldAmount = _sentinel,
    Object? profitPercent = _sentinel,
    Object? statementSummary = _sentinel,
    Object? stockTotal = _sentinel,
    Object? bondTotal = _sentinel,
    Object? stockPercent = _sentinel,
    Object? bondPercent = _sentinel,
    Object? cashTotal = _sentinel,
    Object? packQty = _sentinel,
    Object? packAmount = _sentinel,
    Object? packFee = _sentinel,
    Object? description = _sentinel,
    Object? security = _sentinel,
    Object? packDetail = _sentinel,
  }) {
    return PortfolioOverview(
      responseCode: responseCode == _sentinel
          ? this.responseCode
          : responseCode as int?,
      responseDesc: responseDesc == _sentinel
          ? this.responseDesc
          : responseDesc as String?,
      resultValue: resultValue == _sentinel ? this.resultValue : resultValue,
      currency: currency ?? this.currency,
      availableBalance: availableBalance == _sentinel
          ? this.availableBalance
          : availableBalance as double?,
      investedBalance: investedBalance == _sentinel
          ? this.investedBalance
          : investedBalance as double?,
      profitOrLoss: profitOrLoss == _sentinel
          ? this.profitOrLoss
          : profitOrLoss as double?,
      yieldAmount: yieldAmount == _sentinel
          ? this.yieldAmount
          : yieldAmount as double?,
      profitPercent: profitPercent == _sentinel
          ? this.profitPercent
          : profitPercent as double?,
      statementSummary: statementSummary == _sentinel
          ? this.statementSummary
          : statementSummary as String?,
      stockTotal: stockTotal == _sentinel
          ? this.stockTotal
          : stockTotal as double?,
      bondTotal: bondTotal == _sentinel ? this.bondTotal : bondTotal as double?,
      stockPercent: stockPercent == _sentinel
          ? this.stockPercent
          : stockPercent as double?,
      bondPercent: bondPercent == _sentinel
          ? this.bondPercent
          : bondPercent as double?,
      cashTotal: cashTotal == _sentinel ? this.cashTotal : cashTotal as double?,
      packQty: packQty == _sentinel ? this.packQty : packQty as double?,
      packAmount: packAmount == _sentinel
          ? this.packAmount
          : packAmount as double?,
      packFee: packFee == _sentinel ? this.packFee : packFee as double?,
      description: description == _sentinel
          ? this.description
          : description as String?,
      security: security == _sentinel
          ? this.security
          : security as List<PortfolioSecurity>,
      packDetail: packDetail == _sentinel
          ? this.packDetail
          : packDetail as PortfolioPackDetail?,
    );
  }
}

/// Security allocation/detail row inside [PortfolioOverview].
class PortfolioSecurity {
  /// Backend security code.
  final String securityCode;

  /// First investment date.
  final DateTime? firstInvDate;

  /// First investment price.
  final double? firstPrice;

  /// Current market price.
  final double? currentPrice;

  /// Security yield/portfolio percentage.
  final double? percent;

  /// Quantity held.
  final double? qty;

  /// Currency code.
  final String? curCode;

  /// Portfolio allocation percentage, mutable because some services calculate
  /// it after parsing all securities.
  double? portfolioPercent;

  /// Percentage within the security type group.
  final double? typePercent;

  /// Backend security type.
  final String? securityType;

  /// Historical close prices for charts.
  final List<PortfolioClosePrice>? closePrices;

  /// Creates a security allocation/detail row.
  PortfolioSecurity({
    required this.securityCode,
    this.firstInvDate,
    this.firstPrice,
    this.currentPrice,
    this.percent,
    this.qty,
    this.curCode,
    this.portfolioPercent,
    this.typePercent,
    this.securityType,
    this.closePrices,
  });
}

/// Historical close price point for a security chart.
class PortfolioClosePrice {
  /// Close price value.
  final double closePrice;

  /// Trade date for the close price.
  final DateTime? tradeDate;

  /// Creates a historical close price point.
  const PortfolioClosePrice({
    required this.closePrice,
    this.tradeDate,
  });
}

/// Investment package details embedded in portfolio overview.
class PortfolioPackDetail {
  /// Whether this pack is backend-recommended.
  final bool? isRecommended;

  /// Package code.
  final String? packCode;

  /// Primary package name.
  final String? name;

  /// Secondary/localized package name.
  final String? name2;

  /// Package description.
  final String? packDesc;

  /// Bond allocation percentage.
  final double? bondPercent;

  /// Stock allocation percentage.
  final double? stockPercent;

  /// Creates embedded package details for portfolio overview.
  const PortfolioPackDetail({
    this.isRecommended,
    this.packCode,
    this.name,
    this.name2,
    this.packDesc,
    this.bondPercent,
    this.stockPercent,
  });
}
