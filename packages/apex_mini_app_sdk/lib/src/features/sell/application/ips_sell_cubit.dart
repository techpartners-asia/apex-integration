import 'package:apex_mini_app_sdk/apex_mini_app_sdk.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Coordinates pricing, submission, and post-success refresh for sell flow.
class IpsSellCubit extends Cubit<IpsSellState> {
  /// Orders service used to submit sell requests.
  final OrdersService service;

  /// Localizations used for user-facing errors.
  final SdkLocalizations l10n;

  /// Optional portfolio service used to load pricing/holding data.
  final PortfolioService? portfolioService;

  /// Optional pack service used to show the selected/recommended pack.
  final PackService? packService;

  /// Creates the sell flow cubit.
  IpsSellCubit({
    required this.service,
    required this.l10n,
    this.portfolioService,
    this.packService,
  }) : super(const IpsSellState());

  /// Loads overview pricing and selected/current pack details.
  Future<void> loadPricing() async {
    final PortfolioOverview? overview = await _loadOverview();
    await _loadSelectedPack(overview: overview);
  }

  Future<PortfolioOverview?> _loadOverview() async {
    final PortfolioService? ps = portfolioService;
    if (ps == null || state.hasPricing) return null;

    try {
      final PortfolioOverview overview = await ps.getOverview();
      emit(
        state.copyWith(
          pack: _packFromOverview(overview),
          packQty: _resolveOwnedPackQty(overview, state.packQty),
          unitPrice: overview.packAmount ?? state.unitPrice,
          serviceFee: overview.packFee ?? state.serviceFee,
          profit: _resolveProfit(overview, state.profit),
          currency: overview.currency,
          bondPercent: overview.bondPercent ?? state.bondPercent,
          stockPercent: overview.stockPercent ?? state.stockPercent,
        ),
      );
      return overview;
    } catch (_) {
      // Pricing is best-effort; the screen will still work with zeros.
      return null;
    }
  }

  Future<void> _loadSelectedPack({PortfolioOverview? overview}) async {
    final PackService? ps = packService;
    if (ps == null) return;

    try {
      final List<IpsPack> packs = await ps.getPacks();
      if (packs.isNotEmpty) {
        final IpsPack selected = _resolveSelectedPack(
          packs,
          packCode:
              _normalizedPackCode(overview?.packDetail?.packCode) ??
              _normalizedPackCode(state.pack?.packCode),
        );
        emit(state.copyWith(pack: selected));
      }
    } catch (_) {
      // Best-effort; UI will fall back to generic labels.
    }
  }

  /// Updates selected pack quantity from user input.
  void updatePackQty(String value) {
    emit(state.copyWith(packQty: int.tryParse(value.trim()) ?? 0));
  }

  /// Submits the sell request when the state is valid.
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
          message:
              _normalizeSuccessMessage(res.message) ??
              l10n.ipsSuccessReqCreated,
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

  /// Refreshes packs before routing the user away from the success screen.
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
    final double? reportedProfit =
        overview.profitOrLoss ?? overview.yieldAmount;
    if (reportedProfit != null && reportedProfit.isFinite) {
      return reportedProfit;
    }

    final double principal =
        (overview.packQty ?? 0) * (overview.packAmount ?? 0);
    final double assetsValue =
        (overview.stockTotal ?? 0) +
        (overview.bondTotal ?? 0) +
        (overview.cashTotal ?? 0);
    if (principal > 0 && assetsValue.isFinite) {
      return assetsValue - principal;
    }

    return fallback;
  }

  IpsPack? _packFromOverview(PortfolioOverview overview) {
    final PortfolioPackDetail? detail = overview.packDetail;
    if (detail == null) {
      return null;
    }

    final String? packCode = _trimToNull(detail.packCode);
    final String? name =
        _trimToNull(detail.name) ?? _trimToNull(detail.name2) ?? packCode;
    if (packCode == null || name == null) {
      return null;
    }

    final double bondPercent = _finitePercent(
      detail.bondPercent ?? overview.bondPercent,
    );
    final double stockPercent = _finitePercent(
      detail.stockPercent ?? overview.stockPercent,
    );

    return IpsPack(
      packCode: packCode,
      name: name,
      name2: _trimToNull(detail.name2),
      packDesc: _trimToNull(detail.packDesc),
      isRecommended: detail.isRecommended == true ? 1 : 0,
      bondPercent: bondPercent,
      stockPercent: stockPercent,
      assetPercent: _remainingAssetPercent(bondPercent, stockPercent),
    );
  }

  IpsPack _resolveSelectedPack(
    List<IpsPack> packs, {
    required String? packCode,
  }) {
    if (packCode != null) {
      for (final IpsPack pack in packs) {
        if (_normalizedPackCode(pack.packCode) == packCode) {
          return pack;
        }
      }
    }

    for (final IpsPack pack in packs) {
      if (pack.isRecommended == 1) {
        return pack;
      }
    }
    return packs.first;
  }

  String? _normalizedPackCode(String? value) {
    final String? trimmed = _trimToNull(value);
    return trimmed?.toUpperCase();
  }

  String? _trimToNull(String? value) {
    final String trimmed = value?.trim() ?? '';
    return trimmed.isEmpty ? null : trimmed;
  }

  double _finitePercent(double? value) {
    if (value == null || !value.isFinite) {
      return 0;
    }
    return value;
  }

  double _remainingAssetPercent(double bondPercent, double stockPercent) {
    final double assetPercent = 100 - bondPercent - stockPercent;
    if (!assetPercent.isFinite || assetPercent < 0) {
      return 0;
    }
    return assetPercent;
  }
}
