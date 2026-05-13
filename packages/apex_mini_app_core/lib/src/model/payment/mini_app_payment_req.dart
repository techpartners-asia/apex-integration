enum MiniAppPaymentFlow { secAcntOpening, ipsRecharge }

class MiniAppPaymentReq {
  final MiniAppPaymentFlow flow;
  final String invoiceId;
  final double amount;
  final String note;
  final String refId;
  final int paymentRecordId;
  final String? externalInvoiceId;
  final String? uuid;
  final bool isTransaction;

  MiniAppPaymentReq({
    required this.flow,
    required this.invoiceId,
    required num amount,
    required this.note,
    required this.refId,
    required this.paymentRecordId,
    this.externalInvoiceId,
    this.uuid,
    required this.isTransaction,
  }) : amount = amount.toDouble();
}
