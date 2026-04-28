import 'package:mini_app_sdk/mini_app_sdk.dart';

class ContractResDto {
  final String contractId;
  final String message;
  final String? deepLink;

  const ContractResDto({
    required this.contractId,
    required this.message,
    this.deepLink,
  });

  factory ContractResDto.fromJson(Map<String, Object?> json) {
    final int responseCode = ApiParser.asNullableInt(json['responseCode']) ?? 1;

    if (responseCode != 0) {
      throw ApiBusinessException(
        responseCode: responseCode,
        message:
            ApiParser.asNullableString(json['responseDesc']) ??
            'Contract creation failed.',
      );
    }

    return ContractResDto(
      contractId:
          ApiParser.asNullableString(json['refNo']) ??
          IpsDefaults.contractIdFallback,
      message:
          ApiParser.asNullableString(json['responseDesc']) ??
          'IPS contract created.',
      deepLink: ApiParser.asNullableString(json['deepLink']),
    );
  }

  ContractRes toDomain() {
    return ContractRes(contractId: contractId, message: message);
  }
}
