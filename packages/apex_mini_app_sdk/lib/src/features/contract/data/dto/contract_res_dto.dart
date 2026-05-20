import 'package:apex_mini_app_sdk/apex_mini_app_sdk.dart';

/// DTO for the broker customer contract creation response.
class ContractResDto {
  /// Backend contract/reference identifier.
  final String contractId;

  /// User-facing backend response message.
  final String message;

  /// Optional payment/deep-link target returned by the backend.
  final String? deepLink;

  /// Creates a parsed contract response DTO.
  const ContractResDto({
    required this.contractId,
    required this.message,
    this.deepLink,
  });

  /// Parses the contract response and throws for non-zero response codes.
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

  /// Converts this response into the contract domain model.
  ContractRes toDomain() {
    return ContractRes(contractId: contractId, message: message);
  }
}
