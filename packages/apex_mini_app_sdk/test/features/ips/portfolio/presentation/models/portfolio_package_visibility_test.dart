import 'package:apex_mini_app_sdk/apex_mini_app_sdk.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('PortfolioPackageVisibility', () {
    test('renders when package is active and details/returns are non-zero', () {
      final PortfolioPackageVisibility visibility =
          PortfolioPackageVisibility.resolve(
            overview: const PortfolioOverview(
              currency: 'MNT',
              packQty: 1,
              packAmount: 100000,
              profitOrLoss: 5000,
            ),
          );

      expect(visibility.isPackageActivated, isTrue);
      expect(visibility.hasPackageDetails, isTrue);
      expect(visibility.hasReturns, isTrue);
      expect(visibility.shouldRenderPackageBlocks, isTrue);
    });

    test('hides when the package is not activated', () {
      final PortfolioPackageVisibility visibility =
          PortfolioPackageVisibility.resolve(
            overview: const PortfolioOverview(
              currency: 'MNT',
              packAmount: 100000,
              profitOrLoss: 5000,
            ),
          );

      expect(visibility.isPackageActivated, isFalse);
      expect(visibility.shouldRenderPackageBlocks, isFalse);
    });

    test('hides when package details are zero', () {
      final PortfolioPackageVisibility visibility =
          PortfolioPackageVisibility.resolve(
            overview: const PortfolioOverview(
              currency: 'MNT',
              packQty: 1,
              packAmount: 0,
              investedBalance: 0,
              stockTotal: 0,
              bondTotal: 0,
              profitOrLoss: 5000,
            ),
          );

      expect(visibility.hasPackageDetails, isFalse);
      expect(visibility.shouldRenderPackageBlocks, isFalse);
    });

    test('hides when return amount and percentage are zero', () {
      final PortfolioPackageVisibility visibility =
          PortfolioPackageVisibility.resolve(
            overview: const PortfolioOverview(
              currency: 'MNT',
              packQty: 1,
              packAmount: 100000,
              profitOrLoss: 0,
              yieldAmount: 0,
              profitPercent: 0,
            ),
          );

      expect(visibility.hasReturns, isFalse);
      expect(visibility.shouldRenderPackageBlocks, isFalse);
    });

    test('uses account package status when overview only has values', () {
      final PortfolioPackageVisibility visibility =
          PortfolioPackageVisibility.resolve(
            overview: const PortfolioOverview(
              currency: 'MNT',
              packAmount: 100000,
              profitOrLoss: 5000,
            ),
            user: UserEntityDto(
              account: AccountDto(
                isInvestContract: true,
                packageCode: 'PKG01',
              ),
            ),
          );

      expect(visibility.isPackageActivated, isTrue);
      expect(visibility.shouldRenderPackageBlocks, isTrue);
    });

    test('uses chart return total as a return fallback', () {
      final PortfolioPackageVisibility visibility =
          PortfolioPackageVisibility.resolve(
            overview: const PortfolioOverview(
              currency: 'MNT',
              packQty: 1,
              packAmount: 100000,
              profitOrLoss: 0,
              profitPercent: 0,
            ),
            chartReturnsAmount: 5000,
          );

      expect(visibility.hasReturns, isTrue);
      expect(visibility.shouldRenderPackageBlocks, isTrue);
    });
  });
}
