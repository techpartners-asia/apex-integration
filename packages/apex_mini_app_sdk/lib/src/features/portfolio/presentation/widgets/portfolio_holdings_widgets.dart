import 'package:adaptive_platform_ui/adaptive_platform_ui.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:mini_app_ui/mini_app_ui.dart';
import 'package:mini_app_sdk/mini_app_sdk.dart';

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
  LinearGradient(colors: [DesignTokens.selectionBlue, DesignTokens.selectionBlueBorder]),
  LinearGradient(colors: [DesignTokens.roseGlow, DesignTokens.roseTint]),
  LinearGradient(colors: [DesignTokens.muted, DesignTokens.border]),

  LinearGradient(colors: [Color(0xFFFF6B8A), Color(0xFFE87B6F)]),
  LinearGradient(colors: [Color(0xFF2AC5B8), Color(0xFF52C478)]),
  LinearGradient(colors: [Color(0xFFFF9B3A), Color(0xFFF7C948)]),
  LinearGradient(colors: [Color(0xFF8B6FE8), Color(0xFF4A9FE8)]),
];

class PortfolioMyPackSection extends StatefulWidget {
  final PortfolioOverview overview;
  final SdkLocalizations l10n;

  const PortfolioMyPackSection({
    super.key,
    required this.overview,
    required this.l10n,
  });

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
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: MiniAppTypography.bold,
                ),
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
                  _filteredSecurities.map((e) => '${e.securityCode}_${e.securityType}_${e.portfolioPercent}').join('|'),
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

class PortfolioFilterTabs extends StatelessWidget {
  final int selectedFilter;
  final ValueChanged<int> onChanged;
  final SdkLocalizations l10n;

  const PortfolioFilterTabs({
    super.key,
    required this.selectedFilter,
    required this.onChanged,
    required this.l10n,
  });

