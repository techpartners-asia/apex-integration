import 'package:apex_mini_app_sdk/apex_mini_app_sdk.dart';

/// DTO for the IPS portfolio overview/balance response.
class PortfolioOverviewDto {
  /// Backend response code.
  final int? responseCode;

  /// Backend response description.
  final String? responseDesc;

  /// Raw backend result value.
  final Object? resultValue;

  /// Display currency for portfolio amounts.
  final String currency;

  /// Total invested value derived from stock and bond totals.
  final double? investedBalance;

  /// Profit or loss amount, when supplied by backend.
  final double? profitOrLoss;

  /// Yield amount, when supplied by backend.
  final double? yieldAmount;

  /// Total stock allocation value.
  final double? stockTotal;

  /// Total bond allocation value.
  final double? bondTotal;

  /// Stock allocation percentage.
  final double? stockPercent;

  /// Bond allocation percentage.
  final double? bondPercent;

  /// Cash allocation value.
  final double? cashTotal;

  /// Current investment pack quantity.
  final double? packQty;

  /// Unit pack amount used by purchase flows.
  final double? packAmount;

  /// Pack purchase fee.
  final double? packFee;

  /// Backend-provided portfolio description.
  final String? description;

  /// Security rows included in the overview response.
  final List<PortfolioSecurityDto> security;

  /// Pack metadata included with overview response.
  final PortfolioPackDetailDto? packDetail;

  /// Optional statement summary text.
  final String? statementSummary;

  /// Creates a portfolio overview DTO.
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

  /// Parses backend balance data and normalizes nested security/pack payloads.
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

  /// Converts the backend-shaped DTO into the domain model used by screens.
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

/// DTO for a security entry inside the portfolio overview response.
class PortfolioSecurityDto {
  /// Backend security code.
  final String securityCode;

  /// First investment date for this security.
  final DateTime? firstInvDate;

  /// First purchase/investment price.
  final double? firstPrice;

  /// Current market price.
  final double? currentPrice;

  /// Yield/price percentage from backend.
  final double? percent;

  /// Quantity held.
  final double? qty;

  /// Currency code for this security.
  final String? curCode;

  /// Percentage of total portfolio.
  final double? portfolioPercent;

  /// Percentage inside the security type group.
  final double? typePercent;

  /// Backend security type.
  final String? securityType;

  /// Historical close prices for charts.
  final List<PortfolioClosePriceDto>? closePrices;

  /// Creates a portfolio security DTO.
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

  /// Parses a single portfolio security row with safe numeric/date conversion.
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

  /// Converts this security row into the shared portfolio domain model.
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

/// DTO for historical close-price data used by security charts.
class PortfolioClosePriceDto {
  /// Historical close price.
  final double closePrice;

  /// Trade date for this close-price point.
  final DateTime? tradeDate;

  /// Creates a close-price point DTO.
  const PortfolioClosePriceDto({required this.closePrice, this.tradeDate});

  /// Parses a close-price point, defaulting missing prices to zero.
  factory PortfolioClosePriceDto.fromJson(Map<String, Object?> json) {
    return PortfolioClosePriceDto(
      closePrice: ApiParser.asNullableDouble(json['closePrice']) ?? 0,
      tradeDate: ApiParser.asNullableDateTime(json['tradeDate']),
    );
  }

  /// Converts the chart point into its domain representation.
  PortfolioClosePrice toDomain() {
    return PortfolioClosePrice(
      closePrice: closePrice,
      tradeDate: tradeDate,
    );
  }
}

/// DTO for recommended/selected pack details in the portfolio response.
class PortfolioPackDetailDto {
  /// Whether backend marks this pack as recommended.
  final bool? isRecommended;

  /// Pack code.
  final String? packCode;

  /// Primary pack name.
  final String? name;

  /// Secondary/localized pack name.
  final String? name2;

  /// Pack description.
  final String? packDesc;

  /// Bond allocation percentage.
  final double? bondPercent;

  /// Stock allocation percentage.
  final double? stockPercent;

  /// Creates a portfolio pack detail DTO.
  const PortfolioPackDetailDto({
    this.isRecommended,
    this.packCode,
    this.name,
    this.name2,
    this.packDesc,
    this.bondPercent,
    this.stockPercent,
  });

  /// Parses optional pack metadata returned beside portfolio totals.
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

  /// Converts pack detail data into the domain model used by summary cards.
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

/// DTO for holdings returned by the yield/profit and stock-yield endpoints.
class PortfolioHoldingDto {
  /// Source endpoint/type that produced this holding row.
  final HoldingType holdingType;

