import '../../shared/domain/models/ips_models.dart';

class IpsOrdersState {
  final bool isLoading;
  final List<IpsOrder> orders;
  final PortfolioOverview? refreshedOverview;
  final String? errorMessage;
  final String? cancellingOrderId;
  final String? cancelledOrderId;

  const IpsOrdersState({
    this.isLoading = false,
    this.orders = const <IpsOrder>[],
    this.refreshedOverview,
    this.errorMessage,
    this.cancellingOrderId,
    this.cancelledOrderId,
  });

  static const Object sentinel = Object();

  IpsOrdersState copyWith({
    bool? isLoading,
    List<IpsOrder>? orders,
    Object? refreshedOverview = sentinel,
    Object? errorMessage = sentinel,
    Object? cancellingOrderId = sentinel,
    Object? cancelledOrderId = sentinel,
  }) {
    return IpsOrdersState(
      isLoading: isLoading ?? this.isLoading,
      orders: orders ?? this.orders,
      refreshedOverview: refreshedOverview == sentinel
          ? this.refreshedOverview
          : refreshedOverview as PortfolioOverview?,
      errorMessage: errorMessage == sentinel
          ? this.errorMessage
          : errorMessage as String?,
      cancellingOrderId: cancellingOrderId == sentinel
          ? this.cancellingOrderId
          : cancellingOrderId as String?,
      cancelledOrderId: cancelledOrderId == sentinel
          ? this.cancelledOrderId
          : cancelledOrderId as String?,
    );
  }
}
