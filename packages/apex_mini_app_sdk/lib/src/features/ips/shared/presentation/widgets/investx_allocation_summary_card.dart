import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:mini_app_ui/mini_app_ui.dart';

import '../helpers/investx_design_tokens.dart';
import 'investx_section_card.dart';

enum InvestXAllocationSummaryCardVariant { dashboard, section }

final class InvestXAllocationBadgeData {
  final String label;
  final Color tone;

  const InvestXAllocationBadgeData({required this.label, required this.tone});
}

final class InvestXAllocationSummaryData {
  final double stockValue;
  final double bondValue;
  final double barFallbackTotal;
  final String stockLabel;
  final String stockValueLabel;
  final String bondLabel;
  final String bondValueLabel;
  final String totalLabel;
  final String totalValueLabel;
  final String? yieldSectionLabel;
  final List<InvestXAllocationBadgeData> yieldBadges;

  const InvestXAllocationSummaryData({
    required this.stockValue,
    required this.bondValue,
    required this.barFallbackTotal,
    required this.stockLabel,
    required this.stockValueLabel,
    required this.bondLabel,
    required this.bondValueLabel,
    required this.totalLabel,
    required this.totalValueLabel,
    this.yieldSectionLabel,
    this.yieldBadges = const <InvestXAllocationBadgeData>[],
  });
}

class InvestXAllocationSummaryCard extends StatelessWidget {
  final InvestXAllocationSummaryData data;
  final InvestXAllocationSummaryCardVariant variant;
  final VoidCallback? onViewDetails;
  final String? detailsLabel;

  const InvestXAllocationSummaryCard({
    super.key,
    required this.data,
    this.variant = InvestXAllocationSummaryCardVariant.section,
    this.onViewDetails,
    this.detailsLabel,
  });

  bool get _showsDetailsAction => detailsLabel != null && detailsLabel!.trim().isNotEmpty;

  @override
  Widget build(BuildContext context) {
    final responsive = context.responsive;
    final Widget content = Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        InvestXAllocationBar(
          stockValue: data.stockValue,
          bondValue: data.bondValue,
          fallbackTotal: data.barFallbackTotal,
        ),
        SizedBox(height: responsive.dp(_config.metricTopSpacing)),
        InvestXAllocationMetricRow(
          color: InvestXDesignTokens.rose,
          label: data.stockLabel,
          value: data.stockValueLabel,
        ),
        SizedBox(height: responsive.dp(_config.metricGap)),
        InvestXAllocationMetricRow(
          color: InvestXDesignTokens.teal,
          label: data.bondLabel,
          value: data.bondValueLabel,
        ),
        SizedBox(height: context.responsive.dp(12)),
        Row(
          children: <Widget>[
            Expanded(
              child: CustomText(
                data.totalLabel,
                variant: MiniAppTextVariant.bodySmall,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: MiniAppTypography.semiBold,
                ),
              ),
            ),
            CustomText(
              data.totalValueLabel,
              variant: MiniAppTextVariant.bodySmall,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: _config.totalValueColor,
                fontWeight: MiniAppTypography.bold,
              ),
            ),
          ],
        ),
        if (_config.showTotalDivider) ...<Widget>[
          Padding(
            padding: EdgeInsets.symmetric(vertical: responsive.dp(12)),
            child: Divider(color: InvestXDesignTokens.border, height: 1),
          ),
        ] else ...<Widget>[
          SizedBox(height: responsive.dp(12)),
        ],
        if (data.yieldBadges.isNotEmpty) ...<Widget>[
          SizedBox(height: responsive.dp(_config.yieldTopSpacing)),
          _buildYieldSection(context),
        ],
        if (_showsDetailsAction) ...<Widget>[
          SizedBox(height: responsive.dp(12)),
          Align(
            alignment: Alignment.center,
            child: MiniAppAdaptivePressable(
              onPressed: onViewDetails,
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: responsive.dp(8),
                  vertical: responsive.dp(4),
                ),
                child: CustomText(
                  detailsLabel!,
                  variant: MiniAppTextVariant.caption,
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    color: InvestXDesignTokens.ink,
                    fontWeight: MiniAppTypography.semiBold,
                  ),
                ),
              ),
            ),
          ),
        ],
      ],
    );

    return switch (variant) {
      InvestXAllocationSummaryCardVariant.dashboard => Container(
        padding: EdgeInsets.all(responsive.dp(18)),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(responsive.radius(16)),
        ),
        child: content,
      ),
      InvestXAllocationSummaryCardVariant.section => InvestXSectionCard(
        padding: EdgeInsets.all(responsive.dp(18)),
        children: <Widget>[content],
      ),
    };
  }

  _InvestXAllocationSummaryCardConfig get _config => switch (variant) {
    InvestXAllocationSummaryCardVariant.dashboard => const _InvestXAllocationSummaryCardConfig(
      metricTopSpacing: 16,
      metricGap: 10,
      showTotalDivider: true,
      yieldTopSpacing: 18,
      totalValueColor: InvestXDesignTokens.rose,
    ),
    InvestXAllocationSummaryCardVariant.section => const _InvestXAllocationSummaryCardConfig(
      metricTopSpacing: 16,
      metricGap: 10,
      showTotalDivider: true,
      yieldTopSpacing: 18,
      totalValueColor: InvestXDesignTokens.rose,
    ),
  };

  Widget _buildYieldSection(BuildContext context) {
    if (_config.showYieldDividerLayout) {
      return Row(
        children: <Widget>[
          if (data.yieldSectionLabel != null && data.yieldSectionLabel!.trim().isNotEmpty)
            Expanded(
              child: CustomText(
                data.yieldSectionLabel!,
                variant: MiniAppTextVariant.caption,
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: InvestXDesignTokens.muted,
                ),
              ),
            )
          else
            const Spacer(),
          ..._buildYieldBadges(context, withLeadingSpacing: true),
        ],
      );
    }

    return Row(
      children: <Widget>[
        const Spacer(),
        ..._buildYieldBadges(context, withLeadingSpacing: false),
      ],
    );
  }

  List<Widget> _buildYieldBadges(BuildContext context, {required bool withLeadingSpacing}) {
    final responsive = context.responsive;
    final List<Widget> children = <Widget>[];
    for (int index = 0; index < data.yieldBadges.length; index++) {
      if (index > 0 || withLeadingSpacing) {
        children.add(SizedBox(width: responsive.dp(6)));
      }
      final InvestXAllocationBadgeData badge = data.yieldBadges[index];
      children.add(
        InvestXAllocationPill(
          label: badge.label,
          tone: badge.tone,
        ),
      );
    }
    return children;
  }
}

