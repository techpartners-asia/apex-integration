import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mini_app_sdk/l10n/sdk_localizations.dart';
import 'package:mini_app_ui/mini_app_ui.dart';

import '../../shared/application/loadable_state.dart';
import '../../shared/domain/services/investment_services.dart';
import '../../shared/presentation/helpers/ips_error_formatter.dart';
import 'ips_portfolio_view_data.dart';

class IpsPortfolioCubit extends Cubit<LoadableState<IpsPortfolioViewData>> {
  final PortfolioService service;
  final SdkLocalizations l10n;
  final MiniAppLogger logger;

  IpsPortfolioCubit({
    required this.service,
    required this.l10n,
    this.logger = const SilentMiniAppLogger(),
  }) : super(const LoadableState<IpsPortfolioViewData>());

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
