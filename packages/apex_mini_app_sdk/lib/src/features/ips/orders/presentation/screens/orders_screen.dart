import 'package:mini_app_ui/mini_app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../shared/l10n/sdk_localizations_x.dart';
import '../../../shared/data/dto/ips_order_dto.dart';
import '../../../shared/presentation/widgets/widgets.dart';
import '../../../shared/presentation/widgets/financial/financial.dart';
import '../../application/ips_orders_cubit.dart';
import '../../application/ips_orders_state.dart';
import '../../../shared/domain/models/ips_models.dart';
import '../../../shared/presentation/helpers/ips_formatters.dart';
import '../../../shared/presentation/helpers/ips_label_resolvers.dart';

class OrdersScreen extends StatelessWidget {
  const OrdersScreen({super.key});

  Future<void> cancelOrder(BuildContext context, IpsOrder order) async {
    final l10n = context.l10n;
    final bool? confirmed = await showInvestXConfirmationSheet(
      context: context,
      title: l10n.ipsOrdersCancelOrder,
      message: l10n.ipsOrdersCancelOrderConfirm(order.id),
      confirmLabel: l10n.ipsOrdersCancelOrder,
      cancelLabel: l10n.commonCancel,
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
      listenWhen: (IpsOrdersState previous, IpsOrdersState current) => previous.cancelledOrderId != current.cancelledOrderId && current.cancelledOrderId != null,
      listener: (BuildContext context, IpsOrdersState state) {
        MiniAppToast.showSuccess(
          context,
          message: context.l10n.ipsSuccessOrderCancelled,
        );
        context.read<IpsOrdersCubit>().clearFeedback();
      },
      builder: (BuildContext context, IpsOrdersState state) {
        final l10n = context.l10n;

        return InvestXPageScaffold(
          appBarTitle: l10n.ipsOrdersTitle,
          subtitle: l10n.ipsOrdersSubtitle,
          onRefresh: context.read<IpsOrdersCubit>().load,
          actions: <Widget>[
            MiniAppAdaptivePressable(
              onPressed: state.isLoading ? null : context.read<IpsOrdersCubit>().load,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.refresh_rounded),
                  SizedBox(width: context.responsive.spacing.inlineSpacing),
                  CustomText(
                    l10n.commonRefresh,
                    variant: MiniAppTextVariant.button,
                  ),
                ],
              ),
            ),
          ],
          children: <Widget>[
            if ((state.isLoading && state.orders.isNotEmpty) || state.cancellingOrderId != null) ...<Widget>[
              MiniAppLoadingState(
                title: l10n.commonLoading,
                message: l10n.ipsOrdersLoading,
              ),
              SizedBox(height: context.responsive.spacing.sectionSpacing),
            ],
            if (state.isLoading && state.orders.isEmpty)
              const InvestXSkeletonListLoader()
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
              // if (state.refreshedOverview case final PortfolioOverview overview) ...<Widget>[
              //   _OrdersBalanceCard(overview: overview),
              //   SizedBox(height: context.responsive.spacing.sectionSpacing),
              // ],
              InvestXSectionCard(
                children: state.orders
                    .map(
                      (IpsOrder order) => OrderRow(
                        order: order,
                        cancelling: state.cancellingOrderId == order.id,
                        showDivider: order != state.orders.last,
                        onCancel: order.status == IpsOrderStatus.pending ? () => cancelOrder(context, order) : null,
                      ),
                    )
                    .toList(growable: false),
              ),
            ],
            if (state.errorMessage != null && state.orders.isNotEmpty) ...<Widget>[
              SizedBox(height: context.responsive.spacing.sectionSpacing),
              InvestXNoticeBanner(
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

class _OrdersBalanceCard extends StatelessWidget {
  const _OrdersBalanceCard({required this.overview});

  final PortfolioOverview overview;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return IpsBalanceCard(
      title: l10n.ipsPortfolioTitle,
      subtitle: l10n.ipsOrdersSubtitle,
      balance: overview.availableBalance?.toStringAsFixed(2) ?? '0.00',
      currency: overview.currency,
      availableBalanceLabel: l10n.ipsPortfolioAvailableBalance,
      availableBalanceValue: overview.availableBalance == null ? null : formatIpsAmount(overview.availableBalance!, overview.currency),
      investedBalanceLabel: l10n.ipsPortfolioInvestedBalance,
      investedBalanceValue: overview.investedBalance == null ? null : formatIpsAmount(overview.investedBalance!, overview.currency),
    );
  }
}

class OrderRow extends StatelessWidget {
  final IpsOrder order;
  final bool cancelling;
  final bool showDivider;
  final VoidCallback? onCancel;

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
    final String quantityValue = order.packQty == null ? order.amount.toStringAsFixed(0) : l10n.commonPackQuantity(order.packQty!);

    return InvestXStatementListItem(
      title: order.title,
      subtitle: formatIpsDate(order.createdAt),
      trailing: quantityValue,
      statusLabel: resolveOrderStatusLabel(l10n, order.status),
      positive: order.buySell == CaspoTransactionType.buy,
      action: order.status == IpsOrderStatus.pending && onCancel != null
          ? TextButton(
              onPressed: cancelling ? null : onCancel,
              child: Text(cancelling ? l10n.commonLoading : l10n.ipsOrdersCancelOrder),
            )
          : null,
      showDivider: showDivider,
    );
  }
}