class InvestXAllocationBar extends StatelessWidget {
  final double stockValue;
  final double bondValue;
  final double fallbackTotal;

  const InvestXAllocationBar({
    super.key,
    required this.stockValue,
    required this.bondValue,
    this.fallbackTotal = 0,
  });

  @override
  Widget build(BuildContext context) {
    final responsive = context.responsive;
    final double total = stockValue + bondValue;
    final double effectiveTotal = total > 0 ? total : math.max(fallbackTotal, 1);
    final double stockFlex = math.max(
      stockValue > 0 ? stockValue : effectiveTotal,
      1,
    );
    final double bondFlex = math.max(bondValue, 0);

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
                    InvestXDesignTokens.deepPink,
                    InvestXDesignTokens.softPeach,
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
                      InvestXDesignTokens.primaryTeal,
                      InvestXDesignTokens.darkTeal,
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

class InvestXAllocationMetricRow extends StatelessWidget {
  const InvestXAllocationMetricRow({
    super.key,
    required this.color,
    required this.label,
    required this.value,
  });

  final Color color;
  final String label;
  final String value;

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
            variant: MiniAppTextVariant.caption,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: InvestXDesignTokens.muted,
            ),
          ),
        ),
        if (value.trim().isNotEmpty)
          CustomText(
            value,
            variant: MiniAppTextVariant.caption,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: InvestXDesignTokens.ink,
              fontWeight: MiniAppTypography.semiBold,
            ),
          ),
      ],
    );
  }
}

class InvestXAllocationPill extends StatelessWidget {
  const InvestXAllocationPill({
    super.key,
    required this.label,
    required this.tone,
  });

  final String label;
  final Color tone;

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
        variant: MiniAppTextVariant.caption,
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
          color: tone,
          fontWeight: MiniAppTypography.semiBold,
        ),
      ),
    );
  }
}

final class _InvestXAllocationSummaryCardConfig {
  final double metricTopSpacing;
  final double metricGap;
  final bool showTotalDivider;
  final double yieldTopSpacing;
  final Color totalValueColor;

  const _InvestXAllocationSummaryCardConfig({
    required this.metricTopSpacing,
    required this.metricGap,
    required this.showTotalDivider,
    required this.yieldTopSpacing,
    this.totalValueColor = InvestXDesignTokens.ink,
  });

  bool get showYieldDividerLayout => !showTotalDivider;
}
