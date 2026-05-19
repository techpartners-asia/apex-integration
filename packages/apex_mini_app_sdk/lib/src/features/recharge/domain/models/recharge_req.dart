import 'package:apex_mini_app_sdk/apex_mini_app_sdk.dart';

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
