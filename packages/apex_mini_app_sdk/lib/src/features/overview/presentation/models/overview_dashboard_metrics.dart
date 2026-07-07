import 'package:apex_mini_app_sdk/apex_mini_app_sdk.dart';
import 'package:flutter/material.dart';

/// Presentation-ready financial metrics for the overview dashboard.
class OverviewDashboardMetrics {
  /// Short user name shown in the greeting.
  final String shortDisplayName;

  /// Total investment amount.
  final double totalInvestment;

  /// Formatted total investment label.
  final String totalInvestmentLabel;

  /// Total stock allocation value.
  final double stockTotal;

  /// Formatted stock allocation label.
  final String stockTotalLabel;

  /// Total bond allocation value.
  final double bondTotal;

  /// Formatted bond allocation label.
  final String bondTotalLabel;

  /// Total cash allocation value.
  final double cashTotal;

  /// Formatted cash allocation label.
  final String cashTotalLabel;

  /// Formatted label for stock + bond + cash combined total shown in the allocation card.
  final String allocationTotalLabel;

  /// Profit/loss amount.
  final double profit;

  /// Formatted profit/loss label.
  final String profitLabel;

  /// Formatted profit/loss percent label.
  final String profitPercentLabel;

  /// Color used to show positive or negative profit tone.
  final Color profitTone;

  /// Package/performance section visibility state.
  final PortfolioPackageVisibility packageVisibility;

  /// Current progress toward the target goal.
  final double goalCurrent;

  /// Formatted current goal progress label.
  final String goalCurrentLabel;

  /// Target goal amount.
  final double goalTarget;

  /// Formatted target goal label.
  final String goalTargetLabel;

  /// Full loyalty info (title, content, streak, loyalty) from the backend.
  final LoyaltyInfoDto? loyaltyInfo;

  final PortfolioPackDetail packDetail;

  /// Creates dashboard metrics.
  const OverviewDashboardMetrics({
    required this.shortDisplayName,
    required this.totalInvestment,
    required this.totalInvestmentLabel,
    required this.stockTotal,
    required this.stockTotalLabel,
    required this.bondTotal,
    required this.bondTotalLabel,
    this.cashTotal = 0,
    this.cashTotalLabel = '',
    this.allocationTotalLabel = '',
    required this.profit,
    required this.profitLabel,
    required this.profitPercentLabel,
    required this.profitTone,
    required this.packageVisibility,
    required this.goalCurrent,
    required this.goalCurrentLabel,
    required this.goalTarget,
    required this.goalTargetLabel,
    this.loyaltyInfo,
    required this.packDetail,
  });

  /// Whether package info, performance, and related blocks should render.
  bool get shouldRenderPackageBlocks => packageVisibility.shouldRenderPackageBlocks;

