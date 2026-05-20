import 'package:apex_mini_app_sdk/apex_mini_app_sdk.dart';

/// Resolves a localized display label for a payment result status.
String resolvePaymentStatusLabel(
  SdkLocalizations l10n,
  MiniAppPaymentStatus status,
) {
  return switch (status) {
    MiniAppPaymentStatus.success => l10n.ipsStatusCompleted,
    MiniAppPaymentStatus.failed => l10n.ipsStatusFailed,
    MiniAppPaymentStatus.unknown => l10n.errorsGenericTitle,
  };
}

/// Returns the explicit payment result message when the backend/host provides one.
String? resolvePaymentResultMessage(
  SdkLocalizations l10n,
  MiniAppPaymentRes paymentRes,
) {
  final String? explicitMessage = paymentRes.message?.trim();

  return explicitMessage;
}
