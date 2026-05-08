import 'package:mini_app_ui/mini_app_ui.dart';
import 'package:flutter/material.dart';
import 'package:mini_app_sdk/mini_app_sdk.dart';

class PaymentResState extends StatefulWidget {
  final MiniAppPaymentRes res;

  const PaymentResState({super.key, required this.res});

  @override
  State<PaymentResState> createState() => _PaymentResStateState();
}

class _PaymentResStateState extends State<PaymentResState> {
  bool _ordersRedirectScheduled = false;

  @override
  void initState() {
    super.initState();
    _scheduleOrdersRedirectIfNeeded();
  }

  @override
  void didUpdateWidget(covariant PaymentResState oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.res != widget.res) {
      _ordersRedirectScheduled = false;
      _scheduleOrdersRedirectIfNeeded();
    }
  }

  void _scheduleOrdersRedirectIfNeeded() {
    final MiniAppPaymentRes res = widget.res;
    if (_ordersRedirectScheduled ||
        res.status != MiniAppPaymentStatus.success ||
        !res.isTransaction) {
      return;
    }

    _ordersRedirectScheduled = true;
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!mounted) return;
      await replaceIpsRoute(context, route: MiniAppRoutes.orders);
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final MiniAppPaymentRes res = widget.res;
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
      case MiniAppPaymentStatus.unknown:
        return MiniAppErrorState(
          title: l10n.errorsActionFailed,
          message:
              '${l10n.commonStatus}: ${resolvePaymentStatusLabel(l10n, res.status)}\n$message',
        );
      case MiniAppPaymentStatus.pending:
        return MiniAppEmptyState(
          title: l10n.ipsStatusPending,
          message: message,
          icon: Icons.schedule_outlined,
        );
      case MiniAppPaymentStatus.paid:
        return MiniAppSuccessState(title: l10n.commonSuccess, message: message);
    }
  }
}
