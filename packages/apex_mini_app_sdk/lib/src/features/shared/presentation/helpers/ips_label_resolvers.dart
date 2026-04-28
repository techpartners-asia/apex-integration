import 'package:mini_app_sdk/mini_app_sdk.dart';

String resolvePaymentStatusLabel(
  SdkLocalizations l10n,
  MiniAppPaymentStatus status,
) {
  return switch (status) {
    MiniAppPaymentStatus.success => l10n.ipsStatusCompleted,
    MiniAppPaymentStatus.failed => l10n.ipsStatusFailed,
    MiniAppPaymentStatus.cancelled => l10n.ipsStatusCancelled,
    MiniAppPaymentStatus.timedOut => l10n.ipsPaymentStatusTimedOut,
    MiniAppPaymentStatus.unsupported => l10n.ipsPaymentStatusUnsupported,
    MiniAppPaymentStatus.pending => l10n.ipsStatusPending,
    MiniAppPaymentStatus.paid => l10n.ipsStatusCompleted,
    MiniAppPaymentStatus.unknown => l10n.errorsGenericTitle,
  };
}

String? resolvePaymentResultMessage(
  SdkLocalizations l10n,
  MiniAppPaymentRes paymentRes,
) {
  final String? messageKey = paymentRes.metadata['messageKey'] as String?;
  final String? explicitMessage = paymentRes.message?.trim();

  final String? localized = switch (messageKey) {
    MiniAppPaymentExecutor.invoiceCreateFailedMessageKey =>
      l10n.ipsPaymentInvoiceCreateFailed,
    MiniAppPaymentExecutor.invalidInvoiceMessageKey =>
      l10n.ipsPaymentInvalidInvoice,
    MiniAppPaymentExecutor.hostResponseTimedOutMessageKey =>
      l10n.ipsPaymentHostResponseTimedOut,
    MiniAppPaymentExecutor.hostCallbackFailedMessageKey =>
      l10n.ipsPaymentHostCallbackFailed,
    _ => null,
  };

  if (explicitMessage != null &&
      explicitMessage.isNotEmpty &&
      explicitMessage != messageKey) {
    return explicitMessage;
  }

  return localized ?? explicitMessage;
}
