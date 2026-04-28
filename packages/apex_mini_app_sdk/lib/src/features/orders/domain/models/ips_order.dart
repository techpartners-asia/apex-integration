import 'package:mini_app_sdk/mini_app_sdk.dart';

class IpsOrder {
  final String id;
  final int orderNo;
  final String title;
  final IpsOrderStatus status;
  final double amount;
  final DateTime createdAt;
  final String? packCode;
  final int? packQty;
  final String? registerCode;
  final DateTime? expiresAt;
  final String? buySell;

  const IpsOrder({
    required this.id,
    required this.orderNo,
    required this.title,
    required this.status,
    required this.amount,
    required this.createdAt,
    required this.buySell,
    this.packCode,
    this.packQty,
    this.registerCode,
    this.expiresAt,
  });
}
