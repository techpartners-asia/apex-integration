import 'package:flutter_test/flutter_test.dart';
import 'package:mini_app_sdk/src/features/ips/portfolio/presentation/models/portfolio_yield_chart_data.dart';
import 'package:mini_app_sdk/src/features/ips/shared/domain/models/ips_models.dart';

void main() {
  group('PortfolioYieldChartDataMapper', () {
    test('merges real response lists and keeps backend-backed values', () {
      final PortfolioYieldChartData data =
          PortfolioYieldChartDataMapper.fromResponses(
            yieldProfitHoldings: <PortfolioHolding>[
              PortfolioHolding(
                code: 'AAA',
                name: 'Alpha',
                quantity: 1,
                currentValue: 120,
                profitAmount: 12,
                pointLabel: 'Jan',
                recordedAt: DateTime.utc(2026, 1, 1),
              ),
              PortfolioHolding(
                code: 'CCC',
                name: 'Charlie',
                quantity: 1,
                currentValue: 320,
                profitAmount: 32,
                pointLabel: 'Mar',
                recordedAt: DateTime.utc(2026, 3, 1),
              ),
            ],
            stockYieldDetails: <PortfolioHolding>[
              PortfolioHolding(
                code: 'BBB',
                name: 'Bravo',
                quantity: 1,
                currentValue: 220,
                profitAmount: 22,
                pointLabel: 'Feb',
                recordedAt: DateTime.utc(2026, 2, 1),
              ),
              PortfolioHolding(
                code: 'AAA',
                name: 'Alpha detail',
                quantity: 1,
                currentValue: 999,
                profitAmount: 99,
                pointLabel: 'Jan',
                recordedAt: DateTime.utc(2026, 1, 1),
              ),
            ],
          );

      expect(data.hasData, isTrue);
      expect(data.points, hasLength(3));
      expect(data.points.map((e) => e.label), <String>['Jan', 'Feb', 'Mar']);
      expect(data.points.first.primaryValue, 120);
      expect(data.points.first.secondaryValue, 12);
      expect(data.primaryTotal, 660);
      expect(data.secondaryTotal, 66);
    });

    test('returns empty when all mapped values are invalid', () {
      final PortfolioYieldChartData data =
          PortfolioYieldChartDataMapper.fromResponses(
            yieldProfitHoldings: const <PortfolioHolding>[
              PortfolioHolding(
                code: 'BAD',
                name: 'Broken',
                quantity: 0,
                currentValue: double.nan,
                profitAmount: double.nan,
              ),
            ],
            stockYieldDetails: const <PortfolioHolding>[],
          );

      expect(data.hasData, isFalse);
      expect(data.points, isEmpty);
      expect(data.primaryTotal, isNull);
      expect(data.secondaryTotal, isNull);
    });
  });
}
