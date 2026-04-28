import 'package:mini_app_sdk/mini_app_sdk.dart';

enum IpsStatementDateFilter { all, today, week, month, threeMonths }

class IpsStatementFilter {
  static const double defaultMinAmount = 0;
  static const double defaultMaxAmount = 1000000;

  final double minAmount;
  final double maxAmount;
  final IpsStatementDateFilter dateFilter;

  const IpsStatementFilter({
    this.minAmount = defaultMinAmount,
    this.maxAmount = defaultMaxAmount,
    this.dateFilter = IpsStatementDateFilter.all,
  });

  bool get hasAmountFilter =>
      minAmount > defaultMinAmount || maxAmount < defaultMaxAmount;

  bool get hasDateFilter => dateFilter != IpsStatementDateFilter.all;

  bool get isEmpty => !hasAmountFilter && !hasDateFilter;

  int get activeFilterCount {
    int count = 0;
    if (hasAmountFilter) count++;
    if (hasDateFilter) count++;
    return count;
  }

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

class _IpsStatementDateRange {
  final String startDate;
  final String endDate;

  const _IpsStatementDateRange({
    required this.startDate,
    required this.endDate,
  });
}

class IpsStatementsViewData {
  final PortfolioStatementsData sourceStatements;
  final PortfolioStatementsData statements;
  final SdkPortfolioContext portfolioContext;
  final IpsStatementFilter filter;

  IpsStatementsViewData({
    required PortfolioStatementsData statements,
    this.filter = const IpsStatementFilter(),
    this.portfolioContext = const SdkPortfolioContext(),
  }) : sourceStatements = statements,
       statements = filter.apply(statements);

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
