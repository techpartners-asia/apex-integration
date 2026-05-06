import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mini_app_sdk/mini_app_sdk.dart';

class IpsSellCubit extends Cubit<IpsSellState> {
  final OrdersService service;
  final SdkLocalizations l10n;
  final PortfolioService? portfolioService;
  final PackService? packService;

  IpsSellCubit({
    required this.service,
    required this.l10n,
    this.portfolioService,
    this.packService,
  }) : super(const IpsSellState());

  Future<void> loadPricing() async {
    await Future.wait(<Future<void>>[
      _loadOverview(),
      _loadSelectedPack(),
    ]);
  }

  Future<void> _loadOverview() async {
    final PortfolioService? ps = portfolioService;
    if (ps == null || state.hasPricing) return;

    try {
      final PortfolioOverview overview = await ps.getOverview();
      emit(
        state.copyWith(
          packQty: _resolveOwnedPackQty(overview, state.packQty),
          unitPrice: overview.packAmount ?? state.unitPrice,
          serviceFee: overview.packFee ?? state.serviceFee,
          profit: _resolveProfit(overview, state.profit),
          currency: overview.currency,
          bondPercent: overview.bondPercent ?? state.bondPercent,
          stockPercent: overview.stockPercent ?? state.stockPercent,
        ),
      );
    } catch (_) {
      // Pricing is best-effort; the screen will still work with zeros.
    }
  }

  Future<void> _loadSelectedPack() async {
    final PackService? ps = packService;
    if (ps == null || state.pack != null) return;

    try {
      final List<IpsPack> packs = await ps.getPacks();
      if (packs.isNotEmpty) {
        final IpsPack selected = packs.firstWhere(
          (IpsPack p) => p.isRecommended == 1,
          orElse: () => packs.first,
        );
        emit(state.copyWith(pack: selected));
      }
    } catch (_) {
      // Best-effort; UI will fall back to generic labels.
    }
  }

  void updatePackQty(String value) {
    emit(state.copyWith(packQty: int.tryParse(value.trim()) ?? 0));
  }

  Future<void> submit() async {
    if (!state.canSubmit) return;

    emit(state.copyWith(isSubmitting: true, errorMessage: null));

    try {
      final ActionRes res = await service.createSellOrder(
        SellOrderReq(packQty: state.packQty),
      );

      emit(
        state.copyWith(
          isSubmitting: false,
          message: _normalizeSuccessMessage(res.message),
          errorMessage: null,
          refreshErrorMessage: null,
        ),
      );
    } catch (error) {
      emit(
        state.copyWith(
          isSubmitting: false,
          errorMessage: formatIpsError(error, l10n),
        ),
      );
    }
  }

  Future<List<IpsPack>?> refreshPacksAfterSuccess() async {
    if (!state.canCompleteSuccessFlow) {
      return null;
    }

    final PackService? ps = packService;
    if (ps == null) {
      emit(state.copyWith(refreshErrorMessage: l10n.ipsPackMissingService));
      return null;
    }

    emit(state.copyWith(isRefreshingPacks: true, refreshErrorMessage: null));

    try {
      final List<IpsPack> packs = await ps.getPacks(forceRefresh: true);
      if (!isClosed) {
        emit(state.copyWith(isRefreshingPacks: false));
      }
      return packs;
    } catch (error) {
      if (!isClosed) {
        emit(
          state.copyWith(
            isRefreshingPacks: false,
            refreshErrorMessage: formatIpsError(error, l10n),
          ),
        );
      }
      return null;
    }
  }

  String? _normalizeSuccessMessage(String? message) {
    final String value = message?.trim() ?? '';
    return value.isEmpty ? null : value;
  }

  int _resolveOwnedPackQty(PortfolioOverview overview, int fallback) {
    final double? rawPackQty = overview.packQty;
    if (rawPackQty == null || !rawPackQty.isFinite || rawPackQty <= 0) {
      return fallback;
    }
    return rawPackQty.round();
  }

  double _resolveProfit(PortfolioOverview overview, double fallback) {
    final double? reportedProfit = overview.profitOrLoss ?? overview.yieldAmount;
    if (reportedProfit != null && reportedProfit.isFinite) {
      return reportedProfit;
    }

    final double principal = (overview.packQty ?? 0) * (overview.packAmount ?? 0);
    final double assetsValue = (overview.stockTotal ?? 0) + (overview.bondTotal ?? 0) + (overview.cashTotal ?? 0);
    if (principal > 0 && assetsValue.isFinite) {
      return assetsValue - principal;
    }

    return fallback;
  }
}
