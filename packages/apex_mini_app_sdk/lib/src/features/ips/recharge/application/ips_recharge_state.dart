import 'package:mini_app_core/mini_app_core.dart';

import '../../shared/domain/models/ips_models.dart';

class IpsRechargeState {
  final int packQty;
  final double unitPrice;
  final double serviceFee;
  final String currency;
  final bool isSubmitting;
  final MiniAppPaymentRes? paymentRes;
  final PortfolioOverview? refreshedOverview;
  final String? errorMessage;

  const IpsRechargeState({
    this.packQty = 0,
    this.unitPrice = 0,
    this.serviceFee = 0,
    this.currency = 'MNT',
    this.isSubmitting = false,
    this.paymentRes,
    this.refreshedOverview,
    this.errorMessage,
  });

  static const Object sentinel = Object();

  bool get canSubmit => packQty > 0 && !isSubmitting;

  bool get hasPricing => unitPrice > 0;

  double get totalPayable => packQty <= 0 ? 0 : (packQty * unitPrice) + serviceFee;

  IpsRechargeState copyWith({
    int? packQty,
    double? unitPrice,
    double? serviceFee,
    String? currency,
    bool? isSubmitting,
    Object? paymentRes = sentinel,
    Object? refreshedOverview = sentinel,
    Object? errorMessage = sentinel,
  }) {
    return IpsRechargeState(
      packQty: packQty ?? this.packQty,
      unitPrice: unitPrice ?? this.unitPrice,
      serviceFee: serviceFee ?? this.serviceFee,
      currency: currency ?? this.currency,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      paymentRes: paymentRes == sentinel ? this.paymentRes : paymentRes as MiniAppPaymentRes?,
      refreshedOverview: refreshedOverview == sentinel ? this.refreshedOverview : refreshedOverview as PortfolioOverview?,
      errorMessage: errorMessage == sentinel ? this.errorMessage : errorMessage as String?,
    );
  }
}
