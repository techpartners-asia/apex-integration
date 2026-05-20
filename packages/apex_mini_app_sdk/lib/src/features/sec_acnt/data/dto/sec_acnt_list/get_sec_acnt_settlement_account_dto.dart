part of '../get_sec_acnt_list_res_dto.dart';

/// Settlement account row returned with securities account data.
class GetSecAcntSettlementAccountDto {
  /// Payee code.
  final String? payeeCode;

  /// Broker type.
  final String? bkrType;

  /// Broker market.
  final String? bkrMarket;

  /// Broker account currency.
  final String? bkrAcntCur;

  /// Broker financial institution code.
  final String? bkrFiCode;

  /// Broker financial institution name.
  final String? bkrFiName;

  /// Broker account type.
  final String? bkrAcntType;

  /// Broker account code.
  final String? bkrAcntCode;

  /// Broker account name.
  final String? bkrAcntName;

  /// Whether this settlement account is the default choice.
  final bool isDefault;

  /// Transaction description template.
  final String? txnDescTemp;

  /// Creates a settlement account DTO.
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

  /// Parses a settlement account row from backend JSON.
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
