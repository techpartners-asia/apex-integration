import '../../../core/exception/api_exception.dart';

class CreateInvoiceApiReq {
  final double amount;
  final String note;
  final String refId;

  CreateInvoiceApiReq({
    required num amount,
    required String note,
    required String refId,
  }) : amount = amount.toDouble(),
       note = note.trim(),
       refId = refId.trim() {
    if (!this.amount.isFinite || this.amount <= 0) {
      throw const ApiIntegrationException('createInvoice requires a positive amount.');
    }
    if (this.note.isEmpty || this.refId.isEmpty) {
      throw const ApiIntegrationException('createInvoice requires note and refId.');
    }
  }

  Map<String, Object?> toJson() {
    return <String, Object?>{'amount': amount, 'note': note, 'ref_id': refId};
  }
}
