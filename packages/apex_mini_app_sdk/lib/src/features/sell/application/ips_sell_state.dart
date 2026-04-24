import 'package:mini_app_sdk/mini_app_sdk.dart';

class IpsSellState {
  final IpsPack? pack;
  final int packQty;
  final bool isSubmitting;
  final String? message;
  final String? errorMessage;

  final double unitPrice;
  final double serviceFee;
  final double profit;
  final String currency;
  final double bondPercent;
  final double stockPercent;

  const IpsSellState({
    this.pack,
    this.packQty = 0,
    this.isSubmitting = false,
    this.message,
    this.errorMessage,
    this.unitPrice = 0,
    this.serviceFee = 0,
    this.profit = 0,
    this.currency = 'MNT',
    this.bondPercent = 0,
    this.stockPercent = 0,
  });

  static const Object sentinel = Object();

  bool get canSubmit => packQty > 0 && !isSubmitting && message == null;

  bool get hasPricing => unitPrice > 0;

  double get totalAmount => packQty * unitPrice;

  double get totalFee => serviceFee;

  double get payoutAmount => packQty <= 0 ? 0 : totalAmount + profit - totalFee;

  bool get isSuccess => message != null;

  IpsSellState copyWith({
    int? packQty,
    bool? isSubmitting,
    Object? message = sentinel,
    Object? errorMessage = sentinel,
    double? unitPrice,
    double? serviceFee,
    double? profit,
    String? currency,
    double? bondPercent,
    double? stockPercent,
    IpsPack? pack,
  }) {
    return IpsSellState(
      pack: pack ?? this.pack,
      packQty: packQty ?? this.packQty,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      message: message == sentinel ? this.message : message as String?,
      errorMessage: errorMessage == sentinel
          ? this.errorMessage
          : errorMessage as String?,
      unitPrice: unitPrice ?? this.unitPrice,
      serviceFee: serviceFee ?? this.serviceFee,
      profit: profit ?? this.profit,
      currency: currency ?? this.currency,
      bondPercent: bondPercent ?? this.bondPercent,
      stockPercent: stockPercent ?? this.stockPercent,
    );
  }
}
