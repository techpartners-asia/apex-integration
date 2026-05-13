import 'package:mini_app_sdk/mini_app_sdk.dart';

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

String? resolvePaymentResultMessage(SdkLocalizations l10n, MiniAppPaymentRes paymentRes) {
  final String? explicitMessage = paymentRes.message?.trim();

  return explicitMessage;
}
