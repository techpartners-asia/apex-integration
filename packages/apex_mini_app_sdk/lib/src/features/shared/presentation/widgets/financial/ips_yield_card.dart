import 'package:flutter/material.dart';
import 'package:mini_app_sdk/mini_app_sdk.dart';

class IpsYieldCard extends StatelessWidget {
  const IpsYieldCard({
    super.key,
    required this.title,
    required this.value,
    this.subtitle,
    this.trendLabel,
  });

  final String title;
  final String value;
  final String? subtitle;
  final String? trendLabel;

  @override
  Widget build(BuildContext context) {
    return IpsSummaryCard(
      title: title,
      subtitle: subtitle,
      primaryValue: value,
      trendLabel: trendLabel,
      trendTone: IpsTrendTone.positive,
      icon: Icons.trending_up_rounded,
    );
  }
}
