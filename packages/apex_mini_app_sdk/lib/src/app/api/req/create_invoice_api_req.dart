import 'package:mini_app_sdk/mini_app_sdk.dart';

class CreateInvoiceApiReq {
  final double amount;
  final String note;
  final String refId;
  final bool isTransaction;

  CreateInvoiceApiReq({
    required num amount,
    required String note,
    required String refId,
    required this.isTransaction,
  }) : amount = amount.toDouble(),
       note = note.trim(),
       refId = refId.trim() {
    if (!this.amount.isFinite || this.amount <= 0) {
      throw const ApiIntegrationException(
        'createInvoice requires a positive amount.',
      );
    }
    if (this.note.isEmpty || this.refId.isEmpty) {
      throw const ApiIntegrationException(
        'createInvoice requires note and refId.',
      );
    }
  }

  Map<String, Object?> toJson() {
    return <String, Object?>{
      'amount': amount,
      'note': note,
      'ref_id': refId,
      'is_transaction': isTransaction,
    };
  }
}
