import 'package:flutter/material.dart';
import 'package:mini_app_sdk/mini_app_sdk.dart';

class OverviewDashboardMetrics {
  final String shortDisplayName;
  final double totalInvestment;
  final String totalInvestmentLabel;
  final double stockTotal;
  final String stockTotalLabel;
  final double bondTotal;
  final String bondTotalLabel;
  final double profit;
  final String profitLabel;
  final String profitPercentLabel;
  final Color profitTone;
  final double goalCurrent;
  final String goalCurrentLabel;
  final double goalTarget;
  final String goalTargetLabel;
  final int streakMonths;

  const OverviewDashboardMetrics({
    required this.shortDisplayName,
    required this.totalInvestment,
    required this.totalInvestmentLabel,
    required this.stockTotal,
    required this.stockTotalLabel,
    required this.bondTotal,
    required this.bondTotalLabel,
    required this.profit,
    required this.profitLabel,
    required this.profitPercentLabel,
    required this.profitTone,
    required this.goalCurrent,
    required this.goalCurrentLabel,
    required this.goalTarget,
    required this.goalTargetLabel,
    required this.streakMonths,
  });

  static OverviewDashboardMetrics resolve(
    BuildContext context, {
    required AcntBootstrapState bootstrapState,
    required PortfolioOverview? overview,
    List<PortfolioHolding> yieldProfitHoldings = const <PortfolioHolding>[],
    List<PortfolioHolding> stockYieldDetails = const <PortfolioHolding>[],
    required UserEntityDto? user,
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
    final double holdingsProfit = yieldProfitHoldings.isNotEmpty
        ? yieldProfitHoldings.fold<double>(
            0,
            (double sum, PortfolioHolding item) =>
                sum + (item.profitAmount ?? 0),
          )
        : stockYieldDetails.isNotEmpty
        ? stockYieldDetails.fold<double>(
            0,
            (double sum, PortfolioHolding item) =>
                sum + (item.profitAmount ?? 0),
          )
        : 0;
    final double profit =
        overview?.profitOrLoss ??
        (holdingsProfit != 0 ? holdingsProfit : null) ??
        overview?.yieldAmount ??
        0;
    final double goalCurrent =
        _firstMeaningful(overview?.stockTotal, totalInvestment) ?? 0;
    final double goalTarget =
        _firstMeaningful(user?.account?.targetGoal?.toDouble(), 1000000) ??
        1000000;
    final double profitRatio = totalInvestment > 0
        ? profit / totalInvestment
        : 0;

    return OverviewDashboardMetrics(
      shortDisplayName: _resolveShortDisplayName(context, user),
      totalInvestment: totalInvestment,
      totalInvestmentLabel: formatIpsPaymentAmount(totalInvestment, currency),
      stockTotal: stockTotal,
      stockTotalLabel: formatIpsPaymentAmount(stockTotal, currency),
      bondTotal: bondTotal,
      bondTotalLabel: formatIpsPaymentAmount(bondTotal, currency),
      profit: profit,
      profitLabel: _formatSignedAmount(profit, currency),
      profitPercentLabel: _formatPercent(profitRatio),
      profitTone: profit < 0 ? DesignTokens.danger : DesignTokens.success,
      goalCurrent: goalCurrent,
      goalCurrentLabel: formatIpsPaymentAmount(goalCurrent, currency),
      goalTarget: goalTarget,
      goalTargetLabel: formatIpsPaymentAmount(goalTarget, currency),
      streakMonths: 12,
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

  static double? _sumHoldingsCurrentValue(List<PortfolioHolding> holdings) {
    if (holdings.isEmpty) {
      return null;
    }

    double total = 0;
    bool hasValue = false;
    for (final PortfolioHolding holding in holdings) {
      if (!holding.currentValue.isFinite) {
        continue;
      }
      total += holding.currentValue;
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
        ? '+'
        : value < 0
        ? '-'
        : '';
    return '$prefix${formatIpsPaymentAmount(value.abs(), currency)}';
  }

  static String _formatPercent(double value) {
    final double normalized = value * 100;
    final String prefix = normalized > 0
        ? '+'
        : normalized < 0
        ? '-'
        : '';
    return '$prefix${normalized.abs().toStringAsFixed(0)}%';
  }
}
