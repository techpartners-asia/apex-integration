import 'payment_entity_dto.dart';
import '../../../core/exception/api_exception.dart';

import '../../../core/api/api_parser.dart';
import '../models/mini_app_payment.dart';

class CreateInvoiceResponseDto {
  final String? message;
  final PaymentEntityDto payment;

  const CreateInvoiceResponseDto({required this.payment, this.message});

  factory CreateInvoiceResponseDto.fromJson(Map<String, Object?> json) {
    final Map<String, Object?> body = ApiParser.asObjectMap(json['body']);
    if (body.isEmpty) {
      throw ApiParsingException(ApiParser.asNullableString(json['message']) ?? 'createInvoice returned success without a body payload.');
    }

    return CreateInvoiceResponseDto(
      message: ApiParser.asNullableString(json['message']),
      payment: PaymentEntityDto.fromJson(body),
    );
  }

  MiniAppPayment toDomain() => payment.toDomain();
}
