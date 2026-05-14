import 'package:mini_app_sdk/mini_app_sdk.dart';

class CreateInvoiceApiReq {
  final double amount;
  final String note;
  final bool isTransaction;
  // final String? refId;

  CreateInvoiceApiReq({
    required num amount,
    required String note,
    required this.isTransaction,
    // this.refId = 'adsf',
  }) : amount = amount.toDouble(),
       note = note.trim(){
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

  Map<String, Object?> toJson() {
    return <String, Object?>{
      'amount': amount,
      'note': note,
      'is_transaction': isTransaction,
      // 'ref_id': refId,
      
    };
  }
}
