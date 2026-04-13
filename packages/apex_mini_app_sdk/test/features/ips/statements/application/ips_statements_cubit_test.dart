import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mini_app_sdk/l10n/sdk_localizations.dart';
import 'package:mini_app_sdk/src/core/backend/sdk_portfolio_context.dart';
import 'package:mini_app_sdk/src/features/ips/shared/application/loadable_state.dart';
import 'package:mini_app_sdk/src/features/ips/shared/domain/models/ips_models.dart';
import 'package:mini_app_sdk/src/features/ips/shared/domain/services/portfolio_service.dart';
import 'package:mini_app_sdk/src/features/ips/statements/application/ips_statements_cubit.dart';
import 'package:mini_app_sdk/src/features/ips/statements/application/ips_statements_view_data.dart';

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
        entries: <PortfolioStatementEntry>[
          PortfolioStatementEntry(
            id: '1',
            description: 'Recharge',
            amount: 150,
            isCredit: true,
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
    expect(cubit.state.data?.statements.entries, hasLength(1));
  });
}

class _FakePortfolioService implements PortfolioService {
  _FakePortfolioService({required this.statements});

  final PortfolioStatementsData statements;
  int getStatementsCallCount = 0;
  SdkPortfolioContext? lastContext;

  @override
  Future<PortfolioStatementsData> getStatements({
    SdkPortfolioContext? context,
  }) async {
    getStatementsCallCount += 1;
    lastContext = context;
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
