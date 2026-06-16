import 'package:apex_mini_app_sdk/apex_mini_app_sdk.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// IPS order history screen with refresh and pending-order cancellation.
class OrdersScreen extends StatelessWidget {
  /// Creates the IPS order history screen.
  const OrdersScreen({super.key});

  /// Confirms and submits cancellation for a pending order.
  Future<void> cancelOrder(BuildContext context, IpsOrder order) async {
    final l10n = context.l10n;
    final bool? confirmed = await showConfirmationSheet(
      context: context,
      title: l10n.ipsOrdersCancelOrder,
      message: l10n.ipsOrdersCancelOrderConfirm(order.id),
      confirmLabel: l10n.ipsOrdersCancelOrder,
      cancelLabel: l10n.commonDismiss,
      destructive: true,
    );
    if (confirmed != true || !context.mounted) {
      return;
    }
    await context.read<IpsOrdersCubit>().cancelOrder(order);
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<IpsOrdersCubit, IpsOrdersState>(
      listenWhen: (IpsOrdersState previous, IpsOrdersState current) =>
          (previous.cancelledOrderId != current.cancelledOrderId &&
              current.cancelledOrderId != null) ||
          (previous.errorMessage != current.errorMessage &&
              (current.errorMessage?.trim().isNotEmpty ?? false)),
      listener: (BuildContext context, IpsOrdersState state) {
        if (state.cancelledOrderId != null) {
          MiniAppToast.showSuccess(
            context,
            message: context.l10n.ipsSuccessOrderCancelled,
          );
          context.read<IpsOrdersCubit>().clearFeedback();
          return;
        }

        final String? message = state.errorMessage?.trim();
        if (message != null && message.isNotEmpty) {
          MiniAppToast.showError(context, message: message);
        }
      },
      builder: (BuildContext context, IpsOrdersState state) {
        final l10n = context.l10n;

        return CustomScaffold(
          appBarTitle: l10n.ipsOrdersTitle,
          onRefresh: context.read<IpsOrdersCubit>().load,
          actions: <Widget>[
            MiniAppAdaptivePressable(
              onPressed: state.isLoading
                  ? null
                  : context.read<IpsOrdersCubit>().load,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.refresh_rounded, color: DesignTokens.ink),
                  SizedBox(width: context.responsive.spacing.inlineSpacing),
                  CustomText(
                    l10n.commonRefresh,
                    variant: MiniAppTextVariant.buttonMedium,
                  ),
                ],
              ),
            ),
          ],
          children: <Widget>[
            if ((state.isLoading && state.orders.isNotEmpty) ||
                state.cancellingOrderId != null) ...<Widget>[
              MiniAppLoadingState(
                title: l10n.commonLoading,
                message: l10n.ipsOrdersLoading,
              ),
              SizedBox(height: context.responsive.spacing.sectionSpacing),
            ],
            if (state.isLoading && state.orders.isEmpty)
              const SkeletonListLoader()
            else if (state.errorMessage != null && state.orders.isEmpty)
              MiniAppErrorState(
                title: l10n.errorsGenericTitle,
                message: state.errorMessage!,
                retryLabel: l10n.commonRetry,
                onRetry: context.read<IpsOrdersCubit>().load,
              )
            else if (state.orders.isEmpty)
              MiniAppEmptyState(
                title: l10n.ipsOrdersTitle,
                message: l10n.ipsOrdersNoOrders,
              )
            else ...<Widget>[
              SectionCard(
                children: state.orders
                    .map(
                      (IpsOrder order) => OrderRow(
                        order: order,
                        cancelling: state.cancellingOrderId == order.id,
                        showDivider: order != state.orders.last,
                        onCancel: order.status == IpsOrderStatus.pending
                            ? () => cancelOrder(context, order)
                            : null,
                      ),
                    )
                    .toList(growable: false),
              ),
            ],
            if (state.errorMessage != null &&
                state.orders.isNotEmpty) ...<Widget>[
              SizedBox(height: context.responsive.spacing.sectionSpacing),
              NoticeBanner(
                title: l10n.errorsActionFailed,
                message: state.errorMessage!,
                icon: Icons.error_outline_rounded,
              ),
            ],
          ],
        );
      },
    );
  }
}

/// Single order row used inside [OrdersScreen].
class OrderRow extends StatelessWidget {
  /// Order data to render.
  final IpsOrder order;

  /// Whether this row's cancellation request is running.
  final bool cancelling;

  /// Whether to show a divider below the row.
  final bool showDivider;

  /// Optional cancel callback for pending orders.
  final VoidCallback? onCancel;

  /// Creates an order row.
  const OrderRow({
    super.key,
    required this.order,
    required this.cancelling,
    required this.showDivider,
    this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final String quantityValue = order.packQty == null
        ? order.amount.toStringAsFixed(0)
        : l10n.commonPackQuantity(order.packQty!);

    return StatementListItem(
      title: order.title,
      subtitle: formatIpsDate(order.createdAt),
      trailing: quantityValue,
      statusLabel: _resolveOrderStatusLabel(l10n, order.status),
      positive: order.buySell == CaspoTransactionType.buy,
      action: order.status == IpsOrderStatus.pending && onCancel != null
          ? TextButton(
              onPressed: cancelling ? null : onCancel,
              child: CustomText(
                cancelling ? l10n.commonLoading : l10n.ipsOrdersCancelOrder,
                variant: MiniAppTextVariant.buttonMedium,
                color: Theme.of(context).colorScheme.primary,
              ),
            )
          : null,
      showDivider: showDivider,
    );
  }
}

String _resolveOrderStatusLabel(
  SdkLocalizations l10n,
  IpsOrderStatus status,
) {
  return switch (status) {
    IpsOrderStatus.pending => l10n.ipsStatusPending,
    IpsOrderStatus.confirmed => l10n.ipsStatusConfirmed,
    IpsOrderStatus.completed => l10n.ipsStatusCompleted,
    IpsOrderStatus.allocated => l10n.ipsStatusAllocated,
    IpsOrderStatus.cancelled => l10n.ipsStatusCancelled,
    IpsOrderStatus.failed => l10n.ipsStatusFailed,
  };
}
