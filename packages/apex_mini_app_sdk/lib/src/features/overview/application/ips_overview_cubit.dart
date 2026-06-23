import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:apex_mini_app_sdk/apex_mini_app_sdk.dart';

/// Cubit that loads overview/home data for the InvestX dashboard.
class IpsOverviewCubit extends Cubit<LoadableState<IpsOverviewViewData>> {
  /// Bootstrap service used to determine account/onboarding state.
  final InvestmentBootstrapService bootstrapService;

  /// Portfolio service used when the user has active IPS accounts.
  final PortfolioService? portfolioService;

  /// Pack service used for recommended pack data.
  final PackService? packService;

  /// Orders service used to check for pending orders.
  final OrdersService? ordersService;

  /// Questionnaire service used to check grape completion status.
  final QuestionnaireService? questionnaireService;

  /// Localizations used for error messages.
  final SdkLocalizations l10n;

  /// Diagnostic logger.
  final MiniAppLogger logger;

  /// Profile repository used to fetch loyalty info.
  final MiniAppProfileRepository? profileRepository;

  IpsOverviewCubit({
    required this.bootstrapService,
    required this.l10n,
    this.portfolioService,
    this.packService,
    this.ordersService,
    this.questionnaireService,
    this.profileRepository,
    this.logger = const SilentMiniAppLogger(),
  }) : super(const LoadableState<IpsOverviewViewData>());

  /// Loads overview state, optionally starting from an already known bootstrap state.
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
        final bool isQuestionnaireCompleted =
            await _checkQuestionnaireCompletedIfNeeded(initial);
        emit(
          LoadableState<IpsOverviewViewData>(
            status: LoadableStatus.success,
            data: IpsOverviewViewData(
              bootstrapState: initial,
              isQuestionnaireCompleted: isQuestionnaireCompleted,
            ),
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
        final bool isQuestionnaireCompleted =
            await _checkQuestionnaireCompletedIfNeeded(data);
        emit(
          LoadableState<IpsOverviewViewData>(
            status: LoadableStatus.success,
            data: IpsOverviewViewData(
              bootstrapState: data,
              isQuestionnaireCompleted: isQuestionnaireCompleted,
            ),
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

  Future<void> _loadPortfolioOverviewIfNeeded(
    AcntBootstrapState data, {
    bool forceRefresh = false,
  }) async {
    final PortfolioService? service = portfolioService;
    if (service == null) {
      return;
    }

    try {
      final SdkPortfolioContext context = const PortfolioContextResolver()
          .resolve(bootstrapState: data);
      final (
        PortfolioDashboardData dashboardData,
        IpsOrder? pendingOrder,
        LoyaltyInfoDto? loyaltyInfo,
      ) = await (
        service.getDashboardData(context: context),
        _fetchPendingOrder(forceRefresh: forceRefresh),
        _fetchLoyaltyInfo(),
      ).wait;

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
            pendingOrder: pendingOrder,
            loyaltyInfo: loyaltyInfo,
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

  Future<IpsOrder?> _fetchPendingOrder({bool forceRefresh = false}) async {
    final OrdersService? service = ordersService;
    if (service == null) return null;
    try {
      final List<IpsOrder> orders = await service.getOrders();
      return orders.where((IpsOrder o) => o.status == IpsOrderStatus.pending).firstOrNull;
    } catch (_) {
      return null;
    }
  }

  Future<LoyaltyInfoDto?> _fetchLoyaltyInfo() async {
    final MiniAppProfileRepository? repo = profileRepository;
    if (repo == null) return null;
    try {
      return await repo.getLoyaltyInfo();
    } catch (_) {
      return null;
    }
  }

  /// Refetches only [pendingOrder] without reloading the full overview.
  Future<void> refreshPendingOrderStatus() async {
    final IpsOverviewViewData? current = state.data;
    if (current == null || isClosed) return;
    final IpsOrder? pendingOrder = await _fetchPendingOrder();
    if (isClosed) return;
    emit(
      state.copyWith(
        data: IpsOverviewViewData(
          bootstrapState: current.bootstrapState,
          portfolioOverview: current.portfolioOverview,
          yieldProfitHoldings: current.yieldProfitHoldings,
          stockYieldDetails: current.stockYieldDetails,
          packs: current.packs,
          portfolioContext: current.portfolioContext,
          isDashboardDataReady: current.isDashboardDataReady,
          dashboardLoadFailed: current.dashboardLoadFailed,
          pendingOrder: pendingOrder,
          loyaltyInfo: current.loyaltyInfo,
        ),
      ),
    );
  }

  Future<bool> _checkQuestionnaireCompletedIfNeeded(
    AcntBootstrapState data,
  ) async {
    final QuestionnaireService? service = questionnaireService;
    if (service == null) {
      print('[overview] questionnaireService is null → skip check');
      return false;
    }
    if (data.hasIpsAcnt) return false;
    try {
      final GrapeQuestionnaireCompletionStatus status =
          await service.checkCompletionStatus();
      print('[overview] checkCompletionStatus → completed=${status.completed}');
      return status.completed;
    } catch (e) {
      print('[overview] checkCompletionStatus error → $e');
      return false;
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
              isQuestionnaireCompleted: current.isQuestionnaireCompleted,
              loyaltyInfo: current.loyaltyInfo,
            ),
          ),
        );
      }
    } catch (_) {
      // Best-effort; the home tab will still work without packs.
    }
  }
}
