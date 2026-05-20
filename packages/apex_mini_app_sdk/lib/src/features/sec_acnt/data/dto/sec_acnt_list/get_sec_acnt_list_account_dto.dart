part of '../get_sec_acnt_list_res_dto.dart';

/// Account row returned by the securities account list endpoint.
///
/// A single response can include multiple account types. The `flag` value is
/// used by [GetSecuritiesAcntListResDto] to identify securities, IPS master,
/// and IPS CASA accounts.
class GetSecAcntListAccountDto {
  /// Display name for the account.
  final String? name;

  /// Bank code associated with this account.
  final String? bankCode;

  /// Bank name associated with this account.
  final String? bankName;

  /// Broker identifier.
  final String? brokerId;

  /// Account code used in downstream APIs.
  final String? acntCode;

  /// Numeric account identifier.
  final int? acntId;

  /// Current balance.
  final double? balance;

  /// Currency or symbol value returned by the backend.
  final String? symbol;

  /// Backend account type flag.
  final int? flag;

  /// Backend account status code.
  final int? status;

  /// Account prefix.
  final String? prefix;

  /// Active money amount.
  final double? activeMoney;

  /// Nominal fee rows.
  final List<NominalListResDto>? nominalList;

  /// Available balance amount.
  final double? availableBalance;

  /// Securities account code.
  final String? scAcntCode;

  /// Nominal amount.
  final double? nominal;

  /// Ownership flag.
  final int? isOwn;

  /// Maximum statement day range returned by backend.
  final String? statementMaxDay;

  /// QR payload associated with this account.
  final String? qrCode;

  /// Whether this row is the main account.
  final bool isMain;

  /// Whether this row is informational only.
  final bool isInfo;

  /// Whether account/payment has been paid.
  final bool isPaid;

  /// Money request fee amount.
  final double? moneyReqFeeAmt;

  /// Securities commission/fee value.
  final num? scFee;

  /// Buy fee value.
  final num? buyXocFee;

  /// Sell fee value.
  final num? sellXocFee;

  /// Detailed balance rows.
  final List<BalancesDto>? balances;

  /// Compact balance rows.
  final List<BalsDto>? bals;

  /// Customer id.
  final int? custId;

  /// Instrument code.
  final String? instrumentCode;

  /// Market code.
  final String? marketCode;

  /// Transaction availability flag.
  final int? canTxn;

  /// Nominal account code.
  final String? nominalAcntCode;

  /// Security type code.
  final String? secType;

  /// Security type display name.
  final String? secTypeName;

  /// Creates an account row DTO.
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

  /// Parses a securities account row.
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

  /// Returns a copy with selected fields replaced.
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
