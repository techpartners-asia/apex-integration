import 'package:apex_mini_app_sdk/apex_mini_app_sdk.dart';

/// Date preset used by the statements filter sheet.
enum IpsStatementDateFilter { all, today, week, month, threeMonths }

/// Client-side and request-side filter for portfolio statements.
class IpsStatementFilter {
  /// Default minimum amount for an unfiltered amount range.
  static const double defaultMinAmount = 0;

  /// Default maximum amount for an unfiltered amount range.
  static const double defaultMaxAmount = 1000000;

  /// Minimum absolute transaction amount.
  final double minAmount;

  /// Maximum absolute transaction amount.
  final double maxAmount;

  /// Selected date preset.
  final IpsStatementDateFilter dateFilter;

  /// Creates a statement filter.
  const IpsStatementFilter({
    this.minAmount = defaultMinAmount,
    this.maxAmount = defaultMaxAmount,
    this.dateFilter = IpsStatementDateFilter.all,
  });

  /// Whether the amount range differs from defaults.
  bool get hasAmountFilter =>
      minAmount > defaultMinAmount || maxAmount < defaultMaxAmount;

  /// Whether a date preset is active.
  bool get hasDateFilter => dateFilter != IpsStatementDateFilter.all;

  /// Whether no filter is active.
  bool get isEmpty => !hasAmountFilter && !hasDateFilter;

  /// Number of active filter groups.
  int get activeFilterCount {
    int count = 0;
    if (hasAmountFilter) count++;
    if (hasDateFilter) count++;
    return count;
  }

  /// Applies client-side amount filtering to a statement response.
  PortfolioStatementsData apply(PortfolioStatementsData source) {
    if (!hasAmountFilter) return source;

    final List<MgBkrCasaAcntStatementResDataDto> filtered = source.stmtList
        .where((MgBkrCasaAcntStatementResDataDto statement) {
          return _matchesAmount(statement);
        })
        .toList(growable: false);

    return PortfolioStatementsData(
      summary: source.summary,
      currency: source.currency,
      startDate: source.startDate,
      endDate: source.endDate,
      beginBalance: source.beginBalance,
      endBalance: source.endBalance,
      totalCount: filtered.length,
      pageCount: source.pageCount,
      totalPage: source.totalPage,
      custName: source.custName,
      txnDate: source.txnDate,
      resultValue: source.resultValue,
      stmtList: filtered,
    );
  }

  /// Builds a statement request context with date range overrides if needed.
  SdkPortfolioContext? resolveRequestContext(
    SdkPortfolioContext? baseContext, {
    DateTime? now,
  }) {
    if (!hasDateFilter) return baseContext;

    final _IpsStatementDateRange range = _dateRange(now ?? DateTime.now());
    return (baseContext ?? const SdkPortfolioContext()).copyWith(
      stmtStartDate: range.startDate,
      stmtEndDate: range.endDate,
    );
  }

  bool _matchesAmount(MgBkrCasaAcntStatementResDataDto statement) {
    if (!hasAmountFilter) return true;

    final double lower = minAmount <= maxAmount ? minAmount : maxAmount;
    final double upper = minAmount <= maxAmount ? maxAmount : minAmount;
    final double amount = statement.amount.abs();
    return amount >= lower && amount <= upper;
  }

  _IpsStatementDateRange _dateRange(DateTime now) {
    final DateTime normalizedNow = DateTime(now.year, now.month, now.day);
    final DateTime startDate = switch (dateFilter) {
      IpsStatementDateFilter.all => normalizedNow,
      IpsStatementDateFilter.today => normalizedNow,
      IpsStatementDateFilter.week => normalizedNow.subtract(
        const Duration(days: 7),
      ),
      IpsStatementDateFilter.month => normalizedNow.subtract(
        const Duration(days: 30),
      ),
      IpsStatementDateFilter.threeMonths => normalizedNow.subtract(
        const Duration(days: 90),
      ),
    };

    return _IpsStatementDateRange(
      startDate: _formatDate(startDate),
      endDate: _formatDate(normalizedNow),
    );
  }

  String _formatDate(DateTime value) {
    final String year = value.year.toString().padLeft(4, '0');
    final String month = value.month.toString().padLeft(2, '0');
    final String day = value.day.toString().padLeft(2, '0');
    return '$year-$month-$day';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is IpsStatementFilter &&
        other.minAmount == minAmount &&
        other.maxAmount == maxAmount &&
        other.dateFilter == dateFilter;
  }

  @override
  int get hashCode => Object.hash(minAmount, maxAmount, dateFilter);
}

/// Concrete backend date range for one statement filter preset.
class _IpsStatementDateRange {
  /// Start date in backend `yyyy-MM-dd` format.
  final String startDate;

  /// End date in backend `yyyy-MM-dd` format.
  final String endDate;

  /// Creates a statement date range.
  const _IpsStatementDateRange({
    required this.startDate,
    required this.endDate,
  });
}

/// View model for the statements screen.
class IpsStatementsViewData {
  /// Original unfiltered statement response.
  final PortfolioStatementsData sourceStatements;

  /// Filtered statements displayed in the UI.
  final PortfolioStatementsData statements;

  /// Portfolio/account context used to fetch statements.
  final SdkPortfolioContext portfolioContext;

  /// Active statement filter.
  final IpsStatementFilter filter;

  /// Creates statement view data and applies the active filter.
  IpsStatementsViewData({
    required PortfolioStatementsData statements,
    this.filter = const IpsStatementFilter(),
    this.portfolioContext = const SdkPortfolioContext(),
  }) : sourceStatements = statements,
       statements = filter.apply(statements);

  /// Returns a copy and reapplies the selected filter to the source statements.
  IpsStatementsViewData copyWith({
    PortfolioStatementsData? statements,
    SdkPortfolioContext? portfolioContext,
    IpsStatementFilter? filter,
  }) {
    return IpsStatementsViewData(
      statements: statements ?? sourceStatements,
      portfolioContext: portfolioContext ?? this.portfolioContext,
      filter: filter ?? this.filter,
    );
  }
}
