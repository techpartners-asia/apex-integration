import 'package:apex_mini_app_sdk/apex_mini_app_sdk.dart';

/// Query parameters for checking payment callback status.
class PaymentCallbackQuery {
  /// Invoice/payment UUID.
  final String uuid;

  PaymentCallbackQuery({required String uuid}) : uuid = uuid.trim() {
    if (this.uuid.isEmpty) {
      throw const ApiIntegrationException(
        'paymentCallback requires a non-empty invoiceId.',
      );
    }
  }

  /// Converts this query to URL query parameters.
  Map<String, Object?> toQueryParameters() {
    return <String, Object?>{'invoice_id': uuid};
  }
}
