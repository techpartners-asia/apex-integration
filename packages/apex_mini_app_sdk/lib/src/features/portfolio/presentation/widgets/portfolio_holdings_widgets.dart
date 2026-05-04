import 'package:adaptive_platform_ui/adaptive_platform_ui.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:mini_app_ui/mini_app_ui.dart';
import 'package:mini_app_sdk/mini_app_sdk.dart';

part 'portfolio_filter_tabs.dart';

part 'portfolio_pie_chart.dart';

part 'portfolio_security_tile.dart';

const List<Color> kPieChartPalette = <Color>[
  DesignTokens.rose,
  DesignTokens.deepPink,
  DesignTokens.softPeach,
  DesignTokens.coral,
  DesignTokens.teal,
  DesignTokens.primaryTeal,
  DesignTokens.darkTeal,
  DesignTokens.ink,
  DesignTokens.muted,
  DesignTokens.success,
  DesignTokens.successStrong,
  DesignTokens.danger,
  Color(0xFFFF6B8A),
  Color(0xFF2AC5B8),
  Color(0xFFFF9B3A),
  Color(0xFF8B6FE8),
  Color(0xFF4A9FE8),
  Color(0xFF52C478),
  Color(0xFFF7C948),
  Color(0xFFE87B6F),
];

List<LinearGradient> kPieChartGradient = <LinearGradient>[
  LinearGradient(colors: [DesignTokens.rose, DesignTokens.softPeach]),
  LinearGradient(colors: [DesignTokens.softPeach, DesignTokens.coral]),
  LinearGradient(colors: [DesignTokens.primaryTeal, DesignTokens.darkTeal]),
  LinearGradient(colors: [DesignTokens.ink, DesignTokens.muted]),
  LinearGradient(colors: [DesignTokens.success, DesignTokens.successStrong]),
  LinearGradient(
    colors: [DesignTokens.selectionBlue, DesignTokens.selectionBlueBorder],
  ),
  LinearGradient(colors: [DesignTokens.roseGlow, DesignTokens.roseTint]),
  LinearGradient(colors: [DesignTokens.muted, DesignTokens.border]),

  LinearGradient(colors: [Color(0xFFFF6B8A), Color(0xFFE87B6F)]),
  LinearGradient(colors: [Color(0xFF2AC5B8), Color(0xFF52C478)]),
  LinearGradient(colors: [Color(0xFFFF9B3A), Color(0xFFF7C948)]),
  LinearGradient(colors: [Color(0xFF8B6FE8), Color(0xFF4A9FE8)]),
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

class PortfolioMyPackSection extends StatefulWidget {
  final PortfolioOverview overview;
  final SdkLocalizations l10n;

  const PortfolioMyPackSection({super.key, required this.overview, required this.l10n});

  @override
  State<PortfolioMyPackSection> createState() => _PortfolioMyPackSectionState();
}

class _PortfolioMyPackSectionState extends State<PortfolioMyPackSection> {
  int _selectedFilter = 0;

  List<PortfolioSecurity> get _filteredSecurities {
    final List<PortfolioSecurity> all = widget.overview.security;
    if (_selectedFilter == 0) return all;
    final String targetType = _selectedFilter == 1 ? 'bond' : 'share';
    final List<PortfolioSecurity> filtered = all.where((PortfolioSecurity s) => (s.securityType ?? '').toLowerCase() == targetType).toList(growable: false);
    if (filtered.isEmpty) return all;
    return filtered;
  }

  @override
  Widget build(BuildContext context) {
    final responsive = context.responsive;
    final l10n = widget.l10n;
    final double stockPercent = widget.overview.stockPercent ?? 0;
    final double bondPercent = widget.overview.bondPercent ?? 0;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SizedBox(height: responsive.spacing.cardGap),
        SectionCard(
          padding: EdgeInsets.all(responsive.dp(18)),
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
                    label: '${l10n.ipsOverviewDashboardAllocationStocks} ${stockPercent.toStringAsFixed(0)}%',
                    value: '',
                  ),
                ),
                SizedBox(width: responsive.dp(16)),
                Expanded(
                  child: AllocationMetricRow(
                    color: DesignTokens.teal,
                    label: '${l10n.ipsOverviewDashboardAllocationBonds} ${bondPercent.toStringAsFixed(0)}%',
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

            /// PieChart
            if (widget.overview.security.isNotEmpty) ...<Widget>[
              SizedBox(height: responsive.dp(20)),
              _PortfolioPieChart(
                sKey: ValueKey(
                  _filteredSecurities
                      .map(
                        (e) => '${e.securityCode}_${e.securityType}_${e.portfolioPercent}',
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
                  gradient: kPieChartGradient[i % kPieChartGradient.length],
                ),
            // ..._filteredSecurities.map(
            //   (PortfolioSecurity security) => PortfolioSecurityTile(
            //     security: security,
            //     currency: widget.overview.currency,
            //     l10n: l10n,
            //   ),
            // ),
          ],
        ),
      ],
    );
  }
}
