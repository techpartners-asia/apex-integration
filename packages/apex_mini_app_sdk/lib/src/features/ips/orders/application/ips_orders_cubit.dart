import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mini_app_sdk/l10n/sdk_localizations.dart';
import 'package:mini_app_ui/mini_app_ui.dart';

import '../../shared/domain/services/investment_services.dart';
import '../../shared/presentation/helpers/ips_error_formatter.dart';
import 'ips_orders_state.dart';

class IpsOrdersCubit extends Cubit<IpsOrdersState> {
  IpsOrdersCubit({
    required this.service,
    this.portfolioService,
    required this.l10n,
    this.logger = const SilentMiniAppLogger(),
  }) : super(const IpsOrdersState());

  final OrdersService service;
  final PortfolioService? portfolioService;
  final SdkLocalizations l10n;
  final MiniAppLogger logger;

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
