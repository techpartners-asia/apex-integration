import 'package:mini_app_core/mini_app_core.dart';
import 'package:mini_app_ui/mini_app_ui.dart';
import 'package:flutter/material.dart';

import '../../../../../shared/l10n/sdk_localizations_x.dart';
import '../helpers/ips_label_resolvers.dart';

class PaymentResState extends StatelessWidget {
  final MiniAppPaymentRes res;

  const PaymentResState({super.key, required this.res});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final String? resolvedMessage = resolvePaymentResultMessage(l10n, res);
    final String? invoiceId =
        res.paymentReference ?? (res.metadata['invoiceId'] as String?)?.trim();
    final String message = <String>[
      if (invoiceId != null && invoiceId.isNotEmpty)
        '${l10n.ipsPaymentInvoiceId}: $invoiceId',
      if (resolvedMessage case final String value) value,
    ].join('\n');

    switch (res.status) {
      case MiniAppPaymentStatus.success:
        return MiniAppSuccessState(title: l10n.commonSuccess, message: message);
      case MiniAppPaymentStatus.cancelled:
        return MiniAppEmptyState(
          title: l10n.ipsStatusCancelled,
          message: message,
          icon: Icons.cancel_outlined,
        );
      case MiniAppPaymentStatus.unsupported:
      case MiniAppPaymentStatus.timedOut:
      case MiniAppPaymentStatus.failed:
        return MiniAppErrorState(
          title: l10n.errorsActionFailed,
          message:
              '${l10n.commonStatus}: ${resolvePaymentStatusLabel(l10n, res.status)}\n$message',
        );
    }
  }
}
