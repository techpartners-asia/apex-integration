import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mini_app_sdk/mini_app_sdk.dart';

class IpsStatementsCubit extends Cubit<LoadableState<IpsStatementsViewData>> {
  IpsStatementsCubit({required this.service, required this.l10n})
    : super(const LoadableState<IpsStatementsViewData>());

  final PortfolioService service;
  final SdkLocalizations l10n;
  SdkPortfolioContext? _lastContext;

  Future<void> load({SdkPortfolioContext? context}) async {
    final SdkPortfolioContext? resolvedContext = context ?? _lastContext;
    _lastContext = resolvedContext;
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
          ),
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
}
