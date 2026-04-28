import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mini_app_sdk/mini_app_sdk.dart';

void main() {
  test('load fetches statement data from the statement API path', () async {
    final _FakePortfolioService service = _FakePortfolioService(
      statements: const PortfolioStatementsData(
        summary: '2026-04-01  2026-04-09 • begin 100 • end 250 • 2 entries',
        currency: 'MNT',
        startDate: '2026-04-01',
        endDate: '2026-04-09',
        beginBalance: 100,
        endBalance: 250,
        totalCount: 2,
        pageCount: 2,
        totalPage: 2,
        stmtList: <MgBkrCasaAcntStatementResDataDto>[
          MgBkrCasaAcntStatementResDataDto(
            description: 'Recharge',
            credit: 150,
            debit: 0,
          ),
        ],
      ),
    );
    final IpsStatementsCubit cubit = IpsStatementsCubit(
      service: service,
      l10n: lookupSdkLocalizations(const Locale('en')),
    );
    const SdkPortfolioContext context = SdkPortfolioContext(
      casaAcntId: 10,
      stmtStartDate: '2026-04-01',
      stmtEndDate: '2026-04-09',
    );

    await cubit.load(context: context);

    expect(service.getStatementsCallCount, 1);
    expect(service.lastContext?.casaAcntId, 10);
    expect(cubit.state.status, LoadableStatus.success);
    expect(cubit.state.data, isA<IpsStatementsViewData>());
    expect(cubit.state.data?.statements.stmtList, hasLength(1));
  });

  test(
    'applyFilter filters loaded statements and clearFilter restores source data',
    () async {
      final _FakePortfolioService service = _FakePortfolioService(
        statements: const PortfolioStatementsData(
          summary: 'summary',
          currency: 'MNT',
          startDate: '2026-04-01',
          endDate: '2026-04-09',
          totalCount: 3,
          pageCount: 1,
          totalPage: 1,
          stmtList: <MgBkrCasaAcntStatementResDataDto>[
            MgBkrCasaAcntStatementResDataDto(
              description: 'Small fee',
              credit: 0,
              debit: 10,
            ),
            MgBkrCasaAcntStatementResDataDto(
              description: 'Recharge',
              credit: 150,
              debit: 0,
            ),
            MgBkrCasaAcntStatementResDataDto(
              description: 'Large debit',
              credit: 0,
              debit: 500,
            ),
          ],
        ),
      );
      final IpsStatementsCubit cubit = IpsStatementsCubit(
        service: service,
        l10n: lookupSdkLocalizations(const Locale('en')),
      );

      await cubit.load();
      await cubit.applyFilter(
        const IpsStatementFilter(minAmount: 100, maxAmount: 200),
      );

      expect(cubit.state.data?.filter.activeFilterCount, 1);
      expect(cubit.state.data?.statements.stmtList, hasLength(1));
      expect(
        cubit.state.data?.statements.stmtList.single.description,
        'Recharge',
      );

      await cubit.clearFilter();

      expect(cubit.state.data?.filter.isEmpty, isTrue);
      expect(cubit.state.data?.statements.stmtList, hasLength(3));
    },
  );

  test('load preserves the selected filter after refresh', () async {
    final _FakePortfolioService service = _FakePortfolioService(
      statements: const PortfolioStatementsData(
        summary: 'summary',
        currency: 'MNT',
        startDate: '2026-04-01',
        endDate: '2026-04-09',
        totalCount: 2,
        pageCount: 1,
        totalPage: 1,
        stmtList: <MgBkrCasaAcntStatementResDataDto>[
          MgBkrCasaAcntStatementResDataDto(
            description: 'Small fee',
            credit: 0,
            debit: 10,
          ),
          MgBkrCasaAcntStatementResDataDto(
            description: 'Recharge',
            credit: 150,
            debit: 0,
          ),
        ],
      ),
    );
    final IpsStatementsCubit cubit = IpsStatementsCubit(
      service: service,
      l10n: lookupSdkLocalizations(const Locale('en')),
    );

    await cubit.load();
    await cubit.applyFilter(
      const IpsStatementFilter(minAmount: 100, maxAmount: 200),
    );
    await cubit.load();

    expect(service.getStatementsCallCount, 2);
    expect(cubit.state.data?.filter.activeFilterCount, 1);
    expect(cubit.state.data?.statements.stmtList, hasLength(1));
    expect(cubit.state.data?.sourceStatements.stmtList, hasLength(2));
  });

  test('date filter reloads statements with API date range params', () async {
    final _FakePortfolioService service = _FakePortfolioService(
      statements: const PortfolioStatementsData(
        summary: 'summary',
        currency: 'MNT',
        startDate: '2026-04-01',
        endDate: '2026-04-09',
        totalCount: 1,
        pageCount: 1,
        totalPage: 1,
        stmtList: <MgBkrCasaAcntStatementResDataDto>[
          MgBkrCasaAcntStatementResDataDto(
            description: 'Backend returned row',
            credit: 100,
            debit: 0,
            txnDate: 'not-a-local-date-format',
          ),
        ],
      ),
    );
    final IpsStatementsCubit cubit = IpsStatementsCubit(
      service: service,
      l10n: lookupSdkLocalizations(const Locale('en')),
    );
    const SdkPortfolioContext baseContext = SdkPortfolioContext(
      casaAcntId: 10,
      stmtStartDate: '2026-04-01',
      stmtEndDate: '2026-04-09',
    );
    final DateTime today = _dateOnly(DateTime.now());

    await cubit.load(context: baseContext);
    await cubit.applyFilter(
      const IpsStatementFilter(dateFilter: IpsStatementDateFilter.week),
    );

    expect(service.getStatementsCallCount, 2);
    expect(service.lastContext?.casaAcntId, 10);
    expect(
      service.lastContext?.stmtStartDate,
      _formatDate(today.subtract(const Duration(days: 7))),
    );
    expect(service.lastContext?.stmtEndDate, _formatDate(today));
    expect(cubit.state.data?.filter.dateFilter, IpsStatementDateFilter.week);
    expect(cubit.state.data?.statements.stmtList, hasLength(1));
  });

  test('clearFilter restores the default statement request range', () async {
    final _FakePortfolioService service = _FakePortfolioService(
      statements: const PortfolioStatementsData(
        summary: 'summary',
        currency: 'MNT',
        startDate: '2026-04-01',
        endDate: '2026-04-09',
        totalCount: 1,
        pageCount: 1,
        totalPage: 1,
        stmtList: <MgBkrCasaAcntStatementResDataDto>[
          MgBkrCasaAcntStatementResDataDto(
            description: 'Recharge',
            credit: 150,
            debit: 0,
          ),
        ],
      ),
    );
    final IpsStatementsCubit cubit = IpsStatementsCubit(
      service: service,
      l10n: lookupSdkLocalizations(const Locale('en')),
    );
    const SdkPortfolioContext baseContext = SdkPortfolioContext(
      casaAcntId: 10,
      stmtStartDate: '2026-04-01',
      stmtEndDate: '2026-04-09',
    );

    await cubit.load(context: baseContext);
    await cubit.applyFilter(
      const IpsStatementFilter(dateFilter: IpsStatementDateFilter.month),
    );
    await cubit.clearFilter();

    expect(service.getStatementsCallCount, 3);
    expect(service.lastContext?.casaAcntId, 10);
    expect(service.lastContext?.stmtStartDate, '2026-04-01');
    expect(service.lastContext?.stmtEndDate, '2026-04-09');
    expect(cubit.state.data?.filter.isEmpty, isTrue);
    expect(cubit.state.data?.statements.stmtList, hasLength(1));
  });

  test(
    'business error clears stale statements and keeps the screen in empty state',
    () async {
      final _FakePortfolioService service = _FakePortfolioService(
        statements: const PortfolioStatementsData(
          summary: 'summary',
          currency: 'MNT',
          startDate: '2026-04-01',
          endDate: '2026-04-09',
          totalCount: 1,
          pageCount: 1,
          totalPage: 1,
          stmtList: <MgBkrCasaAcntStatementResDataDto>[
            MgBkrCasaAcntStatementResDataDto(
              description: 'Existing statement',
              credit: 200,
              debit: 0,
            ),
          ],
        ),
      );
      final IpsStatementsCubit cubit = IpsStatementsCubit(
        service: service,
        l10n: lookupSdkLocalizations(const Locale('en')),
      );

      await cubit.load();
      expect(cubit.state.data?.statements.stmtList, hasLength(1));

      service.error = const ApiBusinessException(
        responseCode: 9999,
        message: 'Системийн алдаа!',
      );
      await cubit.applyFilter(
        const IpsStatementFilter(dateFilter: IpsStatementDateFilter.today),
      );

      expect(cubit.state.status, LoadableStatus.success);
      expect(cubit.state.errorMessage, 'Системийн алдаа!');
      expect(cubit.state.data?.statements.stmtList, isEmpty);
      expect(
        cubit.state.data?.filter.dateFilter,
        IpsStatementDateFilter.today,
      );

      service.error = null;
      await cubit.clearFilter();

      expect(cubit.state.errorMessage, isNull);
      expect(cubit.state.data?.filter.isEmpty, isTrue);
      expect(cubit.state.data?.statements.stmtList, hasLength(1));
    },
  );
}

