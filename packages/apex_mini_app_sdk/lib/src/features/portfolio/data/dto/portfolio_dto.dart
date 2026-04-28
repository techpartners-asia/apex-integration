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
      packDetail: packDetail.isEmpty
          ? null
          : PortfolioPackDetailDto.fromJson(packDetail),
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
      security: security
          .map((PortfolioSecurityDto item) => item.toDomain())
          .toList(growable: false),
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
      securityCode:
          ApiParser.asNullableString(json['securityCode']) ??
          IpsDefaults.unknownSecurityCode,
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
      closePrices: closePrices
          ?.map((PortfolioClosePriceDto item) => item.toDomain())
          .toList(growable: false),
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
      isRecommended: json.containsKey('isRecommended')
          ? ApiParser.asFlag(json['isRecommended'])
          : null,
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
  final String code;
  final String name;
  final double quantity;
  final double currentValue;
  final double? yieldPercent;
  final double? profitAmount;
  final HoldingAssetType? assetType;
  final String? pointLabel;
  final DateTime? recordedAt;

  const PortfolioHoldingDto({
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

  factory PortfolioHoldingDto.fromYieldProfitJson(Map<String, Object?> json) {
    return PortfolioHoldingDto(
      code:
          ApiParser.asNullableString(json['symbol']) ??
          IpsDefaults.unknownSecurityCode,
      name:
          ApiParser.asNullableString(json['securityName']) ??
          IpsDefaults.unknownSecurityName,
      quantity: ApiParser.asNullableDouble(json['balance']) ?? 0,
      currentValue: ApiParser.asNullableDouble(json['buyAmount']) ?? 0,
      yieldPercent: ApiParser.asNullableDouble(json['profitPercent']),
      profitAmount: ApiParser.asNullableDouble(json['profit']),
    );
  }

  factory PortfolioHoldingDto.fromStockYieldDetailJson(
    Map<String, Object?> json,
  ) {
    return PortfolioHoldingDto(
      code:
          ApiParser.asNullableString(json['securityCode']) ??
          IpsDefaults.unknownSecurityCode,
      name:
          ApiParser.asNullableString(json['securityName']) ??
          IpsDefaults.unknownSecurityName,
      quantity: ApiParser.asNullableDouble(json['investmentValue']) ?? 0,
      currentValue: ApiParser.asNullableDouble(json['currentValue']) ?? 0,
      yieldPercent: ApiParser.asNullableDouble(json['totalPercent']),
      profitAmount: ApiParser.asNullableDouble(json['totalYield']),
      assetType: HoldingAssetType.stock,
    );
  }

  static List<PortfolioHoldingDto> listFromYieldProfitResponse(
    Map<String, Object?> json,
  ) {
    ApiActionResultParser.ensureSuccess(
      json,
      fallbackErrorMessage: 'Yield/profit req failed.',
      strictResponseCode: true,
    );

    return ApiParser.asObjectMapList(
      json['profit'],
    ).map(PortfolioHoldingDto.fromYieldProfitJson).toList(growable: false);
  }

  static List<PortfolioHoldingDto> listFromStockYieldDetailResponse(
    Map<String, Object?> json,
  ) {
    ApiActionResultParser.ensureSuccess(
      json,
      fallbackErrorMessage: 'Stock yield detail req failed.',
      strictResponseCode: true,
    );

    final Object? rawYield = json['yield'];

    final List<Map<String, Object?>> yieldList = ApiParser.asObjectMapList(
      rawYield,
    );
    if (yieldList.isNotEmpty) {
      return yieldList
          .map(PortfolioHoldingDto.fromStockYieldDetailJson)
          .toList(growable: false);
    }

    final Map<String, Object?> yieldData = ApiParser.asObjectMap(rawYield);
    if (yieldData.isEmpty) {
      return const <PortfolioHoldingDto>[];
    }

    return <PortfolioHoldingDto>[
      PortfolioHoldingDto.fromStockYieldDetailJson(yieldData),
    ];
  }

  PortfolioHolding toDomain() {
    return PortfolioHolding(
      code: code,
      name: name,
      quantity: quantity,
      currentValue: currentValue,
      yieldPercent: yieldPercent,
      profitAmount: profitAmount,
      assetType: assetType,
      pointLabel: pointLabel,
      recordedAt: recordedAt,
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

    final String beginBalance =
        ApiParser.asNullableString(json['beginBalance']) ?? '0';
    final String endBalance =
        ApiParser.asNullableString(json['endBalance']) ?? '0';
    final String startDate =
        ApiParser.asNullableString(json['startDate']) ?? fallbackStartDate;
    final String endDate =
        ApiParser.asNullableString(json['endDate']) ?? fallbackEndDate;
    final int totalCount = ApiParser.asNullableInt(json['totalCount']) ?? 0;

    return CasaStatementSummaryDto(
      summary:
          '$startDate  $endDate • begin $beginBalance • end $endBalance • $totalCount entries',
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
