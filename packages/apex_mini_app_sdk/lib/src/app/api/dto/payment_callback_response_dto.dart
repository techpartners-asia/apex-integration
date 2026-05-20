import 'package:apex_mini_app_sdk/apex_mini_app_sdk.dart';

/// Response DTO for payment callback/status checks.
class PaymentCallbackResponseDto {
  /// Optional backend message.
  final String? message;

  /// Callback body/status value.
  final String body;

  /// Creates a payment callback response DTO.
  const PaymentCallbackResponseDto({required this.body, this.message});

  /// Parses and validates the payment callback response.
  factory PaymentCallbackResponseDto.fromJson(Map<String, Object?> json) {
    final String? body = ApiParser.asNullableString(json['body']);
    if (body == null) {
      throw ApiParsingException(
        ApiParser.asNullableString(json['message']) ??
            'paymentCallback returned success without a body payload.',
      );
    }

    return PaymentCallbackResponseDto(
      message: ApiParser.asNullableString(json['message']),
      body: body,
    );
  }
}