DateTime _dateOnly(DateTime value) {
  final DateTime local = value.toLocal();
  return DateTime(local.year, local.month, local.day);
}

String _formatDate(DateTime value) {
  final String year = value.year.toString().padLeft(4, '0');
  final String month = value.month.toString().padLeft(2, '0');
  final String day = value.day.toString().padLeft(2, '0');
  return '$year-$month-$day';
}

class _FakePortfolioService implements PortfolioService {
  _FakePortfolioService({required this.statements});

  final PortfolioStatementsData statements;
  Object? error;
  int getStatementsCallCount = 0;
  SdkPortfolioContext? lastContext;

  @override
  Future<PortfolioStatementsData> getStatements({
    SdkPortfolioContext? context,
  }) async {
    getStatementsCallCount += 1;
    lastContext = context;
    final Object? resolvedError = error;
    if (resolvedError != null) {
      throw resolvedError;
    }
    return statements;
  }

  @override
  Future<PortfolioOverview> getIpsBalance({SdkPortfolioContext? context}) {
    throw UnimplementedError();
  }

  @override
  Future<PortfolioOverview> getOverview({SdkPortfolioContext? context}) {
    throw UnimplementedError();
  }

  @override
  Future<PortfolioDashboardData> getDashboardData({
    SdkPortfolioContext? context,
  }) {
    throw UnimplementedError();
  }

  @override
  Future<List<PortfolioHolding>> getHoldings({SdkPortfolioContext? context}) {
    throw UnimplementedError();
  }
}
