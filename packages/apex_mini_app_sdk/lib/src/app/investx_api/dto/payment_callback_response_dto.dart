import '../../../core/exception/api_exception.dart';

import '../../../core/api/api_parser.dart';

class PaymentCallbackResponseDto {
  final String? message;
  final String body;

  const PaymentCallbackResponseDto({required this.body, this.message});

  factory PaymentCallbackResponseDto.fromJson(Map<String, Object?> json) {
    final String? body = ApiParser.asNullableString(json['body']);
    if (body == null) {
      throw ApiParsingException(ApiParser.asNullableString(json['message']) ?? 'paymentCallback returned success without a body payload.');
    }

    return PaymentCallbackResponseDto(
      message: ApiParser.asNullableString(json['message']),
      body: body,
    );
  }
}
