import 'package:mini_app_core/mini_app_core.dart';

import '../../../../../../l10n/sdk_localizations.dart';
import '../../../../../runtime/mini_app_payment_executor.dart';
import '../../domain/models/ips_models.dart';

String resolveAcntStatusLabel(SdkLocalizations l10n, AcntStatus status) {
  return switch (status) {
    AcntStatus.none => l10n.ipsStatusPending,
    AcntStatus.pending => l10n.ipsStatusPending,
    AcntStatus.active => l10n.ipsStatusActive,
  };
}

String resolveOrderTypeLabel(SdkLocalizations l10n, IpsOrderType type) {
  return switch (type) {
    IpsOrderType.buy => l10n.ipsOrdersTypeBuy,
    IpsOrderType.sell => l10n.ipsOrdersTypeSell,
    IpsOrderType.recharge => l10n.ipsOrdersTypeRecharge,
  };
}

String resolveOrderStatusLabel(SdkLocalizations l10n, IpsOrderStatus status) {
  return switch (status) {
    IpsOrderStatus.pending => l10n.ipsStatusPending,
    IpsOrderStatus.completed => l10n.ipsStatusCompleted,
    IpsOrderStatus.cancelled => l10n.ipsStatusCancelled,
    IpsOrderStatus.failed => l10n.ipsStatusFailed,
  };
}

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
