import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mini_app_sdk/l10n/sdk_localizations.dart';
import 'package:mini_app_ui/mini_app_ui.dart';

import '../../../../core/backend/sdk_portfolio_context.dart';
import 'ips_overview_view_data.dart';
import '../../shared/application/bootstrap_state_resolver.dart';
import '../../shared/application/loadable_state.dart';
import '../../shared/application/portfolio_context_resolver.dart';
import '../../shared/domain/services/investment_services.dart';
import '../../shared/presentation/helpers/ips_error_formatter.dart';

class IpsOverviewCubit extends Cubit<LoadableState<IpsOverviewViewData>> {
  final InvestmentBootstrapService bootstrapService;
  final PortfolioService? portfolioService;
  final PackService? packService;
  final SdkLocalizations l10n;
  final MiniAppLogger logger;

  IpsOverviewCubit({
    required this.bootstrapService,
    required this.l10n,
    this.portfolioService,
    this.packService,
    this.logger = const SilentMiniAppLogger(),
  }) : super(const LoadableState<IpsOverviewViewData>());

  Future<void> load({
    AcntBootstrapState? initial,
    bool forceRefresh = false,
  }) async {
    if (!forceRefresh && initial != null) {
      if (_shouldLoadDashboardData(initial)) {
        emit(
          LoadableState<IpsOverviewViewData>(
            status: LoadableStatus.loading,
            data: IpsOverviewViewData(
              bootstrapState: initial,
              isDashboardDataReady: false,
            ),
          ),
        );
        await _loadPortfolioOverviewIfNeeded(initial);
      } else {
        emit(
          LoadableState<IpsOverviewViewData>(
            status: LoadableStatus.success,
            data: IpsOverviewViewData(bootstrapState: initial),
          ),
        );
        _loadPacksIfNeeded(initial);
      }
      return;
    }

    emit(state.copyWith(status: LoadableStatus.loading, errorMessage: null));

    try {
      final AcntBootstrapState data = await BootstrapStateResolver(
        service: bootstrapService,
      ).load(forceRefresh: forceRefresh);

      if (_shouldLoadDashboardData(data)) {
        emit(
          LoadableState<IpsOverviewViewData>(
            status: LoadableStatus.loading,
            data: IpsOverviewViewData(
              bootstrapState: data,
              isDashboardDataReady: false,
            ),
          ),
        );
        await _loadPortfolioOverviewIfNeeded(data);
      } else {
        emit(
          LoadableState<IpsOverviewViewData>(
            status: LoadableStatus.success,
            data: IpsOverviewViewData(bootstrapState: data),
          ),
        );
        _loadPacksIfNeeded(data, forceRefresh: forceRefresh);
      }
    } catch (error) {
      emit(
        LoadableState<IpsOverviewViewData>(
          status: LoadableStatus.failure,
          errorMessage: formatIpsError(error, l10n),
        ),
      );
    }
  }

  Future<void> _loadPortfolioOverviewIfNeeded(AcntBootstrapState data) async {
    final PortfolioService? service = portfolioService;
    if (service == null) {
      return;
    }

    try {
      final SdkPortfolioContext context = const PortfolioContextResolver()
          .resolve(bootstrapState: data);
      final PortfolioDashboardData dashboardData = await service
          .getDashboardData(
            context: context,
          );
      emit(
        LoadableState<IpsOverviewViewData>(
          status: LoadableStatus.success,
          data: IpsOverviewViewData(
            bootstrapState: data,
            portfolioOverview: dashboardData.overview,
            yieldProfitHoldings: dashboardData.yieldProfitHoldings,
            stockYieldDetails: dashboardData.stockYieldDetails,
            portfolioContext: dashboardData.portfolioContext,
            isDashboardDataReady: true,
          ),
        ),
      );
    } catch (error, stackTrace) {
      logger.onError(
        'dashboard_load_failed',
        error: error,
        stackTrace: stackTrace,
      );
      emit(
        LoadableState<IpsOverviewViewData>(
          status: LoadableStatus.success,
          data: IpsOverviewViewData(
            bootstrapState: data,
            isDashboardDataReady: true,
            dashboardLoadFailed: true,
          ),
        ),
      );
    }
  }

  bool _shouldLoadDashboardData(AcntBootstrapState data) {
    return data.hasIpsAcnt && portfolioService != null;
  }

  Future<void> _loadPacksIfNeeded(
    AcntBootstrapState data, {
    bool forceRefresh = false,
  }) async {
    final PackService? ps = packService;
    if (ps == null) return;

    try {
      final List<IpsPack> packs = await ps.getPacks(
        forceRefresh: forceRefresh,
      );
      final IpsOverviewViewData? current = state.data;
      if (current != null && !isClosed) {
        emit(
          state.copyWith(
            data: IpsOverviewViewData(
              bootstrapState: current.bootstrapState,
              portfolioOverview: current.portfolioOverview,
              yieldProfitHoldings: current.yieldProfitHoldings,
              stockYieldDetails: current.stockYieldDetails,
              packs: packs,
              portfolioContext: current.portfolioContext,
              isDashboardDataReady: current.isDashboardDataReady,
              dashboardLoadFailed: current.dashboardLoadFailed,
            ),
          ),
        );
      }
    } catch (_) {
      // Best-effort; the home tab will still work without packs.
    }
  }
}
