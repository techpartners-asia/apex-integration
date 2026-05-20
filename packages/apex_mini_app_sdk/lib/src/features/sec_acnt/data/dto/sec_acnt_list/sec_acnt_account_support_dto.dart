part of '../get_sec_acnt_list_res_dto.dart';

/// Nominal fee item nested under an account row.
class NominalListResDto {
  /// Broker code.
  final String? brokerCode;

  /// Currency code.
  final String? curCode;

  /// Nominal fee amount.
  final num? nominalFee;

  /// Creates a nominal fee item.
  const NominalListResDto({this.brokerCode, this.curCode, this.nominalFee});

  /// Parses a nominal fee row.
  factory NominalListResDto.fromJson(Map<String, Object?> json) {
    return NominalListResDto(
      brokerCode: ApiParser.asNullableString(json['brokerCode']),
      curCode: ApiParser.asNullableString(json['curCode']),
      nominalFee: ApiParser.asNullableDouble(json['nominalFee']),
    );
  }
}

/// Balance item nested under an account row.
class BalancesDto {
  /// Balance type.
  final String? balType;

  /// Balance amount.
  final num? amount;

  /// Currency code.
  final String? curCode;

  /// Creates a balance item.
  const BalancesDto({this.balType, this.amount, this.curCode});

  /// Parses a balance row.
  factory BalancesDto.fromJson(Map<String, Object?> json) {
    return BalancesDto(
      balType: ApiParser.asNullableString(json['balType']),
      amount: ApiParser.asNullableDouble(json['amount']),
      curCode: ApiParser.asNullableString(json['curCode']),
    );
  }
}

/// Compact balance item nested under an account row.
class BalsDto {
  /// Balance code.
  final String? balanceCode;

  /// Balance amount.
  final num? balance;

  /// Creates a compact balance item.
  const BalsDto({this.balanceCode, this.balance});

  /// Parses a compact balance row.
  factory BalsDto.fromJson(Map<String, Object?> json) {
    return BalsDto(
      balanceCode: ApiParser.asNullableString(json['balanceCode']),
      balance: ApiParser.asNullableDouble(json['balance']),
    );
  }
}
