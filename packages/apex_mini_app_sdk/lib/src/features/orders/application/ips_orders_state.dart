import 'package:apex_mini_app_sdk/apex_mini_app_sdk.dart';

/// UI state for order history and order actions.
class IpsOrdersState {
  /// Whether the order list is loading.
  final bool isLoading;

  /// Orders currently displayed in the history screen.
  final List<IpsOrder> orders;

  /// Optional portfolio overview refreshed after a successful mutation.
  final PortfolioOverview? refreshedOverview;

  /// Last user-visible error message.
  final String? errorMessage;

  /// Order id currently being cancelled.
  final String? cancellingOrderId;

  /// Last successfully cancelled order id.
  final String? cancelledOrderId;

  /// Creates an orders state snapshot.
  const IpsOrdersState({
    this.isLoading = false,
    this.orders = const <IpsOrder>[],
    this.refreshedOverview,
    this.errorMessage,
    this.cancellingOrderId,
    this.cancelledOrderId,
  });

  /// Sentinel used to distinguish "unchanged" from explicit null in copyWith.
  static const Object sentinel = Object();

  /// Returns a copy with optional field replacement.
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
