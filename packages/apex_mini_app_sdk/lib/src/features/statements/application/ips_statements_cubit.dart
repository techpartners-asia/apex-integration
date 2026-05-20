import 'package:apex_mini_app_sdk/apex_mini_app_sdk.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Loads and filters portfolio/cash account statements.
class IpsStatementsCubit extends Cubit<LoadableState<IpsStatementsViewData>> {
  /// Creates the statements cubit.
  IpsStatementsCubit({required this.service, required this.l10n})
    : super(const LoadableState<IpsStatementsViewData>());

  /// Portfolio service used to fetch statement data.
  final PortfolioService service;

  /// Localization source for error messages.
  final SdkLocalizations l10n;

  SdkPortfolioContext? _baseContext;

  /// Loads statements and preserves the last base context for filter reloads.
  Future<void> load({
    SdkPortfolioContext? context,
    IpsStatementFilter? filter,
  }) async {
    if (context != null) {
      _baseContext = context;
    }

    final IpsStatementFilter currentFilter =
        filter ?? state.data?.filter ?? const IpsStatementFilter();
    final SdkPortfolioContext? resolvedContext = currentFilter
        .resolveRequestContext(context ?? _baseContext);

    emit(state.copyWith(status: LoadableStatus.loading, errorMessage: null));
    try {
      final PortfolioStatementsData statements = await service.getStatements(
        context: resolvedContext,
      );
      emit(
        LoadableState<IpsStatementsViewData>(
          status: LoadableStatus.success,
          data: IpsStatementsViewData(
            statements: statements,
            portfolioContext: resolvedContext ?? const SdkPortfolioContext(),
            filter: currentFilter,
          ),
        ),
      );
    } on ApiBusinessException catch (error) {
      emit(
        LoadableState<IpsStatementsViewData>(
          status: LoadableStatus.success,
          data: IpsStatementsViewData(
            statements: _emptyStatementsData(resolvedContext),
            portfolioContext: resolvedContext ?? const SdkPortfolioContext(),
            filter: currentFilter,
          ),
          errorMessage: formatIpsError(error, l10n),
        ),
      );
    } catch (error) {
      emit(
        LoadableState<IpsStatementsViewData>(
          status: LoadableStatus.failure,
          errorMessage: formatIpsError(error, l10n),
        ),
      );
    }
  }

  /// Applies [filter], reloading only when the backend date range changes.
  Future<void> applyFilter(IpsStatementFilter filter) async {
    final IpsStatementsViewData? data = state.data;
    final bool shouldReload =
        filter.hasDateFilter || (data?.filter.hasDateFilter ?? false);

    if (data == null || shouldReload) {
      await load(filter: filter);
      return;
    }

    emit(
      state.copyWith(
        status: LoadableStatus.success,
        data: data.copyWith(filter: filter),
        errorMessage: null,
      ),
    );
  }

  /// Clears all statement filters and reloads if a date filter was active.
  Future<void> clearFilter() async {
    final IpsStatementsViewData? data = state.data;
    if (data == null || data.filter.hasDateFilter) {
      await load(filter: const IpsStatementFilter());
      return;
    }

    await applyFilter(const IpsStatementFilter());
  }

  /// Builds an empty statement response when the backend returns business empty.
  PortfolioStatementsData _emptyStatementsData(SdkPortfolioContext? context) {
    return PortfolioStatementsData(
      summary: '',
      currency: 'MNT',
      startDate: context?.normalizedStmtStartDate ?? '',
      endDate: context?.normalizedStmtEndDate ?? '',
      totalCount: 0,
      pageCount: 0,
      totalPage: 0,
      stmtList: const <MgBkrCasaAcntStatementResDataDto>[],
    );
  }
}
