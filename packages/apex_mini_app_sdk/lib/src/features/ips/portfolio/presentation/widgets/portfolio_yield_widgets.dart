import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:mini_app_sdk/l10n/sdk_localizations.dart';
import 'package:mini_app_ui/mini_app_ui.dart';

import '../models/portfolio_yield_chart_data.dart';
import '../../../shared/domain/models/ips_models.dart';
import '../../../shared/presentation/helpers/ips_formatters.dart';
import '../../../shared/presentation/widgets/widgets.dart';

class PortfolioYieldSection extends StatelessWidget {
  final PortfolioOverview overview;
  final PortfolioYieldChartData chartData;
  final SdkLocalizations l10n;

  const PortfolioYieldSection({
    super.key,
    required this.overview,
    required this.chartData,
    required this.l10n,
  });

  @override
  Widget build(BuildContext context) {
    final responsive = context.responsive;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SizedBox(height: responsive.spacing.cardGap),
        InvestXSectionCard(
          padding: EdgeInsets.all(responsive.dp(18)),
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(left: responsive.dp(4)),
              child: CustomText(
                l10n.ipsYieldTitle,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: MiniAppTypography.bold,
                ),
              ),
            ),
            SizedBox(height: responsive.dp(16)),
            PortfolioYieldChart(
              data: chartData,
              l10n: l10n,
              currency: overview.currency,
            ),
            SizedBox(height: responsive.dp(18)),
            PortfolioYieldMetricsGrid(
              overview: overview,
              chartData: chartData,
              l10n: l10n,
            ),
          ],
        ),
      ],
    );
  }
}

class PortfolioYieldChart extends StatelessWidget {
  final PortfolioYieldChartData data;
  final SdkLocalizations l10n;
  final String currency;

  const PortfolioYieldChart({
    super.key,
    required this.data,
    required this.l10n,
    required this.currency,
  });

  static const Color _primaryColor = InvestXDesignTokens.selectionBlue;
  static const Color _secondaryColor = InvestXDesignTokens.rose;

