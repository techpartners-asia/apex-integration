import 'package:apex_mini_app_sdk/apex_mini_app_sdk.dart';

/// One plotted point in the portfolio yield chart.
class PortfolioYieldChartPoint {
  /// Short label shown on the chart axis.
  final String label;

  /// Primary series value, usually current/invested value.
  final double primaryValue;

  /// Optional secondary series value, usually yield/profit.
  final double? secondaryValue;

  /// Creates a yield chart point.
  const PortfolioYieldChartPoint({
    required this.label,
    required this.primaryValue,
    this.secondaryValue,
  });
}

/// Portfolio yield chart data with optional two-series totals.
class PortfolioYieldChartData {
  /// Creates yield chart data.
  const PortfolioYieldChartData({
    this.points = const <PortfolioYieldChartPoint>[],
    this.primaryTotal,
    this.secondaryTotal,
  });

  /// Points rendered by the chart.
  final List<PortfolioYieldChartPoint> points;

  /// Sum of the primary series.
  final double? primaryTotal;

  /// Sum of the secondary series.
  final double? secondaryTotal;

  /// Whether there is anything to render.
  bool get hasData => points.isNotEmpty;

  /// Whether any point has a secondary value.
  bool get hasSecondarySeries => points.any(
    (PortfolioYieldChartPoint point) => point.secondaryValue != null,
  );
}

/// Maps backend holding responses into chart-ready data.
final class PortfolioYieldChartDataMapper {
  const PortfolioYieldChartDataMapper._();

  /// Merges yield-profit and stock-yield-detail holdings into chart points.
  static PortfolioYieldChartData fromResponses({
    required List<PortfolioHolding> yieldProfitHoldings,
    required List<PortfolioHolding> stockYieldDetails,
  }) {
    final Map<String, _ChartSeed> seedsByKey = <String, _ChartSeed>{};
    int nextOrder = 0;

    void absorb(List<PortfolioHolding> source) {
      for (final PortfolioHolding holding in source) {
        final String key = _resolveKey(holding, nextOrder);
        final _ChartSeed seed = seedsByKey.putIfAbsent(
          key,
          () => _ChartSeed(order: nextOrder++),
        );
        seed.absorb(holding);
      }
    }

    absorb(yieldProfitHoldings);
    absorb(stockYieldDetails);

    final List<_ChartSeed> seeds = seedsByKey.values
        .where((_ChartSeed seed) => seed.hasRenderableData)
        .toList(growable: false);

    if (seeds.isEmpty) {
      return const PortfolioYieldChartData();
    }

    final List<_ChartSeed> sortedSeeds = List<_ChartSeed>.from(seeds)
      ..sort((a, b) {
        // if (canSortByDate) {
        //   return a.recordedAt!.compareTo(b.recordedAt!);
        // }
        return a.order.compareTo(b.order);
      });

    return PortfolioYieldChartData(
      points: sortedSeeds
          .map(
            (_ChartSeed seed) => PortfolioYieldChartPoint(
              label: seed.displayLabel,
              primaryValue: seed.primaryValue ?? 0,
              secondaryValue: seed.secondaryValue,
            ),
          )
          .toList(growable: false),
      primaryTotal: _sumValues(
        sortedSeeds.map((_ChartSeed seed) => seed.primaryValue),
      ),
      secondaryTotal: _sumValues(
        sortedSeeds.map((_ChartSeed seed) => seed.secondaryValue),
      ),
    );
  }

  static String _resolveKey(PortfolioHolding holding, int fallbackIndex) {
    final String? securityCode = _normalizedText(holding.securityCode);
    if (securityCode != null) {
      return 'securityCode:$securityCode';
    }

    // final String? label = _normalizedText(holding.pointLabel);
    // if (label != null) {
    //   return 'label:$label';
    // }

    final String? securityName = _normalizedText(holding.securityName);
    if (securityName != null) {
      return 'securityName:$securityName';
    }

    return 'index:$fallbackIndex';
  }

  static String? _normalizedText(String? value) {
    final String trimmed = value?.trim() ?? '';
    if (trimmed.isEmpty) {
      return null;
    }
    return trimmed;
  }

  static double? _sumValues(Iterable<double?> values) {
    double total = 0;
    bool hasValue = false;
    for (final double? value in values) {
      if (value == null || !value.isFinite) {
        continue;
      }
      total += value;
      hasValue = true;
    }
    return hasValue ? total : null;
  }
}

/// Mutable aggregation seed used while merging chart points by security.
class _ChartSeed {
  /// Creates a chart seed with a stable ordering index.
  _ChartSeed({required this.order});

  /// Original insertion order used as fallback label order.
  final int order;

  /// Security code used for the short chart label.
  String? securityCode;

  /// Security name used when code is unavailable.
  String? securityName;

  // String? pointLabel;
  // DateTime? recordedAt;
  /// Primary series value.
  double? primaryValue;

  /// Optional secondary series value.
  double? secondaryValue;

  /// Whether either series contains a finite value.
  bool get hasRenderableData =>
      (primaryValue != null && primaryValue!.isFinite) ||
      (secondaryValue != null && secondaryValue!.isFinite);

  /// Short label shown on the chart x-axis.
  String get displayLabel {
    // final String? customLabel = _normalizedText(pointLabel);
    // if (customLabel != null) {
    //   return customLabel;
    // }
    //
    // if (recordedAt != null) {
    //   return DateFormat('MMM').format(recordedAt!.toLocal());
    // }

    final String? shortsecurityCode = _normalizedText(securityCode);
    if (shortsecurityCode != null) {
      return shortsecurityCode;
    }

    final String? shortsecurityName = _normalizedText(securityName);
    if (shortsecurityName != null) {
      return shortsecurityName.length > 6
          ? shortsecurityName.substring(0, 6)
          : shortsecurityName;
    }

    return 'P${order + 1}';
  }

  /// Merges one backend holding into this chart seed without overwriting data.
  void absorb(PortfolioHolding holding) {
    securityCode ??= _normalizedText(holding.securityCode);
    securityName ??= _normalizedText(holding.securityName);
    // pointLabel ??= _normalizedText(holding.pointLabel);
    // recordedAt ??= holding.recordedAt;

    final double? resolvedPrimaryValue =
        holding.holdingType == HoldingType.getStockAcntYieldDtl
        ? holding.currentValue
        : holding.buyAmount;
    if (resolvedPrimaryValue case final double value
        when value.isFinite && primaryValue == null) {
      primaryValue = value;
    }

    if (holding.holdingType == HoldingType.getStockAcntYieldDtl
            ? holding.totalYield
            : holding.profit
        case final double profit when profit.isFinite) {
      secondaryValue ??= profit;
    }
  }

  static String? _normalizedText(String? value) {
    final String trimmed = value?.trim() ?? '';
    if (trimmed.isEmpty) {
      return null;
    }
    return trimmed;
  }
}
