import 'package:adaptive_platform_ui/adaptive_platform_ui.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:apex_mini_app_sdk/apex_mini_app_sdk.dart';

part 'portfolio_filter_tabs.dart';

part 'portfolio_pie_chart.dart';

part 'portfolio_security_tile.dart';

/// Fallback categorical colors for portfolio pie-chart slices.
const List<Color> kPieChartPalette = <Color>[
  Color(0xFFDD4F80),
  Color(0xFFFB9D6C),
  Color(0xFFD3DDDD),
  Color(0xFF3A7B91),
  Color(0xFF085055),
  Color(0xFF294753),
];


String _portfolioSecurityTypeLabel(
  String? securityType, {
  required bool upper,
}) {
  final String normalized = (securityType ?? '').toLowerCase();
  return switch (normalized) {
    'stock' || 'equity' => upper ? 'ХУВЬЦАА' : 'Хувьцаа',
    'bond' || 'debt' => upper ? 'БОНД' : 'Бонд',
    _ => upper ? (securityType?.toUpperCase() ?? '') : (securityType ?? ''),
  };
}

/// Holdings section that shows allocation, metrics, chart, and securities.
class PortfolioMyPackSection extends StatefulWidget {
  /// Portfolio overview payload.
  final PortfolioOverview overview;

  /// Localized labels.
  final SdkLocalizations l10n;

  /// Creates a portfolio holdings section.
  const PortfolioMyPackSection({
    super.key,
    required this.overview,
    required this.l10n,
  });

  @override
  State<PortfolioMyPackSection> createState() => _PortfolioMyPackSectionState();
}

/// Owns the all/bond/stock filter for the holdings section.
class _PortfolioMyPackSectionState extends State<PortfolioMyPackSection> {
  /// Selected filter index: 0 all, 1 bonds, 2 stocks.
  int _selectedFilter = 0;

  /// Securities matching the current filter, falling back to all when empty.
  List<PortfolioSecurity> get _filteredSecurities {
    final List<PortfolioSecurity> all = widget.overview.security;
    if (_selectedFilter == 0) return all;
    final String targetType = _selectedFilter == 1 ? 'bond' : 'share';
    final List<PortfolioSecurity> filtered = all
        .where(
          (PortfolioSecurity s) =>
              (s.securityType ?? '').toLowerCase() == targetType,
        )
        .toList(growable: false);
    if (filtered.isEmpty) return all;
    return filtered;
  }

  @override
  Widget build(BuildContext context) {
    final responsive = context.responsive;
    final l10n = widget.l10n;
    final double stockPercent = widget.overview.stockPercent ?? 0;
    final double bondPercent = widget.overview.bondPercent ?? 0;
    final EdgeInsets padding = EdgeInsets.all(responsive.dp(18));
    final Widget content = Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(left: responsive.dp(4)),
          child: CustomText(
            l10n.ipsPortfolioHoldings,
            variant: MiniAppTextVariant.subtitle2,
          ),
        ),
        SizedBox(height: responsive.dp(20)),
        AllocationBar(
          stockValue: stockPercent,
          bondValue: bondPercent,
        ),
        SizedBox(height: responsive.dp(12)),
        Row(
          children: <Widget>[
            Expanded(
              child: AllocationMetricRow(
                color: DesignTokens.rose,
                label:
                    '${l10n.ipsOverviewDashboardAllocationStocks} ${stockPercent.toStringAsFixed(0)}%',
                value: '',
              ),
            ),
            SizedBox(width: responsive.dp(16)),
            Expanded(
              child: AllocationMetricRow(
                color: DesignTokens.teal,
                label:
                    '${l10n.ipsOverviewDashboardAllocationBonds} ${bondPercent.toStringAsFixed(0)}%',
                value: '',
              ),
            ),
          ],
        ),
        SizedBox(height: responsive.dp(14)),
        PortfolioYieldMetricsGrid(overview: widget.overview, l10n: l10n),
        SizedBox(height: responsive.spacing.cardGap),
        PortfolioFilterTabs(
          selectedFilter: _selectedFilter,
          onChanged: (value) => setState(() => _selectedFilter = value),
          l10n: l10n,
        ),
        if (widget.overview.security.isNotEmpty) ...<Widget>[
          SizedBox(height: responsive.dp(20)),
          _PortfolioPieChart(
            sKey: ValueKey(
              _filteredSecurities
                  .map(
                    (e) =>
                        '${e.securityCode}_${e.securityType}_${e.portfolioPercent}',
                  )
                  .join('|'),
            ),
            securities: _filteredSecurities,
          ),
        ],
        SizedBox(height: responsive.spacing.cardGap),
        if (_filteredSecurities.isEmpty)
          MiniAppEmptyState(
            title: l10n.ipsPortfolioHoldings,
            message: l10n.ipsPortfolioNoHoldings,
          )
        else
          for (var i = 0; i < _filteredSecurities.length; i++)
            PortfolioSecurityTile(
              security: _filteredSecurities[i],
              currency: widget.overview.currency,
              l10n: l10n,
              color: kPieChartPalette[i % kPieChartPalette.length],
            ),
      ],
    );

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SizedBox(height: responsive.spacing.cardGap),
        MiniAppGlassCard(
          radius: responsive.radius(16),
          padding: padding,
          child: content,
        ),
      ],
    );
  }
}
