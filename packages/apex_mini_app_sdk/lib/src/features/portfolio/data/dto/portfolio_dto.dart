import 'package:mini_app_sdk/mini_app_sdk.dart';

class PortfolioOverviewDto {
  final int? responseCode;
  final String? responseDesc;
  final Object? resultValue;
  final String currency;
  final double? investedBalance;
  final double? profitOrLoss;
  final double? yieldAmount;
  final double? stockTotal;
  final double? bondTotal;
  final double? stockPercent;
  final double? bondPercent;
  final double? cashTotal;
  final double? packQty;
  final double? packAmount;
  final double? packFee;
  final String? description;
  final List<PortfolioSecurityDto> security;
  final PortfolioPackDetailDto? packDetail;
  final String? statementSummary;

  const PortfolioOverviewDto({
    this.responseCode,
    this.responseDesc,
    this.resultValue,
    required this.currency,
    this.investedBalance,
    this.profitOrLoss,
    this.yieldAmount,
    this.stockTotal,
    this.bondTotal,
    this.stockPercent,
    this.bondPercent,
    this.cashTotal,
    this.packQty,
    this.packAmount,
    this.packFee,
    this.description,
    this.security = const <PortfolioSecurityDto>[],
    this.packDetail,
    this.statementSummary,
  });

  factory PortfolioOverviewDto.fromJson(Map<String, Object?> json) {
    ApiActionResultParser.ensureSuccess(
      json,
      fallbackErrorMessage: 'IPS balance req failed.',
      strictResponseCode: true,
    );

    final Map<String, Object?> responseData = ApiParser.asObjectMap(
      json['responseData'],
    );
    final List<PortfolioSecurityDto> security = ApiParser.asObjectMapList(
      json['security'],
    ).map(PortfolioSecurityDto.fromJson).toList(growable: false);
    final Map<String, Object?> packDetail = ApiParser.asObjectMap(
      json['packDetail'],
    );
    final double? stockTotal = ApiParser.asNullableDouble(
      responseData['stockTotal'],
    );
    final double? bondTotal = ApiParser.asNullableDouble(
      responseData['bondTotal'],
    );
    final double? cashTotal = ApiParser.asNullableDouble(
      responseData['cashTotal'],
    );

    return PortfolioOverviewDto(
      responseCode: ApiParser.asNullableInt(json['responseCode']),
      responseDesc: ApiParser.asNullableString(json['responseDesc']),
      resultValue: json['resultValue'],
      currency: IpsDefaults.defaultCurrency,
      investedBalance: _sumIfAny(stockTotal, bondTotal),
      stockTotal: stockTotal,
      bondTotal: bondTotal,
      stockPercent: ApiParser.asNullableDouble(responseData['stockPercent']),
      bondPercent: ApiParser.asNullableDouble(responseData['bondPercent']),
      cashTotal: cashTotal,
      packQty: ApiParser.asNullableDouble(responseData['packQty']),
      packAmount: ApiParser.asNullableDouble(responseData['packAmount']),
      packFee: ApiParser.asNullableDouble(responseData['packFee']),
      description: ApiParser.asNullableString(responseData['description']),
      security: security,
      packDetail: packDetail.isEmpty ? null : PortfolioPackDetailDto.fromJson(packDetail),
    );
  }

  PortfolioOverview toDomain() {
    return PortfolioOverview(
      responseCode: responseCode,
      responseDesc: responseDesc,
      resultValue: resultValue,
      currency: currency,
      investedBalance: investedBalance,
      profitOrLoss: profitOrLoss,
      yieldAmount: yieldAmount,
      stockTotal: stockTotal,
      bondTotal: bondTotal,
      stockPercent: stockPercent,
      bondPercent: bondPercent,
      cashTotal: cashTotal,
      packQty: packQty,
      packAmount: packAmount,
      packFee: packFee,
      description: description,
      security: security.map((PortfolioSecurityDto item) => item.toDomain()).toList(growable: false),
      packDetail: packDetail?.toDomain(),
      statementSummary: statementSummary,
    );
  }
}

class PortfolioSecurityDto {
  final String securityCode;
  final DateTime? firstInvDate;
  final double? firstPrice;
  final double? currentPrice;
  final double? percent;
  final double? qty;
  final String? curCode;
  final double? portfolioPercent;
  final double? typePercent;
  final String? securityType;
  final List<PortfolioClosePriceDto>? closePrices;