  @override
  Widget build(BuildContext context) {
    final responsive = context.responsive;

    if (!data.hasData) {
      return _PortfolioYieldEmptyState(message: l10n.ipsPortfolioNoHoldings);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        SizedBox(
          height: responsive.dp(188),
          child: LineChart(
            _buildChartData(),
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
          ),
        ),
        SizedBox(height: responsive.dp(14)),
        Wrap(
          spacing: responsive.dp(12),
          runSpacing: responsive.dp(8),
          children: <Widget>[
            _PortfolioYieldLegendItem(
              color: _primaryColor,
              label: l10n.ipsOverviewDashboardAllocationTotal,
              value: formatIpsPaymentAmount(data.primaryTotal ?? 0, currency),
            ),
            if (data.hasSecondarySeries)
              _PortfolioYieldLegendItem(
                color: _secondaryColor,
                label: l10n.ipsProfitTitle,
                value: formatIpsPaymentAmount(data.secondaryTotal ?? 0, currency),
              ),
          ],
        ),
      ],
    );
  }

  LineChartData _buildChartData() {
    final List<FlSpot> primarySpots = data.points
        .asMap()
        .entries
        .map((MapEntry<int, PortfolioYieldChartPoint> e) =>
            FlSpot(e.key.toDouble(), e.value.primaryValue))
        .toList(growable: false);

    final List<FlSpot> secondarySpots = data.hasSecondarySeries
        ? data.points
            .asMap()
            .entries
            .where((MapEntry<int, PortfolioYieldChartPoint> e) =>
                e.value.secondaryValue != null)
            .map((MapEntry<int, PortfolioYieldChartPoint> e) =>
                FlSpot(e.key.toDouble(), e.value.secondaryValue!))
            .toList(growable: false)
        : const <FlSpot>[];

    final List<LineChartBarData> bars = <LineChartBarData>[
      _buildBar(primarySpots, _primaryColor),
      if (secondarySpots.isNotEmpty) _buildBar(secondarySpots, _secondaryColor),
    ];

    return LineChartData(
      lineBarsData: bars,
      gridData: FlGridData(
        show: true,
        drawVerticalLine: false,
        getDrawingHorizontalLine: (_) => const FlLine(
          color: InvestXDesignTokens.border,
          strokeWidth: 1,
        ),
      ),
      titlesData: FlTitlesData(
        show: true,
        topTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        rightTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        leftTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 28,
            interval: 1,
            getTitlesWidget: _buildBottomTitle,
          ),
        ),
      ),
      borderData: FlBorderData(show: false),
      lineTouchData: LineTouchData(
        touchTooltipData: LineTouchTooltipData(
          getTooltipColor: (_) => Colors.black87,
          getTooltipItems: (List<LineBarSpot> spots) => spots
              .map(
                (LineBarSpot spot) => LineTooltipItem(
                  formatIpsPaymentAmount(spot.y, currency),
                  const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              )
              .toList(growable: false),
        ),
      ),
    );
  }

  LineChartBarData _buildBar(List<FlSpot> spots, Color color) {
    return LineChartBarData(
      spots: spots,
      isCurved: true,
      color: color,
      barWidth: 3,
      isStrokeCapRound: true,
      dotData: FlDotData(
        show: true,
        getDotPainter: (spot, pct, bar, idx) => FlDotCirclePainter(
          radius: 3.2,
          color: color,
          strokeColor: Colors.white,
          strokeWidth: 1.5,
        ),
      ),
      belowBarData: BarAreaData(
        show: true,
        gradient: LinearGradient(
          colors: <Color>[
            color.withValues(alpha: 0.20),
            color.withValues(alpha: 0.02),
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
    );
  }

  Widget _buildBottomTitle(double value, TitleMeta meta) {
    final int index = value.toInt();
    if (index < 0 || index >= data.points.length || value != value.roundToDouble()) {
      return const SizedBox.shrink();
    }
    return Padding(
      padding: const EdgeInsets.only(top: 6),
      child: Text(
        data.points[index].label,
        style: const TextStyle(
          color: InvestXDesignTokens.muted,
          fontSize: 10,
          fontWeight: FontWeight.w500,
        ),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        textAlign: TextAlign.center,
      ),
    );
  }
}

class _PortfolioYieldLegendItem extends StatelessWidget {
  const _PortfolioYieldLegendItem({
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
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Container(
          width: responsive.dp(8),
          height: responsive.dp(8),
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(999),
          ),
        ),
        SizedBox(width: responsive.dp(6)),
        CustomText(
          '$label: $value',
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

class _PortfolioYieldEmptyState extends StatelessWidget {
  const _PortfolioYieldEmptyState({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    final responsive = context.responsive;

    return Container(
      height: responsive.dp(188),
      decoration: BoxDecoration(
        color: InvestXDesignTokens.softSurface,
        borderRadius: BorderRadius.circular(responsive.radius(16)),
        border: Border.all(color: InvestXDesignTokens.border),
      ),
      padding: EdgeInsets.symmetric(
        horizontal: responsive.dp(20),
        vertical: responsive.dp(16),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(
            Icons.show_chart_rounded,
            color: InvestXDesignTokens.muted,
            size: responsive.dp(28),
          ),
          SizedBox(height: responsive.dp(10)),
          CustomText(
            message,
            textAlign: TextAlign.center,
            variant: MiniAppTextVariant.bodySmall,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: InvestXDesignTokens.muted,
            ),
          ),
        ],
      ),
    );
  }
}

class PortfolioYieldMetricsGrid extends StatelessWidget {
  const PortfolioYieldMetricsGrid({
    super.key,
    required this.overview,
    required this.l10n,
    this.chartData = const PortfolioYieldChartData(),
  });

  final PortfolioOverview overview;
  final PortfolioYieldChartData chartData;
  final SdkLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    final responsive = context.responsive;
    final String currency = overview.currency;
    final double resolvedAvailableBalance =
        overview.availableBalance ?? overview.cashTotal ?? 0;
    final double resolvedInvestedBalance =
        overview.investedBalance ?? chartData.primaryTotal ?? 0;
    final double resolvedTotalAllocation =
        ((overview.stockTotal ?? 0) + (overview.bondTotal ?? 0)) > 0
        ? (overview.stockTotal ?? 0) + (overview.bondTotal ?? 0)
        : (chartData.primaryTotal ?? 0);
    final double resolvedProfitLoss =
        overview.profitOrLoss ?? chartData.secondaryTotal ?? overview.yieldAmount ?? 0;

    return Column(
      children: <Widget>[
        Row(
          children: <Widget>[
            Expanded(
              child: PortfolioCompactMetricTile(
                label: l10n.ipsPortfolioAvailableBalance,
                value: formatIpsAmount(resolvedAvailableBalance, currency),
              ),
            ),
            SizedBox(width: responsive.dp(12)),
            Expanded(
              child: PortfolioCompactMetricTile(
                label: l10n.ipsPortfolioInvestedBalance,
                value: formatIpsAmount(resolvedInvestedBalance, currency),
              ),
            ),
          ],
        ),
        SizedBox(height: responsive.dp(12)),
        Row(
          children: <Widget>[
            Expanded(
              child: PortfolioCompactMetricTile(
                label: l10n.ipsOverviewDashboardAllocationTotal,
                value: formatIpsAmount(resolvedTotalAllocation, currency),
              ),
            ),
            SizedBox(width: responsive.dp(12)),
            Expanded(
              child: PortfolioCompactMetricTile(
                label: l10n.ipsPortfolioProfitLoss,
                value: formatIpsAmount(resolvedProfitLoss, currency),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class PortfolioCompactMetricTile extends StatelessWidget {
  const PortfolioCompactMetricTile({
    super.key,
    required this.label,
    required this.value,
    this.showHorizontal = false,
  });

  final String label;
  final String value;
  final bool showHorizontal;

  @override
  Widget build(BuildContext context) {
    final responsive = context.responsive;

    if (showHorizontal) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          CustomText(
            label,
            variant: MiniAppTextVariant.caption,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: InvestXDesignTokens.muted,
              fontSize: responsive.dp(11),
            ),
          ),
          CustomText(
            value,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontWeight: MiniAppTypography.bold,
            ),
          ),
        ],
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        CustomText(
          label,
          variant: MiniAppTextVariant.caption,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: InvestXDesignTokens.muted,
            fontSize: responsive.dp(11),
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        SizedBox(height: responsive.dp(2)),
        CustomText(
          value,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            fontWeight: MiniAppTypography.bold,
          ),
        ),
      ],
    );
  }
}
