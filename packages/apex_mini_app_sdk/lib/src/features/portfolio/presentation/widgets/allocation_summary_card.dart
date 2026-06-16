import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:apex_mini_app_sdk/apex_mini_app_sdk.dart';

/// Small pill/badge value shown in the yield section.
final class AllocationBadgeData {
  /// Badge label.
  final String label;

  /// Badge color tone.
  final Color tone;

  /// Creates allocation badge data.
  const AllocationBadgeData({required this.label, required this.tone});
}

/// Data required to render an allocation summary.
final class AllocationSummaryData {
  /// Stock allocation amount.
  final double stockValue;

  /// Bond allocation amount.
  final double bondValue;

  /// Cash allocation amount.
  final double cashValue;

  /// Fallback total used when stock/bond totals are missing.
  final double barFallbackTotal;

  /// Stock row label.
  final String stockLabel;

  /// Stock row formatted value.
  final String stockValueLabel;

  /// Bond row label.
  final String bondLabel;

  /// Bond row formatted value.
  final String bondValueLabel;

  /// Cash row label.
  final String cashLabel;

  /// Cash row formatted value.
  final String cashValueLabel;

  /// Total row label.
  final String totalLabel;

  /// Total row formatted value.
  final String totalValueLabel;

  /// Optional label for the yield badge section.
  final String? yieldSectionLabel;

  /// Optional yield badges.
  final List<AllocationBadgeData> yieldBadges;

  /// Creates allocation summary data.
  const AllocationSummaryData({
    required this.stockValue,
    required this.bondValue,
    this.cashValue = 0,
    required this.barFallbackTotal,
    required this.stockLabel,
    required this.stockValueLabel,
    required this.bondLabel,
    required this.bondValueLabel,
    this.cashLabel = '',
    this.cashValueLabel = '',
    required this.totalLabel,
    required this.totalValueLabel,
    this.yieldSectionLabel,
    this.yieldBadges = const <AllocationBadgeData>[],
  });
}

/// Card that visualizes stock/bond allocation and yield badges.
class AllocationSummaryCard extends StatelessWidget {
  /// Data shown by the card.
  final AllocationSummaryData data;

  /// Optional details action.
  final VoidCallback? onViewDetails;

  /// Details action label.
  final String? detailsLabel;

  /// Creates an allocation summary card.
  const AllocationSummaryCard({
    super.key,
    required this.data,
    this.onViewDetails,
    this.detailsLabel,
  });

  bool get _showsDetailsAction =>
      detailsLabel != null && detailsLabel!.trim().isNotEmpty;

  @override
  Widget build(BuildContext context) {
    final responsive = context.responsive;
    final Widget content = Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        AllocationBar(
          stockValue: data.stockValue,
          bondValue: data.bondValue,
          cashValue: data.cashValue,
          fallbackTotal: data.barFallbackTotal,
        ),
        SizedBox(height: responsive.dp(16)),
        AllocationMetricRow(
          color: DesignTokens.rose,
          label: data.stockLabel,
          value: data.stockValueLabel,
        ),
        SizedBox(height: responsive.dp(10)),
        AllocationMetricRow(
          color: DesignTokens.teal,
          label: data.bondLabel,
          value: data.bondValueLabel,
        ),
        if (data.cashValue > 0) ...<Widget>[
          SizedBox(height: responsive.dp(10)),
          AllocationMetricRow(
            color: DesignTokens.mint,
            label: data.cashLabel,
            value: data.cashValueLabel,
          ),
        ],
        SizedBox(height: responsive.dp(12)),
        Row(
          children: <Widget>[
            Expanded(
              child: CustomText(
                data.totalLabel,
                variant: MiniAppTextVariant.subtitle3,
              ),
            ),
            CustomText(
              data.totalValueLabel,
              variant: MiniAppTextVariant.subtitle3,
              color: DesignTokens.rose,
            ),
          ],
        ),
        Padding(
          padding: EdgeInsets.symmetric(vertical: responsive.dp(12)),
          child: Divider(color: DesignTokens.border, height: 1),
        ),
        if (data.yieldBadges.isNotEmpty) ...<Widget>[
          _buildYieldSection(context),
        ],
        if (_showsDetailsAction) ...<Widget>[
          SizedBox(height: responsive.dp(12)),
          Align(
            alignment: Alignment.center,
            child: InkWell(
              onTap: onViewDetails,
              borderRadius: BorderRadius.circular(responsive.radius(8)),
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: responsive.dp(8),
                  vertical: responsive.dp(4),
                ),
                child: CustomText(
                  detailsLabel!,
                  variant: MiniAppTextVariant.buttonSmall,
                  fontWeight: FontWeight.w600,
                  color: DesignTokens.ink,
                ),
              ),
            ),
          ),
        ],
      ],
    );

    return MiniAppGlassCard(
      radius: responsive.radius(16),
      padding: EdgeInsets.all(responsive.dp(18)),
      child: content,
    );
  }

  Widget _buildYieldSection(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(
          child: CustomText(
            data.yieldSectionLabel!,
            variant: MiniAppTextVariant.caption1,
            color: DesignTokens.muted,
          ),
        ),
        ..._buildYieldBadges(context, withLeadingSpacing: true),
      ],
    );

    // return Row(
    //   children: <Widget>[
    //     const Spacer(),
    //     ..._buildYieldBadges(context, withLeadingSpacing: false),
    //   ],
    // );
  }

  List<Widget> _buildYieldBadges(
    BuildContext context, {
    required bool withLeadingSpacing,
  }) {
    final responsive = context.responsive;
    final List<Widget> children = <Widget>[];
    for (int index = 0; index < data.yieldBadges.length; index++) {
      if (index > 0 || withLeadingSpacing) {
        children.add(SizedBox(width: responsive.dp(6)));
      }
      final AllocationBadgeData badge = data.yieldBadges[index];
      children.add(AllocationPill(label: badge.label, tone: badge.tone));
    }
    return children;
  }
}

