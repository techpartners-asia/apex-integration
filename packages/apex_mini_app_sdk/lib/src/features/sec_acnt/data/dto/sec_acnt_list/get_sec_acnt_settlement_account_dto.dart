part of '../get_sec_acnt_list_res_dto.dart';

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
