part of '../get_sec_acnt_list_res_dto.dart';

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