/// Horizontal stacked bar for stock, bond, and cash allocation.
class AllocationBar extends StatelessWidget {
  /// Stock allocation amount.
  final double stockValue;

  /// Bond allocation amount.
  final double bondValue;

  /// Cash allocation amount.
  final double cashValue;

  /// Fallback total used when stock/bond/cash totals are zero.
  final double fallbackTotal;

  /// Creates an allocation bar.
  const AllocationBar({
    super.key,
    required this.stockValue,
    required this.bondValue,
    this.cashValue = 0,
    this.fallbackTotal = 0,
  });

  @override
  Widget build(BuildContext context) {
    final responsive = context.responsive;
    final double total = stockValue + bondValue + cashValue;
    final double effectiveTotal = total > 0
        ? total
        : math.max(fallbackTotal, 1);
    final double stockFlex = math.max(
      stockValue > 0 ? stockValue : effectiveTotal,
      1,
    );
    final double bondFlex = math.max(bondValue, 0);
    final double cashFlex = math.max(cashValue, 0);

    return Container(
      height: responsive.dp(14),
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: const Color(0xFFF2F4F8),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        children: <Widget>[
          Flexible(
            flex: (stockFlex / effectiveTotal * 1000).round().clamp(1, 1000),
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: <Color>[
                    DesignTokens.deepPink,
                    DesignTokens.softPeach,
                  ],
                ),
              ),
            ),
          ),
          if (bondFlex > 0) SizedBox(width: responsive.dp(4)),
          if (bondFlex > 0)
            Flexible(
              flex: (bondFlex / effectiveTotal * 1000).round().clamp(1, 1000),
              child: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: <Color>[
                      DesignTokens.primaryTeal,
                      DesignTokens.darkTeal,
                    ],
                  ),
                ),
              ),
            ),
          if (cashFlex > 0) SizedBox(width: responsive.dp(4)),
          if (cashFlex > 0)
            Flexible(
              flex: (cashFlex / effectiveTotal * 1000).round().clamp(1, 1000),
              child: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: <Color>[
                      DesignTokens.mint,
                      Color(0xFF1A8A63),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

/// Label/value row below the allocation bar.
class AllocationMetricRow extends StatelessWidget {
  /// Color swatch shown before the label.
  final Color color;

  /// Row label.
  final String label;

  /// Row value.
  final String value;

  /// Creates an allocation metric row.
  const AllocationMetricRow({
    super.key,
    required this.color,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    final responsive = context.responsive;

    return Row(
      children: <Widget>[
        Container(
          width: responsive.dp(13),
          height: responsive.dp(16),
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(3),
          ),
        ),
        SizedBox(width: responsive.dp(8)),
        Expanded(
          child: CustomText(
            label,
            variant: MiniAppTextVariant.caption1,
          ),
        ),
        if (value.trim().isNotEmpty)
          CustomText(
            value,
            variant: MiniAppTextVariant.caption1,
            color: DesignTokens.ink,
          ),
      ],
    );
  }
}

/// Small rounded badge used for yield/profit labels.
class AllocationPill extends StatelessWidget {
  /// Badge label.
  final String label;

  /// Badge tone color.
  final Color tone;

  /// Creates an allocation pill.
  const AllocationPill({
    super.key,
    required this.label,
    required this.tone,
  });

  @override
  Widget build(BuildContext context) {
    final responsive = context.responsive;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: responsive.dp(8),
        vertical: responsive.dp(4),
      ),
      decoration: BoxDecoration(
        color: tone.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(999),
      ),
      child: CustomText(
        label,
        variant: MiniAppTextVariant.caption2,
        color: tone,
      ),
    );
  }
}
