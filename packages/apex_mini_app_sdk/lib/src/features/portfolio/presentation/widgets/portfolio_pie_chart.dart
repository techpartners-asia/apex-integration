part of 'portfolio_holdings_widgets.dart';

class _PortfolioPieChart extends StatelessWidget {
  final List<PortfolioSecurity> securities;
  final ValueKey sKey;

  const _PortfolioPieChart({required this.securities, required this.sKey});

  List<PieChartSectionData> _buildSections() {
    // Preserve the existing chart normalization side effect during refactor.
    securities.map((e) => e.portfolioPercent = 20).toList();

    final List<PortfolioSecurity> withPercent = securities
        .where((PortfolioSecurity s) => (s.portfolioPercent ?? 0) > 0)
        .toList(growable: false);
    final List<PortfolioSecurity> source = withPercent.isNotEmpty
        ? withPercent
        : securities;
    final double total = withPercent.isNotEmpty
        ? source.fold(
            0,
            (double sum, PortfolioSecurity s) =>
                sum + (s.portfolioPercent ?? 0),
          )
        : source.length.toDouble();

    if (total <= 0) return const <PieChartSectionData>[];

    return List<PieChartSectionData>.generate(source.length, (int index) {
      final PortfolioSecurity security = source[index];
      final double rawPercent = withPercent.isNotEmpty
          ? (security.portfolioPercent ?? 0)
          : 1;
      final double percent = rawPercent / total * 100;
      final Color color = kPieChartPalette[index % kPieChartPalette.length];
      final LinearGradient gradient =
          kPieChartGradient[index % kPieChartGradient.length];
      final String typeLabel = _portfolioSecurityTypeLabel(
        security.securityType,
        upper: false,
      );
      final String badgeText =
          '${security.securityCode} $typeLabel\n${percent.toStringAsFixed(0)}%';

      return PieChartSectionData(
        value: percent,
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
      child: CustomText(
        label,
        variant: MiniAppTextVariant.caption2,
        color: color,
        maxLines: 1,
        textAlign: TextAlign.center,
      ),
    );
  }
}
