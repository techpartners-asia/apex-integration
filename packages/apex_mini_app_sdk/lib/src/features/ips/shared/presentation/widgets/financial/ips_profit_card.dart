import 'package:flutter/material.dart';

import 'ips_summary_card.dart';

class IpsProfitCard extends StatelessWidget {
  const IpsProfitCard({
    super.key,
    required this.title,
    required this.value,
    this.subtitle,
    this.trendLabel,
    this.isNegative = false,
  });

  final String title;
  final String value;
  final String? subtitle;
  final String? trendLabel;
  final bool isNegative;

  @override
  Widget build(BuildContext context) {
    return IpsSummaryCard(
      title: title,
      subtitle: subtitle,
      primaryValue: value,
      trendLabel: trendLabel,
      trendTone: isNegative ? IpsTrendTone.negative : IpsTrendTone.positive,
      icon: isNegative ? Icons.trending_down_rounded : Icons.show_chart_rounded,
    );
  }
}
