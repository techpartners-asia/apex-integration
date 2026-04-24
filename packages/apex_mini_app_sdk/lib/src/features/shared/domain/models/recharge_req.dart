import 'package:mini_app_sdk/mini_app_sdk.dart';

class RechargeReq {
  final int packQty;
  final double? amount;
  final String currency;

  const RechargeReq({
    required this.packQty,
    this.amount,
    this.currency = IpsDefaults.defaultCurrency,
  });
}
