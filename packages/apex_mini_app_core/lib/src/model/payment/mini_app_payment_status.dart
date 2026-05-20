/// Status returned by the host payment handler.
enum MiniAppPaymentStatus {
  /// Host confirmed that payment succeeded.
  success,

  /// Host confirmed that payment failed or user cancelled.
  failed,

  /// Host could not determine final payment state.
  unknown,
}
