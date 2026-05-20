import 'package:apex_mini_app_sdk/apex_mini_app_sdk.dart';

/// View state for the IPS sell flow.
class IpsSellState {
  /// Pack currently being sold.
  final IpsPack? pack;

  /// Quantity selected for selling.
  final int packQty;

  /// Whether sell submission is in progress.
  final bool isSubmitting;

  /// Whether pack refresh after success is in progress.
  final bool isRefreshingPacks;

  /// Success message returned after sell submission.
  final String? message;

  /// Submission error message.
  final String? errorMessage;

  /// Error message from refreshing packs after success.
  final String? refreshErrorMessage;

  /// Unit price used for the sell calculation.
  final double unitPrice;

  /// Service fee deducted from payout.
  final double serviceFee;

  /// Profit amount included in payout.
  final double profit;

  /// Currency code for display amounts.
  final String currency;

  /// Bond allocation percentage for the selected pack.
  final double bondPercent;

  /// Stock allocation percentage for the selected pack.
  final double stockPercent;

  /// Creates sell flow state.
  const IpsSellState({
    this.pack,
    this.packQty = 0,
    this.isSubmitting = false,
    this.isRefreshingPacks = false,
    this.message,
    this.errorMessage,
    this.refreshErrorMessage,
    this.unitPrice = 0,
    this.serviceFee = 0,
    this.profit = 0,
    this.currency = 'MNT',
    this.bondPercent = 0,
    this.stockPercent = 0,
  });

  /// Sentinel used by [copyWith] to distinguish omitted nullable fields from
  /// explicit null assignments.
  static const Object sentinel = Object();

  /// Whether the current state can submit a sell request.
  bool get canSubmit => packQty > 0 && !isSubmitting && message == null;

  /// Whether the success action can complete.
  bool get canCompleteSuccessFlow => isSuccess && !isRefreshingPacks;

  /// Whether pricing values have been loaded.
  bool get hasPricing => unitPrice > 0;

  /// Gross sell amount before fee/profit adjustments.
  double get totalAmount => packQty * unitPrice;

  /// Total fee currently charged for the sell request.
  double get totalFee => serviceFee;

  /// Final payout amount shown to the user.
  double get payoutAmount => packQty <= 0 ? 0 : totalAmount + profit - totalFee;

  /// Whether the sell submission has completed successfully.
  bool get isSuccess => message != null;

  /// Returns a copy with selected fields replaced.
  IpsSellState copyWith({
    int? packQty,
    bool? isSubmitting,
    bool? isRefreshingPacks,
    Object? message = sentinel,
    Object? errorMessage = sentinel,
    Object? refreshErrorMessage = sentinel,
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
      isRefreshingPacks: isRefreshingPacks ?? this.isRefreshingPacks,
      message: message == sentinel ? this.message : message as String?,
      errorMessage: errorMessage == sentinel
          ? this.errorMessage
          : errorMessage as String?,
      refreshErrorMessage: refreshErrorMessage == sentinel
          ? this.refreshErrorMessage
          : refreshErrorMessage as String?,
      unitPrice: unitPrice ?? this.unitPrice,
      serviceFee: serviceFee ?? this.serviceFee,
      profit: profit ?? this.profit,
      currency: currency ?? this.currency,
      bondPercent: bondPercent ?? this.bondPercent,
      stockPercent: stockPercent ?? this.stockPercent,
    );
  }
}
