import 'package:apex_mini_app_sdk/apex_mini_app_sdk.dart';

/// UI state for the IPS recharge flow.
class IpsRechargeState {
  /// Selected pack quantity.
  final int packQty;

  /// Unit price per pack.
  final double unitPrice;

  /// Service fee added to total.
  final double serviceFee;

  /// Display currency.
  final String currency;

  /// Whether pricing is loading.
  final bool isPricingLoading;

  /// Whether recharge/payment submit is running.
  final bool isSubmitting;

  /// Host payment result.
  final MiniAppPaymentRes? paymentRes;

  /// Balance refreshed after successful payment.
  final PortfolioOverview? refreshedOverview;

  /// User-facing error message.
  final String? errorMessage;

  /// Creates recharge flow state.
  const IpsRechargeState({
    this.packQty = 0,
    this.unitPrice = 0,
    this.serviceFee = 0,
    this.currency = 'MNT',
    this.isPricingLoading = false,
    this.isSubmitting = false,
    this.paymentRes,
    this.refreshedOverview,
    this.errorMessage,
  });

  /// Sentinel used to distinguish omitted nullable fields from explicit null.
  static const Object sentinel = Object();

  /// Whether submit button should be enabled.
  bool get canSubmit =>
      packQty > 0 && hasPricing && !isPricingLoading && !isSubmitting;

  /// Whether a positive unit price is available.
  bool get hasPricing => unitPrice > 0;

  /// Total payable amount.
  double get totalPayable =>
      packQty <= 0 ? 0 : packQty * (unitPrice + serviceFee);

  /// Copies state while allowing explicit null assignment for nullable fields.
  IpsRechargeState copyWith({
    int? packQty,
    double? unitPrice,
    double? serviceFee,
    String? currency,
    bool? isPricingLoading,
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
      isPricingLoading: isPricingLoading ?? this.isPricingLoading,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      paymentRes: paymentRes == sentinel
          ? this.paymentRes
          : paymentRes as MiniAppPaymentRes?,
      refreshedOverview: refreshedOverview == sentinel
          ? this.refreshedOverview
          : refreshedOverview as PortfolioOverview?,
      errorMessage: errorMessage == sentinel
          ? this.errorMessage
          : errorMessage as String?,
    );
  }
}
