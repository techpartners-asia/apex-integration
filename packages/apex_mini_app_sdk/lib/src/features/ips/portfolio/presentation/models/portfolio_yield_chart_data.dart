import 'package:intl/intl.dart';

import '../../../shared/domain/models/ips_models.dart';

class PortfolioYieldChartPoint {
  const PortfolioYieldChartPoint({
    required this.label,
    required this.primaryValue,
    this.secondaryValue,
  });

  final String label;
  final double primaryValue;
  final double? secondaryValue;
}

class PortfolioYieldChartData {
  const PortfolioYieldChartData({
    this.points = const <PortfolioYieldChartPoint>[],
    this.primaryTotal,
    this.secondaryTotal,
  });

  final List<PortfolioYieldChartPoint> points;
  final double? primaryTotal;
  final double? secondaryTotal;

  bool get hasData => points.isNotEmpty;

  bool get hasSecondarySeries => points.any(
    (PortfolioYieldChartPoint point) => point.secondaryValue != null,
  );
}

final class PortfolioYieldChartDataMapper {
  const PortfolioYieldChartDataMapper._();

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

    final bool canSortByDate = seeds.every(
      (_ChartSeed seed) => seed.recordedAt != null,
    );

    final List<_ChartSeed> sortedSeeds = List<_ChartSeed>.from(seeds)
      ..sort((a, b) {
        if (canSortByDate) {
          return a.recordedAt!.compareTo(b.recordedAt!);
        }
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
    final String? code = _normalizedText(holding.code);
    if (code != null) {
      return 'code:$code';
    }

    final String? label = _normalizedText(holding.pointLabel);
    if (label != null) {
      return 'label:$label';
    }

    final String? name = _normalizedText(holding.name);
    if (name != null) {
      return 'name:$name';
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

class _ChartSeed {
  _ChartSeed({required this.order});

  final int order;
  String? code;
  String? name;
  String? pointLabel;
  DateTime? recordedAt;
  double? primaryValue;
  double? secondaryValue;

  bool get hasRenderableData =>
      (primaryValue != null && primaryValue!.isFinite) ||
      (secondaryValue != null && secondaryValue!.isFinite);

  String get displayLabel {
    final String? customLabel = _normalizedText(pointLabel);
    if (customLabel != null) {
      return customLabel;
    }

    if (recordedAt != null) {
      return DateFormat('MMM').format(recordedAt!.toLocal());
    }

    final String? shortCode = _normalizedText(code);
    if (shortCode != null) {
      return shortCode;
    }

    final String? shortName = _normalizedText(name);
    if (shortName != null) {
      return shortName.length > 6 ? shortName.substring(0, 6) : shortName;
    }

    return 'P${order + 1}';
  }

  void absorb(PortfolioHolding holding) {
    code ??= _normalizedText(holding.code);
    name ??= _normalizedText(holding.name);
    pointLabel ??= _normalizedText(holding.pointLabel);
    recordedAt ??= holding.recordedAt;

    if (holding.currentValue.isFinite && primaryValue == null) {
      primaryValue = holding.currentValue;
    }

    if (holding.profitAmount case final double profit when profit.isFinite) {
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
