import '../../../../../core/exception/api_exception.dart';

import '../../../../../core/api/api_parser.dart';

class GetSecuritiesAccountListResDto {
  final GetSecAcntListDetailDto detail;
  final List<GetSecAcntListAccountDto> acnts;
  final List<GetSecAcntSettlementAccountDto> stlAcnts;
  final int responseCode;
  final String? responseDesc;

  const GetSecuritiesAccountListResDto({
    required this.detail,
    required this.acnts,
    required this.stlAcnts,
    required this.responseCode,
    this.responseDesc,
  });

  factory GetSecuritiesAccountListResDto.fromJson(Map<String, Object?> json) {
    final int responseCode = ApiParser.asNullableInt(json['responseCode']) ?? 1;
    final String? responseDesc = ApiParser.asNullableString(
      json['responseDesc'],
    );
    if (responseCode != 0) {
      throw ApiBusinessException(
        responseCode: responseCode,
        message: responseDesc ?? 'Failed to load securities account list.',
      );
    }

    return GetSecuritiesAccountListResDto(
      detail: GetSecAcntListDetailDto.fromJson(
        ApiParser.asObjectMap(json['detail']),
      ),
      acnts: ApiParser.asObjectMapList(
        json['acnts'],
      ).map(GetSecAcntListAccountDto.fromJson).toList(growable: false),
      stlAcnts: ApiParser.asObjectMapList(
        json['stlAcnts'],
      ).map(GetSecAcntSettlementAccountDto.fromJson).toList(growable: false),
      responseCode: responseCode,
      responseDesc: responseDesc,
    );
  }

  GetSecuritiesAccountListResDto copyWith({
    GetSecAcntListDetailDto? detail,
    List<GetSecAcntListAccountDto>? acnts,
    List<GetSecAcntSettlementAccountDto>? stlAcnts,
    int? responseCode,
    String? responseDesc,
  }) {
    return GetSecuritiesAccountListResDto(
      detail: detail ?? this.detail,
      acnts: acnts ?? this.acnts,
      stlAcnts: stlAcnts ?? this.stlAcnts,
      responseCode: responseCode ?? this.responseCode,
      responseDesc: responseDesc ?? this.responseDesc,
    );
  }

  // bool get hasAcnt => detail.hasAcnt;

  // bool get hasIpsAcnt => detail.hasIpsAcnt;

  // List<GetSecAcntListAccountDto> get accounts => acnts;
  //
  // List<GetSecAcntSettlementAccountDto> get settlementAccounts => stlAcnts;
  //
  GetSecAcntListAccountDto? get securitiesAccount => accountByFlag(3);

  GetSecAcntListAccountDto? get ipsMasterAccount => accountByFlag(11);

  GetSecAcntListAccountDto? get ipsCasaAccount => accountByFlag(12);

  //
  GetSecAcntListAccountDto? get primaryAccount =>
      securitiesAccount ?? ipsCasaAccount ?? ipsMasterAccount ?? firstAccount;

  //
  GetSecAcntListAccountDto? get firstAccount =>
      acnts.isEmpty ? null : acnts.first;

  GetSecAcntListAccountDto? accountByFlag(int flag) {
    for (final GetSecAcntListAccountDto account in acnts) {
      if (account.flag == flag) {
        return account;
      }
    }

    return null;
  }
}

class GetSecAcntListDetailDto {
  final bool hasAcnt;
  final bool hasIpsAcnt;
  final double? commission;
  final String? intro;
  final String? introIps;
  final String? info;
  final String? registerCode;
  final String? brokerCode;
  final String? verfType;
  final String? bankCode;
  final String? bankName;
  final String? toAcntCode;
  final String? toAcntName;
  final String? toAcntCurCode;
  final String? description;
  final String? toFiCode;
  final String? toFiName;
  final String? qrCode;
  final String? verfStatus;
  final String? paymentStatus;
  final String? esignStatus;
  final bool hideBalance;
  final String? templateType;

  const GetSecAcntListDetailDto({
    required this.hasAcnt,
    required this.hasIpsAcnt,
    this.commission,
    this.intro,
    this.introIps,
    this.info,
    this.registerCode,
    this.brokerCode,
    this.verfType,
    this.bankCode,
    this.bankName,
    this.toAcntCode,
    this.toAcntName,
    this.toAcntCurCode,
    this.description,
    this.toFiCode,
    this.toFiName,
    this.qrCode,
    this.verfStatus,
    this.paymentStatus,
    this.esignStatus,
    this.hideBalance = false,
    this.templateType,
  });