  @override
  Widget build(BuildContext context) {
    final responsive = context.responsive;

    final List<String> labels = <String>[
      l10n.ipsPortfolioFilterAll,
      l10n.ipsPortfolioFilterBonds,
      l10n.ipsPortfolioFilterStocks,
    ];

    final double horizontalGap = responsive.dp(8);

    Alignment selectedAlignment;
    switch (selectedFilter) {
      case 1:
        selectedAlignment = Alignment.center;
        break;
      case 2:
        selectedAlignment = Alignment.centerRight;
        break;
      case 0:
      default:
        selectedAlignment = Alignment.centerLeft;
        break;
    }

    return Container(
      padding: EdgeInsets.all(responsive.dp(4)),
      decoration: BoxDecoration(
        color: const Color(0xFFF1F2F6),
        borderRadius: BorderRadius.circular(responsive.radius(16)),
      ),
      child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          final double sliderWidth = (constraints.maxWidth - (horizontalGap * 2)) / 3;

          return SizedBox(
            height: responsive.dp(46),
            child: Stack(
              children: <Widget>[
                AnimatedAlign(
                  duration: const Duration(milliseconds: 260),
                  curve: Curves.easeInOutCubic,
                  alignment: selectedAlignment,
                  child: Container(
                    width: sliderWidth,
                    height: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(
                        responsive.radius(14),
                      ),
                      border: Border.all(
                        color: const Color(0xFFD9DCE3),
                      ),
                      boxShadow: <BoxShadow>[
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.04),
                          blurRadius: responsive.dp(10),
                          offset: Offset(0, responsive.dp(2)),
                        ),
                      ],
                    ),
                  ),
                ),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: _PortfolioFilterTabButton(
                        label: labels[0],
                        isSelected: selectedFilter == 0,
                        onTap: () => onChanged(0),
                      ),
                    ),
                    SizedBox(width: horizontalGap),
                    Expanded(
                      child: _PortfolioFilterTabButton(
                        label: labels[1],
                        isSelected: selectedFilter == 1,
                        onTap: () => onChanged(1),
                      ),
                    ),
                    SizedBox(width: horizontalGap),
                    Expanded(
                      child: _PortfolioFilterTabButton(
                        label: labels[2],
                        isSelected: selectedFilter == 2,
                        onTap: () => onChanged(2),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _PortfolioFilterTabButton extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _PortfolioFilterTabButton({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final responsive = context.responsive;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(responsive.radius(14)),
        onTap: onTap,
        child: SizedBox(
          height: double.infinity,
          child: Center(
            child: AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 220),
              curve: Curves.easeInOut,
              style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                color: isSelected ? DesignTokens.ink : const Color(0xFF6B7280),
                fontWeight: isSelected ? MiniAppTypography.semiBold : MiniAppTypography.regular,
              ),
              child: CustomText(
                label,
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                variant: MiniAppTextVariant.label,
                style: TextStyle(fontSize: 13),
                color: isSelected ? DesignTokens.ink : DesignTokens.muted,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class PortfolioSecurityTile extends StatefulWidget {
  final PortfolioSecurity security;
  final String currency;
  final SdkLocalizations l10n;
  final Color? color;
  final LinearGradient? gradient;

  const PortfolioSecurityTile({
    super.key,
    required this.security,
    required this.currency,
    required this.l10n,
    this.color,
    this.gradient,
  });

  @override
  State<PortfolioSecurityTile> createState() => _PortfolioSecurityTileState();
}

class _PortfolioSecurityTileState extends State<PortfolioSecurityTile> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final responsive = context.responsive;
    final PortfolioSecurity security = widget.security;
    final double yieldPercent = security.percent ?? 0;
    final bool isPositive = yieldPercent >= 0;
    final Color toneColor = isPositive ? DesignTokens.success : DesignTokens.danger;
    final String typeLabel = _resolveTypeLabel(security.securityType);
    final String displayName = '${security.securityCode} $typeLabel'.trim();

    return Padding(
      padding: EdgeInsets.symmetric(vertical: responsive.dp(8)),
      child: AdaptiveCard(
        color: Colors.transparent,
        // hasShadow: true,
        padding: EdgeInsets.all(responsive.dp(16)),
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                Container(
                  width: responsive.dp(24),
                  height: responsive.dp(24),
                  decoration: BoxDecoration(
                    color: widget.color,
                    gradient: widget.gradient,
                    borderRadius: BorderRadius.circular(responsive.radius(5)),
                  ),
                  // child: Center(
                  //   child: CustomText(
                  //     security.securityCode.length >= 3 ? security.securityCode.substring(0, 3) : security.securityCode,
                  //     style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  //       fontWeight: MiniAppTypography.bold,
                  //       color: DesignTokens.ink,
                  //     ),
                  //   ),
                  // ),
                ),
                SizedBox(width: responsive.dp(12)),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      CustomText(
                        displayName,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: MiniAppTypography.semiBold,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                SizedBox(width: responsive.dp(8)),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: responsive.dp(8),
                    vertical: responsive.dp(4),
                  ),
                  decoration: BoxDecoration(
                    color: toneColor.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: CustomText(
                    '${isPositive ? '+' : ''}${yieldPercent.toStringAsFixed(1)}%',
                    variant: MiniAppTextVariant.caption,
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: toneColor,
                      fontWeight: MiniAppTypography.semiBold,
                    ),
                  ),
                ),
              ],
            ),
            AnimatedSize(
              duration: const Duration(milliseconds: 240),
              reverseDuration: const Duration(milliseconds: 180),
              curve: Curves.easeInOutCubic,
              alignment: Alignment.topCenter,
              child: _expanded
                  ? Padding(
                      padding: EdgeInsets.only(top: responsive.dp(20)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          PortfolioCompactMetricTile(
                            label: widget.l10n.ipsPortfolioHoldingValueLabel,
                            value: formatIpsPaymentAmount(
                              security.currentPrice ?? 0,
                              widget.currency,
                            ),
                            showHorizontal: true,
                          ),
                          SizedBox(height: responsive.dp(10)),
                          PortfolioCompactMetricTile(
                            label: widget.l10n.ipsPortfolioHoldingQuantity,
                            value: '${(security.qty ?? 0).toStringAsFixed(0)} ш',
                            showHorizontal: true,
                          ),
                        ],
                      ),
                    )
                  : const SizedBox.shrink(),
            ),
            SizedBox(height: responsive.dp(15)),
            Align(
              alignment: Alignment.centerLeft,
              child: MiniAppAdaptivePressable(
                onPressed: () => setState(() => _expanded = !_expanded),
                borderRadius: BorderRadius.circular(999),
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: responsive.dp(2),
                    vertical: responsive.dp(4),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      CustomText(
                        widget.l10n.commonViewDetails,
                        variant: MiniAppTextVariant.caption,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: DesignTokens.muted,
                        ),
                      ),
                      SizedBox(width: responsive.dp(4)),
                      AnimatedRotation(
                        turns: _expanded ? 0.5 : 0,
                        duration: const Duration(milliseconds: 220),
                        curve: Curves.easeInOut,
                        child: Icon(
                          Icons.keyboard_arrow_down_rounded,
                          size: responsive.dp(16),
                          color: DesignTokens.muted,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _resolveTypeLabel(String? securityType) {
    final String normalized = (securityType ?? '').toLowerCase();
    if (normalized == 'stock' || normalized == 'equity') {
      return 'ХУВЬЦАА';
    }
    if (normalized == 'bond' || normalized == 'debt') {
      return 'БОНД';
    }
    return securityType?.toUpperCase() ?? '';
  }
}

// ──────────────────────────────────────────────────────────────────────────────
// Pie chart  (fl_chart PieChart)
// ──────────────────────────────────────────────────────────────────────────────

class _PortfolioPieChart extends StatelessWidget {
  final List<PortfolioSecurity> securities;
  final ValueKey sKey;

  const _PortfolioPieChart({required this.securities, required this.sKey});

  static String _typeLabel(String? securityType) {
    final String n = (securityType ?? '').toLowerCase();
    if (n == 'stock' || n == 'equity') return 'Хувьцаа';
    if (n == 'bond' || n == 'debt') return 'Бонд';
    return securityType ?? '';
  }

  List<PieChartSectionData> _buildSections() {
    securities.map((e) => e.portfolioPercent = 20).toList();
    final List<PortfolioSecurity> withPercent = securities.where((PortfolioSecurity s) => (s.portfolioPercent ?? 0) > 0).toList(growable: false);

    final List<PortfolioSecurity> source = withPercent.isNotEmpty ? withPercent : securities;

    final double total = withPercent.isNotEmpty
        ? source.fold(
            0,
            (double sum, PortfolioSecurity s) => sum + (s.portfolioPercent ?? 0),
          )
        : source.length.toDouble();

    if (total <= 0) return const <PieChartSectionData>[];

    return List<PieChartSectionData>.generate(source.length, (int i) {
      final PortfolioSecurity s = source[i];
      final double rawPct = withPercent.isNotEmpty ? (s.portfolioPercent ?? 0) : 1;
      final double pct = rawPct / total * 100;
      final Color color = kPieChartPalette[i % kPieChartPalette.length];
      final LinearGradient gradient = kPieChartGradient[i % kPieChartGradient.length];
      final String typeLabel = _typeLabel(s.securityType);
      final String badgeText = '${s.securityCode} $typeLabel\n${pct.toStringAsFixed(0)}%';

      return PieChartSectionData(
        value: pct,
        color: color,
        gradient: gradient,
        radius: 52,
        showTitle: false,
        badgeWidget: _PieBadge(label: badgeText, color: color),
        badgePositionPercentageOffset: 1.55,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<PieChartSectionData> sections = _buildSections();
    if (sections.isEmpty) return const SizedBox.shrink();

    return SizedBox(
      height: 230,
      child: PieChart(
        PieChartData(
          sections: sections,
          centerSpaceRadius: 36,
          sectionsSpace: 0,
          startDegreeOffset: -90,
          pieTouchData: PieTouchData(enabled: false),
        ),
        key: sKey,
      ),
    );
  }
}

class _PieBadge extends StatelessWidget {
  final String label;
  final Color color;

  const _PieBadge({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withValues(alpha: 0.35), width: 1),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: color.withValues(alpha: 0.10),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: 9.5,
          fontWeight: FontWeight.w700,
          height: 1.3,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}
