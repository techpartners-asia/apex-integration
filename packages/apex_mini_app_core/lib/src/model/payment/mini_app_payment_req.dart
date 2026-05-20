/// Payment flows that the host app may be asked to complete.
enum MiniAppPaymentFlow { secAcntOpening, ipsRecharge }

/// Payment request emitted by the mini app when a payment must be delegated to
/// the host application.
class MiniAppPaymentReq {
  /// Business flow that requested the payment.
  final MiniAppPaymentFlow flow;

  /// Mini-app/backend invoice identifier.
  final String invoiceId;

  /// Amount that the host payment UI should charge.
  final double amount;

  /// User-facing or audit note attached to the payment request.
  final String note;

  /// Internal payment record id returned by the backend.
  final int paymentRecordId;

  /// Optional invoice identifier used by an external wallet/payment provider.
  final String? externalInvoiceId;

  /// Optional transaction uuid used by payment provider integrations.
  final String? uuid;

  /// Whether this request represents an immediate transaction payment.
  final bool isTransaction;

  /// Creates the payment payload delivered to the host wallet handler.
  MiniAppPaymentReq({
    required this.flow,
    required this.invoiceId,
    required num amount,
    required this.note,
    required this.paymentRecordId,
    this.externalInvoiceId,
    this.uuid,
    required this.isTransaction,
  }) : amount = amount.toDouble();
}
