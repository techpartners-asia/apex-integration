import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:apex_mini_app_sdk/apex_mini_app_sdk.dart';

/// Cubit for order history and order cancellation.
class IpsOrdersCubit extends Cubit<IpsOrdersState> {
  IpsOrdersCubit({
    required this.service,
    this.portfolioService,
    required this.l10n,
    this.logger = const SilentMiniAppLogger(),
  }) : super(const IpsOrdersState());

  /// Orders API service.
  final OrdersService service;

  /// Portfolio service used to refresh balance after cancellation.
  final PortfolioService? portfolioService;

  /// Localizations used for user-facing errors.
  final SdkLocalizations l10n;

  /// Diagnostic logger.
  final MiniAppLogger logger;

  /// Loads current orders.
  Future<void> load() async {
    emit(
      state.copyWith(
        isLoading: true,
        refreshedOverview: null,
        errorMessage: null,
        cancelledOrderId: null,
      ),
    );

    try {
      final List<IpsOrder> orders = await service.getOrders();

      emit(
        state.copyWith(isLoading: false, orders: orders, errorMessage: null),
      );
    } catch (error) {
      emit(
        state.copyWith(
          isLoading: false,
          errorMessage: formatIpsError(error, l10n),
        ),
      );
    }
  }

  /// Cancels [order], reloads order list, and refreshes balance if possible.
  Future<void> cancelOrder(IpsOrder order) async {
    if (state.cancellingOrderId != null) return;

    emit(
      state.copyWith(
        cancellingOrderId: order.id,
        refreshedOverview: null,
        errorMessage: null,
        cancelledOrderId: null,
      ),
    );
    try {
      await service.cancelOrder(order);
      final PortfolioOverview? refreshedOverview =
          await _refreshBalanceAfterSuccess();
      final List<IpsOrder> orders = await service.getOrders();

      emit(
        state.copyWith(
          cancellingOrderId: null,
          orders: orders,
          refreshedOverview: refreshedOverview,
          cancelledOrderId: order.id,
        ),
      );
    } catch (error) {
      emit(
        state.copyWith(
          cancellingOrderId: null,
          errorMessage: formatIpsError(error, l10n),
        ),
      );
    }
  }

  /// Clears one-shot success/error feedback flags.
  void clearFeedback() {
    emit(state.copyWith(cancelledOrderId: null));
  }

  Future<PortfolioOverview?> _refreshBalanceAfterSuccess() async {
    final PortfolioService? service = portfolioService;
    if (service == null) {
      return null;
    }

    try {
      return await service.getIpsBalance();
    } catch (error, stackTrace) {
      logger.onError(
        'balance_refresh_after_cancel_failed',
        error: error,
        stackTrace: stackTrace,
      );
      return null;
    }
  }
}
