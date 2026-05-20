import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:apex_mini_app_sdk/apex_mini_app_sdk.dart';

/// Cubit that loads the portfolio tab/dashboard.
class IpsPortfolioCubit extends Cubit<LoadableState<IpsPortfolioViewData>> {
  /// Portfolio data service.
  final PortfolioService service;

  /// Localizations used for user-facing errors.
  final SdkLocalizations l10n;

  /// Diagnostic logger.
  final MiniAppLogger logger;

  IpsPortfolioCubit({
    required this.service,
    required this.l10n,
    this.logger = const SilentMiniAppLogger(),
  }) : super(const LoadableState<IpsPortfolioViewData>());

  /// Loads overview and holdings data.
  Future<void> load() async {
    if (state.isLoading) {
      return;
    }

    emit(state.copyWith(status: LoadableStatus.loading, errorMessage: null));

    try {
      final PortfolioDashboardData dashboardData = await service
          .getDashboardData();
      final List<PortfolioHolding> holdings =
          dashboardData.yieldProfitHoldings.isNotEmpty
          ? dashboardData.yieldProfitHoldings
          : dashboardData.stockYieldDetails;

      emit(
        LoadableState<IpsPortfolioViewData>(
          status: LoadableStatus.success,
          data: IpsPortfolioViewData(
            overview: dashboardData.overview,
            holdings: holdings,
            yieldProfitHoldings: dashboardData.yieldProfitHoldings,
            stockYieldDetails: dashboardData.stockYieldDetails,
            portfolioContext: dashboardData.portfolioContext,
          ),
        ),
      );
    } catch (error, stackTrace) {
      logger.onError(
        'portfolio_load_failed',
        error: error,
        stackTrace: stackTrace,
      );
      emit(
        state.copyWith(
          status: LoadableStatus.failure,
          errorMessage: formatIpsError(error, l10n),
        ),
      );
    }
  }
}
