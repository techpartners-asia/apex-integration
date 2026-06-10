import 'package:apex_mini_app_sdk/apex_mini_app_sdk.dart';

/// Domain model for an IPS order displayed in order/history screens.
class IpsOrder {
  /// Stable order id used by local UI/actions.
  final String id;

  /// Backend order number.
  final int orderNo;

  /// Display title for the order row.
  final String title;

  /// Normalized order status.
  final IpsOrderStatus status;

  /// Order amount.
  final double amount;

  /// Order creation timestamp.
  final DateTime createdAt;

  /// Package code associated with the order.
  final String? packCode;

  /// Package name.
  final String? packName;

  /// Package quantity.
  final int? packQty;

  /// User registration number associated with the order.
  final String? registerCode;

  /// Expiration timestamp for payable/pending orders.
  final DateTime? expiresAt;

  /// Buy/sell side value returned by the backend.
  final String? buySell;

  /// Creates an IPS order domain model.
  const IpsOrder({
    required this.id,
    required this.orderNo,
    required this.title,
    required this.status,
    required this.amount,
    required this.createdAt,
    required this.buySell,
    this.packCode,
    this.packName,
    this.packQty,
    this.registerCode,
    this.expiresAt,
  });
}