  const PortfolioSecurityDto({
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

  factory PortfolioSecurityDto.fromJson(Map<String, Object?> json) {
    final Object? rawClosePrices = json['closePrices'];
    final List<PortfolioClosePriceDto>? closePrices;
    if (rawClosePrices == null) {
      closePrices = null;
    } else {
      closePrices = ApiParser.asObjectMapList(
        rawClosePrices,
      ).map(PortfolioClosePriceDto.fromJson).toList(growable: false);
    }

    return PortfolioSecurityDto(
      securityCode: ApiParser.asNullableString(json['securityCode']) ?? IpsDefaults.unknownSecurityCode,
      firstInvDate: ApiParser.asNullableDateTime(json['firstInvDate']),
      firstPrice: ApiParser.asNullableDouble(json['firstPrice']),
      currentPrice: ApiParser.asNullableDouble(json['currentPrice']),
      percent: ApiParser.asNullableDouble(json['percent']),
      qty: ApiParser.asNullableDouble(json['qty']),
      curCode: ApiParser.asNullableString(json['curCode']),
      portfolioPercent: ApiParser.asNullableDouble(json['portfolioPercent']),
      typePercent: ApiParser.asNullableDouble(json['typePercent']),
      securityType: ApiParser.asNullableString(json['securityType']),
      closePrices: closePrices,
    );
  }

  PortfolioSecurity toDomain() {
    return PortfolioSecurity(
      securityCode: securityCode,
      firstInvDate: firstInvDate,
      firstPrice: firstPrice,
      currentPrice: currentPrice,
      percent: percent,
      qty: qty,
      curCode: curCode,
      portfolioPercent: portfolioPercent,
      typePercent: typePercent,
      securityType: securityType,
      closePrices: closePrices?.map((PortfolioClosePriceDto item) => item.toDomain()).toList(growable: false),
    );
  }
}

class PortfolioClosePriceDto {
  final double closePrice;
  final DateTime? tradeDate;

  const PortfolioClosePriceDto({required this.closePrice, this.tradeDate});

  factory PortfolioClosePriceDto.fromJson(Map<String, Object?> json) {
    return PortfolioClosePriceDto(
      closePrice: ApiParser.asNullableDouble(json['closePrice']) ?? 0,
      tradeDate: ApiParser.asNullableDateTime(json['tradeDate']),
    );
  }

  PortfolioClosePrice toDomain() {
    return PortfolioClosePrice(
      closePrice: closePrice,
      tradeDate: tradeDate,
    );
  }
}

class PortfolioPackDetailDto {
  final bool? isRecommended;
  final String? packCode;
  final String? name;
  final String? name2;
  final String? packDesc;
  final double? bondPercent;
  final double? stockPercent;

  const PortfolioPackDetailDto({
    this.isRecommended,
    this.packCode,
    this.name,
    this.name2,
    this.packDesc,
    this.bondPercent,
    this.stockPercent,
  });

  factory PortfolioPackDetailDto.fromJson(Map<String, Object?> json) {
    return PortfolioPackDetailDto(
      isRecommended: json.containsKey('isRecommended') ? ApiParser.asFlag(json['isRecommended']) : null,
      packCode: ApiParser.asNullableString(json['packCode']),
      name: ApiParser.asNullableString(json['name']),
      name2: ApiParser.asNullableString(json['name2']),
      packDesc: ApiParser.asNullableString(json['packDesc']),
      bondPercent: ApiParser.asNullableDouble(json['bondPercent']),
      stockPercent: ApiParser.asNullableDouble(json['stockPercent']),
    );
  }

  PortfolioPackDetail toDomain() {
    return PortfolioPackDetail(
      isRecommended: isRecommended,
      packCode: packCode,
      name: name,
      name2: name2,
      packDesc: packDesc,
      bondPercent: bondPercent,
      stockPercent: stockPercent,
    );
  }
}

class PortfolioHoldingDto {
  final HoldingType holdingType;
  final String securityName;
  final String? symbol;
  final HoldingAssetType? assetType;

  /// getStockAcntYieldDtl
  final String? securityCode;
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

  const PortfolioHoldingDto({
    required this.holdingType,
    required this.securityName,
    this.symbol,
    this.assetType,

    /// getStockAcntYieldDtl
    this.securityCode,
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

  factory PortfolioHoldingDto.fromYieldProfitJson(Map<String, Object?> json) {
    return PortfolioHoldingDto(
      holdingType: HoldingType.getAcntYieldProfit,
      acntCode: ApiParser.asNullableString(json['acntCode']) ?? '',
      securityName: ApiParser.asNullableString(json['securityName']) ?? IpsDefaults.unknownSecurityName,
      buyAmount: ApiParser.asNullableDouble(json['buyAmount']) ?? 0,
      custCode: ApiParser.asNullableString(json['custCode']) ?? '',
      balance: ApiParser.asNullableDouble(json['balance']) ?? 0,
      profit: ApiParser.asNullableDouble(json['profit']) ?? 0,
      profitPercent: ApiParser.asNullableDouble(json['profitPercent']) ?? 0,
      symbol: ApiParser.asNullableString(json['symbol']) ?? '',
    );
  }

  factory PortfolioHoldingDto.fromStockYieldDtlJson(Map<String, Object?> json) {
    return PortfolioHoldingDto(
      holdingType: HoldingType.getStockAcntYieldDtl,
      securityCode: ApiParser.asNullableString(json['securityCode']) ?? IpsDefaults.unknownSecurityCode,
      securityName: ApiParser.asNullableString(json['securityName']) ?? IpsDefaults.unknownSecurityName,
      currentValue: ApiParser.asNullableDouble(json['currentValue']) ?? 0,
      investmentValue: ApiParser.asNullableDouble(json['currentValue']) ?? 0,
      todaysYield: ApiParser.asNullableDouble(json['todaysYield']) ?? 0,
      totalYield: ApiParser.asNullableDouble(json['totalYield']) ?? 0,
      totalPercent: ApiParser.asNullableDouble(json['totalPercent']) ?? 0,
      todaysPercent: ApiParser.asNullableDouble(json['todaysPercent']) ?? 0,
      symbol: ApiParser.asNullableString(json['symbol']) ?? '',
      assetType: HoldingAssetType.stock,
    );
  }

  static List<PortfolioHoldingDto> listFromYieldProfitResponse(Map<String, Object?> json) {
    ApiActionResultParser.ensureSuccess(
      json,
      fallbackErrorMessage: 'Yield/profit req failed.',
      strictResponseCode: true,
    );

    return ApiParser.asObjectMapList(json['profit']).map(PortfolioHoldingDto.fromYieldProfitJson).toList(growable: false);
  }

  static List<PortfolioHoldingDto> listFromStockYieldDetailResponse(Map<String, Object?> json) {
    ApiActionResultParser.ensureSuccess(
      json,
      fallbackErrorMessage: 'Stock yield detail req failed.',
      strictResponseCode: true,
    );

    final Object? rawYield = json['yield'];

    final List<Map<String, Object?>> yieldList = ApiParser.asObjectMapList(rawYield);
    if (yieldList.isNotEmpty) {
      return yieldList.map(PortfolioHoldingDto.fromStockYieldDtlJson).toList(growable: false);
    }

    final Map<String, Object?> yieldData = ApiParser.asObjectMap(rawYield);
    if (yieldData.isEmpty) {
      return const <PortfolioHoldingDto>[];
    }

    return <PortfolioHoldingDto>[
      PortfolioHoldingDto.fromStockYieldDtlJson(yieldData),
    ];
  }

  PortfolioHolding toDomain() {
    return PortfolioHolding(
      holdingType: holdingType,
      securityCode: securityCode ?? '',
      securityName: securityName,
      assetType: assetType,
      symbol: symbol ?? '',

      /// getStockAcntYieldDtl
      currentValue: currentValue,
      investmentValue: investmentValue,
      todaysYield: todaysYield,
      totalYield: totalYield,
      totalPercent: totalPercent,
      todaysPercent: todaysPercent,

      /// getAcntYieldProfit
      acntCode: acntCode ?? '',
      buyAmount: buyAmount,
      custCode: custCode ?? '',
      balance: balance,
      profit: profit,
      profitPercent: profitPercent,
    );
  }
}

class CasaStatementSummaryDto {
  final String summary;

  const CasaStatementSummaryDto({required this.summary});

  factory CasaStatementSummaryDto.fromJson(
    Map<String, Object?> json, {
    required String fallbackStartDate,
    required String fallbackEndDate,
  }) {
    ApiActionResultParser.ensureSuccess(
      json,
      fallbackErrorMessage: 'CASA statement req failed.',
      strictResponseCode: true,
    );

    final String beginBalance = ApiParser.asNullableString(json['beginBalance']) ?? '0';
    final String endBalance = ApiParser.asNullableString(json['endBalance']) ?? '0';
    final String startDate = ApiParser.asNullableString(json['startDate']) ?? fallbackStartDate;
    final String endDate = ApiParser.asNullableString(json['endDate']) ?? fallbackEndDate;
    final int totalCount = ApiParser.asNullableInt(json['totalCount']) ?? 0;

    return CasaStatementSummaryDto(
      summary: '$startDate  $endDate • begin $beginBalance • end $endBalance • $totalCount entries',
    );
  }

  String toDomain() => summary;
}

double? _sumIfAny(double? first, double? second) {
  if (first == null && second == null) {
    return null;
  }

  return (first ?? 0) + (second ?? 0);
}
