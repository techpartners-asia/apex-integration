import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mini_app_sdk/mini_app_sdk.dart';

MiniAppWalletPaymentHandler buildExampleWalletPaymentHandler(
  GlobalKey<NavigatorState> navigatorKey,
) {
  return (MiniAppWalletPaymentRequest request) async {
    final BuildContext? context = navigatorKey.currentContext;
    if (context == null) {
      return MiniAppPaymentRes.failed(
        message: 'Wallet host is not available.',
        paymentReference: request.invoiceId,
        failure: MiniAppFailure(
          code: 'example_wallet_unavailable',
          message: 'example_wallet_unavailable',
        ),
      );
    }

    final MiniAppPaymentRes? result = await showModalBottomSheet<MiniAppPaymentRes>(
      context: context,
      useRootNavigator: true,
      isScrollControlled: true,
      backgroundColor: const Color(0xFFF2F4F7),
      builder: (BuildContext context) {
        return _ExampleWalletPaymentSheet(request: request);
      },
    );

    return result ??
        MiniAppPaymentRes.cancelled(
          message: 'Payment was cancelled by the host wallet.',
          paymentReference: request.invoiceId,
        );
  };
}

class _ExampleWalletPaymentSheet extends StatelessWidget {
  const _ExampleWalletPaymentSheet({required this.request});

  final MiniAppWalletPaymentRequest request;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colors = theme.colorScheme;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
        child: Material(
          color: Colors.white,
          borderRadius: BorderRadius.circular(28),
          clipBehavior: Clip.antiAlias,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 20, 24, 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Expanded(
                      child: CustomText(
                        'Host wallet checkout',
                        variant: MiniAppTextVariant.headline,
                        style: theme.textTheme.headlineSmall?.copyWith(
                          fontWeight: MiniAppTypography.bold,
                        ),
                      ),
                    ),
                    MiniAppAdaptiveIconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: Icons.close_rounded,
                      iosIcon: CupertinoIcons.xmark,
                      backgroundColor: colors.surfaceContainerHighest,
                      foregroundColor: colors.onSurfaceVariant,
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                CustomText(
                  'The SDK created the invoice. The host app now owns the wallet flow and will return the payment result back to the SDK.',
                  variant: MiniAppTextVariant.body,
                  style: theme.textTheme.bodyMedium?.copyWith(height: 1.5),
                ),
                const SizedBox(height: 20),
                _InfoRow(label: 'Flow', value: _flowLabel(request.flow)),
                _InfoRow(label: 'Invoice ID', value: request.invoiceId),
                _InfoRow(
                  label: 'Amount',
                  value: request.amount.toStringAsFixed(2),
                ),
                _InfoRow(label: 'Note', value: request.note),
                _InfoRow(label: 'Reference ID', value: request.refId),
                const SizedBox(height: 24),
                FilledButton.icon(
                  onPressed: () => Navigator.pop(
                    context,
                    MiniAppPaymentRes.success(
                      message: 'Payment completed in the host wallet.',
                      transactionId: 'wallet_${DateTime.now().millisecondsSinceEpoch}',
                      paymentReference: request.invoiceId,
                    ),
                  ),
                  icon: const Icon(Icons.check_circle_outline_rounded),
                  label: const CustomText(
                    'Complete payment',
                    variant: MiniAppTextVariant.button,
                  ),
                  style: FilledButton.styleFrom(
                    minimumSize: const Size.fromHeight(52),
                  ),
                ),
                const SizedBox(height: 12),
                FilledButton.tonalIcon(
                  onPressed: () => Navigator.of(context).pop(
                    MiniAppPaymentRes.failed(
                      message: 'Payment failed in the host wallet.',
                      paymentReference: request.invoiceId,
                      failure: MiniAppFailure(
                        code: 'example_wallet_failed',
                        message: 'example_wallet_failed',
                      ),
                    ),
                  ),
                  icon: Icon(Icons.error_outline_rounded, color: colors.error),
                  label: const CustomText(
                    'Fail payment',
                    variant: MiniAppTextVariant.button,
                  ),
                  style: FilledButton.styleFrom(
                    minimumSize: const Size.fromHeight(52),
                  ),
                ),
                const SizedBox(height: 12),
                OutlinedButton.icon(
                  onPressed: () => Navigator.of(context).pop(
                    MiniAppPaymentRes.cancelled(
                      message: 'Payment was cancelled by the user.',
                      paymentReference: request.invoiceId,
                    ),
                  ),
                  icon: const Icon(Icons.close_rounded),
                  label: const CustomText(
                    'Cancel payment',
                    variant: MiniAppTextVariant.button,
                  ),
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size.fromHeight(52),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _flowLabel(MiniAppWalletPaymentFlow flow) {
    return switch (flow) {
      MiniAppWalletPaymentFlow.secAcntOpening => 'Securities account opening',
      MiniAppWalletPaymentFlow.ipsRecharge => 'IPS recharge',
    };
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(
            width: 96,
            child: CustomText(
              label,
              variant: MiniAppTextVariant.body,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ),
          Expanded(
            child: CustomText(
              value,
              variant: MiniAppTextVariant.body,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: MiniAppTypography.semiBold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
