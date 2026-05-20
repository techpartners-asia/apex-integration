import 'package:apex_mini_app_sdk/apex_mini_app_sdk.dart';

/// Request body for creating a payment invoice.
///
/// The constructor validates the host/payment integration contract before the
/// request reaches the repository layer so invalid invoice calls fail with a
/// clear SDK integration error.
class CreateInvoiceApiReq {
  /// Amount to charge, normalized to a [double].
  final double amount;

  /// Human-readable note/reference text sent with the invoice request.
  final String note;

  /// Whether the invoice represents a transaction payment flow.
  final bool isTransaction;

  // final String? refId;

  /// Creates a validated invoice request.
  ///
  /// [amount] must be finite and greater than zero. [note] is trimmed and must
  /// not be empty because the backend uses it as payment context.
  CreateInvoiceApiReq({
    required num amount,
    required String note,
    required this.isTransaction,
    // this.refId = 'adsf',
  }) : amount = amount.toDouble(),
       note = note.trim() {
    if (!this.amount.isFinite || this.amount <= 0) {
      throw const ApiIntegrationException(
        'createInvoice requires a positive amount.',
      );
    }
    if (this.note.isEmpty) {
      throw const ApiIntegrationException(
        'createInvoice requires note and refId.',
      );
    }
  }

  /// Converts this invoice request into the backend payload.
  Map<String, Object?> toJson() {
    return <String, Object?>{
      'amount': amount,
      'note': note,
      'is_transaction': isTransaction,

      // 'ref_id': refId,
    };
  }
}