  factory GetSecAcntListDetailDto.fromJson(Map<String, Object?> json) {
    return GetSecAcntListDetailDto(
      hasAcnt: ApiParser.asFlag(json['hasAcnt']),
      hasIpsAcnt: ApiParser.asFlag(json['hasIpsAcnt']),
      commission: ApiParser.asNullableDouble(json['commission']),
      intro: ApiParser.asNullableString(json['intro']),
      introIps: ApiParser.asNullableString(json['introIps']),
      info: ApiParser.asNullableString(json['info']),
      registerCode: ApiParser.asNullableString(json['registerCode']),
      brokerCode: ApiParser.asNullableString(json['brokerCode']),
      verfType: ApiParser.asNullableString(json['verfType']),
      bankCode: ApiParser.asNullableString(json['bankCode']),
      bankName: ApiParser.asNullableString(json['bankName']),
      toAcntCode: ApiParser.asNullableString(json['toAcntCode']),
      toAcntName: ApiParser.asNullableString(json['toAcntName']),
      toAcntCurCode: ApiParser.asNullableString(json['toAcntCurCode']),
      description: ApiParser.asNullableString(json['description']),
      toFiCode: ApiParser.asNullableString(json['toFiCode']),
      toFiName: ApiParser.asNullableString(json['toFiName']),
      qrCode: ApiParser.asNullableString(json['qrCode']),
      verfStatus: ApiParser.asNullableString(json['verfStatus']),
      paymentStatus: ApiParser.asNullableString(json['paymentStatus']),
      esignStatus: ApiParser.asNullableString(json['esignStatus']),
      hideBalance: ApiParser.asFlag(json['hideBalance']),
      templateType: ApiParser.asNullableString(json['templateType']),
    );
  }
}

class GetSecAcntListAccountDto {
  final String? name;
  final String? bankCode;
  final String? bankName;
  final String? brokerId;
  final String? acntCode;
  final int? acntId;
  final double? balance;
  final String? symbol;
  final int? flag;
  final int? status;
  final String? prefix;
  final double? activeMoney;
  final List<NominalListResDto>? nominalList;
  final double? availableBalance;
  final String? scAcntCode;
  final double? nominal;
  final int? isOwn;
  final String? statementMaxDay;
  final String? qrCode;
  final bool isMain;
  final bool isInfo;
  final bool isPaid;
  final double? moneyReqFeeAmt;

  /// GetSecAcntBal Res
  final num? scFee;
  final num? buyXocFee;
  final num? sellXocFee;
  final List<BalancesDto>? balances;
  final List<BalsDto>? bals;
  final int? custId;
  final String? instrumentCode;
  final String? marketCode;
  final int? canTxn;
  final String? nominalAcntCode;
  final String? secType;
  final String? secTypeName;

  const GetSecAcntListAccountDto({
    this.name,
    this.bankCode,
    this.bankName,
    this.brokerId,
    this.acntCode,
    this.acntId,
    this.balance,
    this.symbol,
    this.flag,
    this.status,
    this.prefix,
    this.activeMoney,
    this.availableBalance,
    this.nominalList,
    this.scAcntCode,
    this.nominal,
    this.isOwn,
    this.statementMaxDay,
    this.qrCode,
    this.isMain = false,
    this.isInfo = false,
    this.isPaid = false,
    this.moneyReqFeeAmt,

    /// GetSecAcntBal Res
    this.scFee,
    this.buyXocFee,
    this.sellXocFee,
    this.balances,
    this.bals,
    this.custId,
    this.instrumentCode,
    this.marketCode,
    this.canTxn,
    this.nominalAcntCode,
    this.secType,
    this.secTypeName,
  });

