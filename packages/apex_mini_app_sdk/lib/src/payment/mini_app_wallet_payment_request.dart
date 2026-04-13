enum MiniAppWalletPaymentFlow { secAcntOpening, ipsRecharge }

class MiniAppWalletPaymentRequest {
  final MiniAppWalletPaymentFlow flow;
  final String invoiceId;
  final double amount;
  final String note;
  final String refId;
  final int paymentRecordId;
  final String? externalInvoiceId;
  final String? uuid;

  MiniAppWalletPaymentRequest({
    required this.flow,
    required this.invoiceId,
    required num amount,
    required this.note,
    required this.refId,
    required this.paymentRecordId,
    this.externalInvoiceId,
    this.uuid,
  }) : amount = amount.toDouble();
}
