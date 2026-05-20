import 'package:apex_mini_app_sdk/apex_mini_app_sdk.dart';

/// Response DTO for invoice creation.
class CreateInvoiceResponseDto {
  /// Optional backend message.
  final String? message;

  /// Created payment payload.
  final PaymentEntityDto payment;

  /// Creates a create-invoice response DTO.
  const CreateInvoiceResponseDto({required this.payment, this.message});

  /// Parses and validates the invoice response body.
  factory CreateInvoiceResponseDto.fromJson(Map<String, Object?> json) {
    final Map<String, Object?> body = ApiParser.asObjectMap(json['body']);
    if (body.isEmpty) {
      throw ApiParsingException(
        ApiParser.asNullableString(json['message']) ??
            'createInvoice returned success without a body payload.',
      );
    }

    return CreateInvoiceResponseDto(
      message: ApiParser.asNullableString(json['message']),
      payment: PaymentEntityDto.fromJson(body),
    );
  }

  /// Converts this response to the domain payment model.
  MiniAppPayment toDomain() => payment.toDomain();
}
