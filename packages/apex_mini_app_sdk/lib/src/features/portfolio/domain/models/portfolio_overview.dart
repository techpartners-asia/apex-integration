class PortfolioOverview {
  final int? responseCode;
  final String? responseDesc;
  final Object? resultValue;
  final String currency;
  final double? availableBalance;
  final double? investedBalance;
  final double? profitOrLoss;
  final double? yieldAmount;
  final double? profitPercent;
  final String? statementSummary;
  final double? stockTotal;
  final double? bondTotal;
  final double? stockPercent;
  final double? bondPercent;
  final double? cashTotal;
  final double? packQty;
  final double? packAmount;
  final double? packFee;
  final String? description;
  final List<PortfolioSecurity> security;
  final PortfolioPackDetail? packDetail;

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

  static const Object _sentinel = Object();

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

class PortfolioSecurity {
  final String securityCode;
  final DateTime? firstInvDate;
  final double? firstPrice;
  final double? currentPrice;
  final double? percent;
  final double? qty;
  final String? curCode;
  double? portfolioPercent;
  final double? typePercent;
  final String? securityType;
  final List<PortfolioClosePrice>? closePrices;

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

class PortfolioClosePrice {
  final double closePrice;
  final DateTime? tradeDate;

  const PortfolioClosePrice({
    required this.closePrice,
    this.tradeDate,
  });
}

class PortfolioPackDetail {
  final bool? isRecommended;
  final String? packCode;
  final String? name;
  final String? name2;
  final String? packDesc;
  final double? bondPercent;
  final double? stockPercent;

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