  factory GetSecAcntListAccountDto.fromJson(Map<String, Object?> json) {
    return GetSecAcntListAccountDto(
      name: ApiParser.asNullableString(json['name']),
      bankCode: ApiParser.asNullableString(json['bankCode']),
      bankName: ApiParser.asNullableString(json['bankName']),
      brokerId: ApiParser.asNullableString(json['brokerId']),
      acntCode: ApiParser.asNullableString(json['acntCode']),
      acntId: ApiParser.asNullableInt(json['acntId']),
      balance: ApiParser.asNullableDouble(json['balance']),
      symbol: ApiParser.asNullableString(json['symbol']),
      flag: ApiParser.asNullableInt(json['flag']),
      status: ApiParser.asNullableInt(json['status']),
      prefix: ApiParser.asNullableString(json['prefix']),
      activeMoney: ApiParser.asNullableDouble(json['activeMoney']),
      availableBalance: ApiParser.asNullableDouble(json['availableBalance']),
      nominalList: ApiParser.asObjectMapList(
        json['nominalList'],
      ).map(NominalListResDto.fromJson).toList(growable: false),
      scAcntCode: ApiParser.asNullableString(json['scAcntCode']),
      nominal: ApiParser.asNullableDouble(json['nominal']),
      isOwn: ApiParser.asNullableInt(json['isOwn']),
      statementMaxDay: ApiParser.asNullableString(json['statementMaxDay']),
      qrCode: ApiParser.asNullableString(json['qrCode']),
      isMain: ApiParser.asFlag(json['main']),
      isInfo: ApiParser.asFlag(json['isInfo']),
      isPaid: ApiParser.asFlag(json['isPaid']),
      moneyReqFeeAmt: ApiParser.asNullableDouble(json['moneyReqFeeAmt']),

      /// GetSecAcntBal Res
      scFee: ApiParser.asNullableDouble(json['scFee']),
      buyXocFee: ApiParser.asNullableDouble(json['buyXocFee']),
      sellXocFee: ApiParser.asNullableDouble(json['sellXocFee']),
      balances: ApiParser.asObjectMapList(
        json['balances'],
      ).map(BalancesDto.fromJson).toList(growable: false),
      bals: ApiParser.asObjectMapList(
        json['bals'],
      ).map(BalsDto.fromJson).toList(growable: false),
      custId: ApiParser.asNullableInt(json['custId']),
      instrumentCode: ApiParser.asNullableString(json['instrumentCode']),
      marketCode: ApiParser.asNullableString(json['marketCode']),
      canTxn: ApiParser.asNullableInt(json['canTxn']),
      nominalAcntCode: ApiParser.asNullableString(json['nominalAcntCode']),
      secType: ApiParser.asNullableString(json['secType']),
      secTypeName: ApiParser.asNullableString(json['secTypeName']),
    );
  }

  GetSecAcntListAccountDto copyWith({
    String? name,
    String? bankCode,
    String? bankName,
    String? brokerId,
    String? acntCode,
    int? acntId,
    double? balance,
    String? symbol,
    int? flag,
    int? status,
    String? prefix,
    double? activeMoney,
    double? availableBalance,
    List<NominalListResDto>? nominalList,
    String? scAcntCode,
    double? nominal,
    int? isOwn,
    String? statementMaxDay,
    String? qrCode,
    bool? isMain,
    bool? isInfo,
    bool? isPaid,
    double? moneyReqFeeAmt,

    /// GetSecAcntBal Res
    num? scFee,
    num? buyXocFee,
    num? sellXocFee,
    List<BalancesDto>? balances,
    List<BalsDto>? bals,
    int? custId,
    String? instrumentCode,
    String? marketCode,
    int? canTxn,
    String? nominalAcntCode,
    String? secType,
    String? secTypeName,
  }) {
    return GetSecAcntListAccountDto(
      name: name ?? this.name,
      bankCode: bankCode ?? this.bankCode,
      bankName: bankName ?? this.bankName,
      brokerId: brokerId ?? this.brokerId,
      acntCode: acntCode ?? this.acntCode,
      acntId: acntId ?? this.acntId,
      balance: balance ?? this.balance,
      symbol: symbol ?? this.symbol,
      flag: flag ?? this.flag,
      status: status ?? this.status,
      prefix: prefix ?? this.prefix,
      activeMoney: activeMoney ?? this.activeMoney,
      availableBalance: availableBalance ?? this.availableBalance,
      nominalList: nominalList ?? this.nominalList,
      scAcntCode: scAcntCode ?? this.scAcntCode,
      nominal: nominal ?? this.nominal,
      isOwn: isOwn ?? this.isOwn,
      statementMaxDay: statementMaxDay ?? this.statementMaxDay,
      qrCode: qrCode ?? this.qrCode,
      isMain: isMain ?? this.isMain,
      isInfo: isInfo ?? this.isInfo,
      isPaid: isPaid ?? this.isPaid,
      moneyReqFeeAmt: moneyReqFeeAmt ?? this.moneyReqFeeAmt,

      /// GetSecAcntBal Res
      scFee: scFee ?? this.scFee,
      buyXocFee: buyXocFee ?? this.buyXocFee,
      sellXocFee: sellXocFee ?? this.sellXocFee,
      balances: balances ?? this.balances,
      bals: bals ?? this.bals,
      custId: custId ?? this.custId,
      instrumentCode: instrumentCode ?? this.instrumentCode,
      marketCode: marketCode ?? this.marketCode,
      canTxn: canTxn ?? this.canTxn,
      nominalAcntCode: nominalAcntCode ?? this.nominalAcntCode,
      secType: secType ?? this.secType,
      secTypeName: secTypeName ?? this.secTypeName,
    );
  }
}