  /// Resolves UI metrics from bootstrap, portfolio, holding, and user data.
  static OverviewDashboardMetrics resolve(
    BuildContext context, {
    required AcntBootstrapState bootstrapState,
    required PortfolioOverview? overview,
    List<PortfolioHolding> yieldProfitHoldings = const <PortfolioHolding>[],
    List<PortfolioHolding> stockYieldDetails = const <PortfolioHolding>[],
    required UserEntityDto? user,
    LoyaltyInfoDto? loyaltyInfo,
  }) {
    final String currency = _resolveCurrency(bootstrapState, overview);
    final double? stockTotalFromYieldDetails = _sumHoldingsCurrentValue(
      stockYieldDetails,
    );
    final double? stockTotalFromYieldProfit = _sumHoldingsCurrentValue(
      yieldProfitHoldings,
    );
    final double totalInvestment =
        _firstMeaningful(
          overview?.investedBalance,
          _sumIfAny(overview?.stockTotal, overview?.bondTotal),
          overview?.packAmount,
          stockTotalFromYieldDetails,
          stockTotalFromYieldProfit,
          bootstrapState.ipsBalance,
          bootstrapState.secBalance,
        ) ??
        0;
    final double stockTotal =
        _firstMeaningful(
          overview?.stockTotal,
          stockTotalFromYieldDetails,
          stockTotalFromYieldProfit,
        ) ??
        0;
    final double bondTotal = _firstMeaningful(overview?.bondTotal) ?? 0;
    final double cashTotal = _firstMeaningful(overview?.cashTotal) ?? 0;
    final double holdingsProfit = yieldProfitHoldings.isNotEmpty
        ? yieldProfitHoldings.fold<double>(
            0,
            (double sum, PortfolioHolding item) => sum + ((item.holdingType == HoldingType.getStockAcntYieldDtl ? item.totalYield : item.profit) ?? 0),
          )
        : stockYieldDetails.isNotEmpty
        ? stockYieldDetails.fold<double>(
            0,
            (double sum, PortfolioHolding item) => sum + ((item.holdingType == HoldingType.getStockAcntYieldDtl ? item.totalYield : item.profit) ?? 0),
          )
        : 0;
    final double profit =
        _firstNonZero(
          overview?.profitOrLoss,
          holdingsProfit,
          overview?.yieldAmount,
        ) ??
        0;
    final double goalCurrent = _firstMeaningful(overview?.stockTotal, totalInvestment) ?? 0;
    final double goalTarget = _firstMeaningful(user?.account?.targetGoal?.toDouble(), 1000000) ?? 1000000;
    final double profitRatio = totalInvestment > 0 ? profit / totalInvestment : 0;
    final PortfolioPackageVisibility packageVisibility = PortfolioPackageVisibility.resolve(
      overview: overview,
      user: user,
      resolvedReturnsAmount: profit,
      resolvedReturnsPercent: profitRatio,
    );

    return OverviewDashboardMetrics(
      shortDisplayName: _resolveShortDisplayName(context, user),
      totalInvestment: totalInvestment,
      totalInvestmentLabel: formatIpsPaymentAmount(totalInvestment, currency),
      stockTotal: stockTotal,
      stockTotalLabel: formatIpsPaymentAmount(stockTotal, currency),
      bondTotal: bondTotal,
      bondTotalLabel: formatIpsPaymentAmount(bondTotal, currency),
      cashTotal: cashTotal,
      cashTotalLabel: formatIpsPaymentAmount(cashTotal, currency),
      allocationTotalLabel: formatIpsPaymentAmount(stockTotal + bondTotal + cashTotal, currency),
      profit: profit,
      profitLabel: _formatSignedAmount(profit, currency),
      profitPercentLabel: _formatPercent(profitRatio),
      profitTone: profit < 0 ? DesignTokens.danger : DesignTokens.success,
      packageVisibility: packageVisibility,
      goalCurrent: goalCurrent,
      goalCurrentLabel: formatIpsPaymentAmount(goalCurrent, currency),
      goalTarget: goalTarget,
      goalTargetLabel: formatIpsPaymentAmount(goalTarget, currency),
      loyaltyInfo: loyaltyInfo,
      packDetail: overview?.packDetail ?? PortfolioPackDetail(),
    );
  }

  static String _resolveCurrency(
    AcntBootstrapState bootstrapState,
    PortfolioOverview? overview,
  ) {
    final String candidate = overview?.currency.trim() ?? '';
    return candidate.isNotEmpty ? candidate : bootstrapState.currency;
  }

  static double? _firstMeaningful(
    double? first, [
    double? second,
    double? third,
    double? fourth,
    double? fifth,
    double? sixth,
    double? seventh,
  ]) {
    for (final double? value in <double?>[
      first,
      second,
      third,
      fourth,
      fifth,
      sixth,
      seventh,
    ]) {
      if (value != null && value.isFinite) {
        return value;
      }
    }
    return null;
  }

  static double? _sumIfAny(double? first, double? second) {
    if (first == null && second == null) {
      return null;
    }
    return (first ?? 0) + (second ?? 0);
  }

  static double? _firstNonZero(double? first, [double? second, double? third]) {
    for (final double? value in <double?>[first, second, third]) {
      if (value != null && value.isFinite && value != 0) {
        return value;
      }
    }
    return null;
  }

  static double? _sumHoldingsCurrentValue(List<PortfolioHolding> holdings) {
    if (holdings.isEmpty) {
      return null;
    }

    double total = 0;
    bool hasValue = false;
    for (final PortfolioHolding holding in holdings) {
      if (!(holding.holdingType == HoldingType.getStockAcntYieldDtl ? holding.currentValue : holding.buyAmount)!.isFinite) {
        continue;
      }
      total += (holding.holdingType == HoldingType.getStockAcntYieldDtl ? holding.currentValue : holding.buyAmount) ?? 0;
      hasValue = true;
    }
    return hasValue ? total : null;
  }

  static String _resolveShortDisplayName(
    BuildContext context,
    UserEntityDto? user,
  ) {
    if (user == null) {
      return context.l10n.ipsOverviewProfileGuestName;
    }

    final String firstName = user.firstName ?? '';
    final String lastName = user.lastName ?? '';
    if (firstName.isNotNullOrEmpty && lastName.isNotNullOrEmpty) {
      return '${lastName.substring(0, 1)}.$firstName';
    }
    if (firstName.isNotEmpty) {
      return firstName;
    }
    return user.displayName;
  }

  static String _formatSignedAmount(double value, String currency) {
    final String prefix = value > 0
        ? ''
        : value < 0
        ? '-'
        : '';
    return '$prefix${formatIpsPaymentAmount(value.abs(), currency)}';
  }

  static String _formatPercent(double value) {
    final double normalized = value * 100;
    final String prefix = normalized > 0
        ? ''
        : normalized < 0
        ? '-'
        : '';
    return '$prefix${normalized.abs().toStringAsFixed(0)}%';
  }
}
