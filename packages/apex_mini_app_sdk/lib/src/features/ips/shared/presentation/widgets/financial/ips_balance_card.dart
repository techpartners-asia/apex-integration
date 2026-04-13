import 'package:flutter/material.dart';

import 'ips_metric_tile.dart';
import 'ips_summary_card.dart';

class IpsBalanceCard extends StatelessWidget {
  const IpsBalanceCard({
    super.key,
    required this.title,
    required this.balance,
    required this.currency,
    this.subtitle,
    this.investedBalanceLabel,
    this.investedBalanceValue,
    this.availableBalanceLabel,
    this.availableBalanceValue,
  });

  final String title;
  final String balance;
  final String currency;
  final String? subtitle;
  final String? investedBalanceLabel;
  final String? investedBalanceValue;
  final String? availableBalanceLabel;
  final String? availableBalanceValue;

  @override
  Widget build(BuildContext context) {
    final ColorScheme colors = Theme.of(context).colorScheme;
    final Color gradientStart = colors.primary;
    final Color gradientEnd = Color.alphaBlend(
      Colors.black.withValues(alpha: 0.25),
      colors.primary,
    );

    return IpsSummaryCard(
      title: title,
      subtitle: subtitle,
      primaryValue: '$balance $currency',
      icon: Icons.account_balance_wallet_outlined,
      gradient: LinearGradient(
        colors: <Color>[gradientStart, gradientEnd],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      metrics: <IpsMetricTile>[
        if (availableBalanceLabel != null && availableBalanceValue != null)
          IpsMetricTile(
            label: availableBalanceLabel!,
            value: availableBalanceValue!,
            icon: Icons.payments_outlined,
          ),
        if (investedBalanceLabel != null && investedBalanceValue != null)
          IpsMetricTile(
            label: investedBalanceLabel!,
            value: investedBalanceValue!,
            icon: Icons.pie_chart_outline_rounded,
          ),
      ],
    );
  }
}
