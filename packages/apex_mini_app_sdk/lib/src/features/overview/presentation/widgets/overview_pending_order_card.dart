import 'package:flutter/material.dart';
import 'package:apex_mini_app_sdk/apex_mini_app_sdk.dart';

/// Dashboard card shown when the user has a pending order (status "N").
class OverviewPendingOrderCard extends StatelessWidget {
  /// The pending order to display.
  final IpsOrder order;

  /// Amount per pack from the portfolio overview, used to compute total.
  final double? packAmount;

  /// Service fee per pack from the portfolio overview.
  final double? packFee;

  /// Currency code used for formatting the amount.
  final String currency;

  /// Creates a pending order card.
  const OverviewPendingOrderCard({
    super.key,
    required this.order,
    this.packAmount,
    this.packFee,
    this.currency = '',
  });

  @override
  Widget build(BuildContext context) {
    final responsive = context.responsive;

    final String dateLabel = _formatDate(order.createdAt);
    final int qty = order.packQty ?? 0;
    final String buySellLabel = _buySellLabel(order.buySell);
    final double total = qty * ((packAmount ?? 0) + (packFee ?? 0));
    final String amountLabel = formatIpsPaymentAmount(total, currency);

    return Container(
      padding: EdgeInsets.symmetric(
        vertical: responsive.dp(16),
        horizontal: responsive.dp(12),
      ),
      decoration: BoxDecoration(
        color: const Color(0xFFFFFBEB),
        borderRadius: BorderRadius.circular(responsive.radius(16)),
        border: Border.all(
          color: const Color(0xFFFEF3C7),
          width: 1.5,
        ),
      ),
      child: Row(
        children: <Widget>[
          CustomImage(
            path: 'assets/icons/sand-clock.png',
            width: 32,
            height: 32,
          ),
          SizedBox(width: responsive.dp(12)),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Expanded(
                      child: CustomText(
                        context.l10n.ipsOverviewDashboardPendingOrderTitle,
                        variant: MiniAppTextVariant.subtitle3,
                        color: const Color(0xFFF59E0B),
                      ),
                    ),
                    SizedBox(width: responsive.dp(6)),
                    CustomText(
                      '#${order.orderNo}',
                      variant: MiniAppTextVariant.caption2,
                      color: DesignTokens.ink,
                    ),
                  ],
                ),
                SizedBox(height: responsive.dp(4)),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: CustomText(
                        '$buySellLabel • $dateLabel • $qty' 'ш',
                        variant: MiniAppTextVariant.caption1,
                        color: DesignTokens.muted,
                      ),
                    ),
                    CustomText(
                      amountLabel,
                      variant: MiniAppTextVariant.subtitle3,
                      color: DesignTokens.ink,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    final String y = date.year.toString();
    final String m = date.month.toString().padLeft(2, '0');
    final String d = date.day.toString().padLeft(2, '0');
    return '$y.$m.$d';
  }

  String _buySellLabel(String? buySell) {
    if (buySell == null) return 'Авах';
    return buySell.toUpperCase() == 'B' ? 'Авах' : 'Зарах';
  }
}