  /// Raw result value from the backend row.
  final Object? resultValue;

  /// Security display name.
  final String securityName;

  /// Security symbol/code.
  final String? symbol;

  /// Normalized asset type.
  final HoldingAssetType? assetType;

  /// getStockAcntYieldDtl
  /// Security code returned by the stock-yield endpoint.
  final String? securityCode;

  /// Current value returned by the stock-yield endpoint.
  final double? currentValue;

  /// Investment value returned by the stock-yield endpoint.
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
  /// Account code returned by the yield/profit endpoint.
  final String? acntCode;

  /// Quantity from the yield/profit endpoint.
  final double? qty;

  /// Buy amount.
  final double? buyAmount;

  /// Buy fee amount.
  final double? buyFeeAmt;

  /// Sell amount.
  final double? sellAmount;

  /// Sell fee amount.
  final double? sellFeeAmt;

  /// Average buy price.
  final double? buyAvg;

  /// Average sell price.
  final double? sellAvg;

  /// Customer code.
  final String? custCode;

  /// Account balance/quantity fallback.
  final double? balance;

  /// Profit amount.
  final double? profit;

  /// Profit percentage.
  final double? profitPercent;

  /// Creates a portfolio holding DTO.
  const PortfolioHoldingDto({
    required this.holdingType,
    this.resultValue,
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
    this.qty,
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

  /// Parses a holding row from `getAcntYieldProfit`.
  factory PortfolioHoldingDto.fromYieldProfitJson(Map<String, Object?> json) {
    final String? symbol = ApiParser.asNullableString(json['symbol']);
    final double? qty = ApiParser.asNullableDouble(json['qty']);
    final double? buyAmount = ApiParser.asNullableDouble(json['buyAmount']);
    final double? sellAmount = ApiParser.asNullableDouble(json['sellAmount']);

    return PortfolioHoldingDto(
      holdingType: HoldingType.getAcntYieldProfit,
      resultValue: json['resultValue'],
      acntCode: ApiParser.asNullableString(json['acntCode']),
      securityCode: symbol,
      securityName:
          ApiParser.asNullableString(json['securityName']) ??
          IpsDefaults.unknownSecurityName,
      qty: qty,
      buyAmount: buyAmount,
      buyFeeAmt: ApiParser.asNullableDouble(json['buyFeeAmt']),
      sellAmount: sellAmount,
      sellFeeAmt: ApiParser.asNullableDouble(json['sellFeeAmt']),
      buyAvg: ApiParser.asNullableDouble(json['buyAvg']),
      sellAvg: ApiParser.asNullableDouble(json['sellAvg']),
      custCode: ApiParser.asNullableString(json['custCode']) ?? '',
      balance: ApiParser.asNullableDouble(json['balance']) ?? qty,
      currentValue: sellAmount ?? buyAmount,
      investmentValue: buyAmount,
      profit: ApiParser.asNullableDouble(json['profit']),
      profitPercent: ApiParser.asNullableDouble(json['profitPercent']),
      symbol: symbol,
      assetType: HoldingAssetType.stock,
    );
  }

  /// Parses a holding row from `getStockAcntYieldDtl`.
  factory PortfolioHoldingDto.fromStockYieldDtlJson(Map<String, Object?> json) {
    return PortfolioHoldingDto(
      holdingType: HoldingType.getStockAcntYieldDtl,
      securityCode:
          ApiParser.asNullableString(json['securityCode']) ??
          IpsDefaults.unknownSecurityCode,
      securityName:
          ApiParser.asNullableString(json['securityName']) ??
          IpsDefaults.unknownSecurityName,
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

  /// Extracts holding rows from the full yield/profit backend response.
  static List<PortfolioHoldingDto> listFromYieldProfitResponse(
    Map<String, Object?> json,
  ) {
    return PortfolioYieldProfitResponseDto.fromJson(json).profit;
  }

  /// Extracts stock-yield rows whether the backend returns one object or a list.
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
          .map(PortfolioHoldingDto.fromStockYieldDtlJson)
          .toList(growable: false);
    }

    final Map<String, Object?> yieldData = ApiParser.asObjectMap(rawYield);
    if (yieldData.isEmpty) {
      return const <PortfolioHoldingDto>[];
    }

    return <PortfolioHoldingDto>[
      PortfolioHoldingDto.fromStockYieldDtlJson(yieldData),
    ];
  }

  /// Converts the mixed-source DTO into one unified holding domain model.
  PortfolioHolding toDomain() {
    return PortfolioHolding(
      holdingType: holdingType,
      resultValue: resultValue,
      securityCode: securityCode ?? '',
      securityName: securityName,
      assetType: assetType,
      symbol: symbol ?? '',

      /// getStockAcntYieldDtl
      quantity: qty ?? balance ?? 0,
      currentValue: currentValue,
      investmentValue: investmentValue,
      todaysYield: todaysYield,
      totalYield: totalYield,
      totalPercent: totalPercent,
      todaysPercent: todaysPercent,

      /// getAcntYieldProfit
      acntCode: acntCode ?? '',
      buyAmount: buyAmount,
      buyFeeAmt: buyFeeAmt,
      sellAmount: sellAmount,
      sellFeeAmt: sellFeeAmt,
      buyAvg: buyAvg,
      sellAvg: sellAvg,
      custCode: custCode ?? '',
      balance: balance,
      profit: profit,
      profitPercent: profitPercent,
    );
  }

  /// Serializes the DTO for debug/test snapshots.
  Map<String, Object?> toJson() {
    return <String, Object?>{
      'resultValue': resultValue,
      'securityCode': securityCode,
      'securityName': securityName,
      'symbol': symbol,
      'currentValue': currentValue,
      'investmentValue': investmentValue,
      'todaysYield': todaysYield,
      'totalYield': totalYield,
      'totalPercent': totalPercent,
      'todaysPercent': todaysPercent,
      'acntCode': acntCode,
      'qty': qty,
      'buyAmount': buyAmount,
      'buyFeeAmt': buyFeeAmt,
      'sellAmount': sellAmount,
      'sellFeeAmt': sellFeeAmt,
      'buyAvg': buyAvg,
      'sellAvg': sellAvg,
      'custCode': custCode,
      'balance': balance,
      'profit': profit,
      'profitPercent': profitPercent,
    };
  }
}

/// DTO for the full yield/profit response.
class PortfolioYieldProfitResponseDto {
  /// Backend response code.
  final int? responseCode;

  /// Backend response description.
  final String? responseDesc;

  /// Raw backend result value.
  final Object? resultValue;

  /// Total investment value.
  final double? investmentValue;

  /// Total profit amount.
  final double? totalProfit;

  /// Holding rows returned under the backend `profit` key.
  final List<PortfolioHoldingDto> profit;

  /// Creates a yield-profit response DTO.
  const PortfolioYieldProfitResponseDto({
    this.responseCode,
    this.responseDesc,
    this.resultValue,
    this.investmentValue,
    this.totalProfit,
    this.profit = const <PortfolioHoldingDto>[],
  });

  /// Parses yield/profit totals and holding rows after validating success.
  factory PortfolioYieldProfitResponseDto.fromJson(Map<String, Object?> json) {
    ApiActionResultParser.ensureSuccess(
      json,
      fallbackErrorMessage: 'Yield/profit req failed.',
      strictResponseCode: true,
    );

    return PortfolioYieldProfitResponseDto(
      responseCode: ApiParser.asNullableInt(json['responseCode']),
      responseDesc: ApiParser.asNullableString(json['responseDesc']),
      resultValue: json['resultValue'],
      investmentValue: ApiParser.asNullableDouble(json['investmentValue']),
      totalProfit: ApiParser.asNullableDouble(json['totalProfit']),
      profit: ApiParser.asObjectMapList(
        json['profit'],
      ).map(PortfolioHoldingDto.fromYieldProfitJson).toList(growable: false),
    );
  }

  /// Serializes the response for debug/test snapshots.
  Map<String, Object?> toJson() {
    return <String, Object?>{
      'responseCode': responseCode,
      'responseDesc': responseDesc,
      'resultValue': resultValue,
      'investmentValue': investmentValue,
      'totalProfit': totalProfit,
      'profit': profit
          .map((PortfolioHoldingDto item) => item.toJson())
          .toList(
            growable: false,
          ),
    };
  }
}

/// Lightweight DTO for showing a CASA statement date/balance summary.
class CasaStatementSummaryDto {
  /// Human-readable statement summary text.
  final String summary;

  /// Creates a CASA statement summary DTO.
  const CasaStatementSummaryDto({required this.summary});

  /// Builds a human-readable summary from the statement response.
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

  /// Returns the already formatted summary string.
  String toDomain() => summary;
}

/// Returns the sum only when at least one operand is present.
double? _sumIfAny(double? first, double? second) {
  if (first == null && second == null) {
    return null;
  }

  return (first ?? 0) + (second ?? 0);
}
