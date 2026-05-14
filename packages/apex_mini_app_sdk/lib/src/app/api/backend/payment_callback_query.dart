import 'package:mini_app_sdk/mini_app_sdk.dart';

class PaymentCallbackQuery {
  final String uuid;

  PaymentCallbackQuery({required String uuid}) : uuid = uuid.trim() {
    if (this.uuid.isEmpty) {
      throw const ApiIntegrationException('paymentCallback requires a non-empty invoiceId.');
    }
  }

  Map<String, Object?> toQueryParameters() {
    return <String, Object?>{'invoice_id': uuid};
  }
}