class NominalListResDto {
  final String? brokerCode;
  final String? curCode;
  final num? nominalFee;

  const NominalListResDto({this.brokerCode, this.curCode, this.nominalFee});

  factory NominalListResDto.fromJson(Map<String, Object?> json) {
    return NominalListResDto(
      brokerCode: ApiParser.asNullableString(json['brokerCode']),
      curCode: ApiParser.asNullableString(json['curCode']),
      nominalFee: ApiParser.asNullableDouble(json['nominalFee']),
    );
  }
}

class BalancesDto {
  final String? balType;
  final num? amount;
  final String? curCode;

  const BalancesDto({this.balType, this.amount, this.curCode});

  factory BalancesDto.fromJson(Map<String, Object?> json) {
    return BalancesDto(
      balType: ApiParser.asNullableString(json['balType']),
      amount: ApiParser.asNullableDouble(json['amount']),
      curCode: ApiParser.asNullableString(json['curCode']),
    );
  }
}

class BalsDto {
  final String? balanceCode;
  final num? balance;

  const BalsDto({this.balanceCode, this.balance});

  factory BalsDto.fromJson(Map<String, Object?> json) {
    return BalsDto(
      balanceCode: ApiParser.asNullableString(json['balanceCode']),
      balance: ApiParser.asNullableDouble(json['balance']),
    );
  }
}

class GetSecAcntSettlementAccountDto {
  final String? payeeCode;
  final String? bkrType;
  final String? bkrMarket;
  final String? bkrAcntCur;
  final String? bkrFiCode;
  final String? bkrFiName;
  final String? bkrAcntType;
  final String? bkrAcntCode;
  final String? bkrAcntName;
  final bool isDefault;
  final String? txnDescTemp;

  const GetSecAcntSettlementAccountDto({
    this.payeeCode,
    this.bkrType,
    this.bkrMarket,
    this.bkrAcntCur,
    this.bkrFiCode,
    this.bkrFiName,
    this.bkrAcntType,
    this.bkrAcntCode,
    this.bkrAcntName,
    this.isDefault = false,
    this.txnDescTemp,
  });

  factory GetSecAcntSettlementAccountDto.fromJson(Map<String, Object?> json) {
    return GetSecAcntSettlementAccountDto(
      payeeCode: ApiParser.asNullableString(json['payeeCode']),
      bkrType: ApiParser.asNullableString(json['bkrType']),
      bkrMarket: ApiParser.asNullableString(json['bkrMarket']),
      bkrAcntCur: ApiParser.asNullableString(json['bkrAcntCur']),
      bkrFiCode: ApiParser.asNullableString(json['bkrFiCode']),
      bkrFiName: ApiParser.asNullableString(json['bkrFiName']),
      bkrAcntType: ApiParser.asNullableString(json['bkrAcntType']),
      bkrAcntCode: ApiParser.asNullableString(json['bkrAcntCode']),
      bkrAcntName: ApiParser.asNullableString(json['bkrAcntName']),
      isDefault: ApiParser.asFlag(json['isDefault']),
      txnDescTemp: ApiParser.asNullableString(json['txnDescTemp']),
    );
  }
}
