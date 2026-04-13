import '../../../core/exception/api_exception.dart';

class PaymentCallbackQuery {
  final String invoiceId;

  PaymentCallbackQuery({required String invoiceId})
    : invoiceId = invoiceId.trim() {
    if (this.invoiceId.isEmpty) {
      throw const ApiIntegrationException(
        'paymentCallback requires a non-empty invoiceId.',
      );
    }
  }

  Map<String, Object?> toQueryParameters() {
    return <String, Object?>{'invoice_id': invoiceId};
  }
}
