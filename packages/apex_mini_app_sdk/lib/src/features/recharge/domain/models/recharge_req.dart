import 'package:apex_mini_app_sdk/apex_mini_app_sdk.dart';

/// User-selected recharge request before it is converted to payment/order APIs.
class RechargeReq {
  /// Selected package quantity.
  final int packQty;

  /// Optional amount override calculated from the selected package.
  final double? amount;

  /// Currency code for the recharge amount.
  final String currency;

  /// Creates a recharge request from selected quantity and pricing data.
  const RechargeReq({
    required this.packQty,
    this.amount,
    this.currency = IpsDefaults.defaultCurrency,
  });
}
