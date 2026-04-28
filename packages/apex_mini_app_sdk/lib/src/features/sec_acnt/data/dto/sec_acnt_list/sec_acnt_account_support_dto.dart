part of '../get_sec_acnt_list_res_dto.dart';

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
