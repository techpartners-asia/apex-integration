import 'package:apex_mini_app_sdk/apex_mini_app_sdk.dart';

/// Visibility state for package detail and performance UI blocks.
///
/// The dashboard and portfolio views should only render package/returns blocks
/// when a package is activated and both package data and returns data are
/// meaningful. A zero or missing value is treated as hidden data.
final class PortfolioPackageVisibility {
  /// Whether the user has an activated or purchased investment package.
  final bool isPackageActivated;

  /// Whether package detail values are non-zero.
  final bool hasPackageDetails;

  /// Whether return/profit/yield values are non-zero.
  final bool hasReturns;

  /// Creates package visibility state.
  const PortfolioPackageVisibility({
    required this.isPackageActivated,
    required this.hasPackageDetails,
    required this.hasReturns,
  });

  /// Whether package info, performance, and related data blocks should render.
  bool get shouldRenderPackageBlocks =>
      isPackageActivated && hasPackageDetails && hasReturns;

  /// Resolves visibility from portfolio and optional user/account state.
  factory PortfolioPackageVisibility.resolve({
    PortfolioOverview? overview,
    UserEntityDto? user,
    double? resolvedReturnsAmount,
    double? resolvedReturnsPercent,
    double? chartReturnsAmount,
  }) {
    final AccountDto? account = user?.account;
    final String accountPackageCode = account?.packageCode?.trim() ?? '';
    final String packDetailCode = overview?.packDetail?.packCode?.trim() ?? '';
    final bool hasAccountPackage =
        accountPackageCode.isNotEmpty &&
        (account?.isInvest == true || account?.isInvestContract == true);

    return PortfolioPackageVisibility(
      isPackageActivated:
          _isPositive(overview?.packQty) ||
          packDetailCode.isNotEmpty ||
          hasAccountPackage,
      hasPackageDetails:
          _isPositive(overview?.packAmount) ||
          _isPositive(overview?.investedBalance) ||
          _isPositive(overview?.stockTotal) ||
          _isPositive(overview?.bondTotal) ||
          _isPositive(account?.investAmount?.toDouble()) ||
          _isPositive(account?.totalAmount?.toDouble()),
      hasReturns:
          _isNonZero(resolvedReturnsAmount) ||
          _isNonZero(resolvedReturnsPercent) ||
          _isNonZero(chartReturnsAmount) ||
          _isNonZero(overview?.profitOrLoss) ||
          _isNonZero(overview?.yieldAmount) ||
          _isNonZero(overview?.profitPercent) ||
          _isNonZero(account?.profitAmount?.toDouble()) ||
          _isNonZero(account?.profitPercent?.toDouble()),
    );
  }

  static bool _isPositive(double? value) {
    return value != null && value.isFinite && value > 0;
  }

  static bool _isNonZero(double? value) {
    return value != null && value.isFinite && value != 0;
  }
}
