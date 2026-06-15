import 'package:apex_mini_app_sdk/apex_mini_app_sdk.dart';

/// UI state for contract setup and pack purchase flow.
class ContractState {
  /// Whether initialization is running.
  final bool isInitializing;

  /// Whether submit/payment is running.
  final bool isSubmitting;

  /// Selected pack purchase quantity.
  final int purchaseQty;

  /// Created contract response.
  final ContractRes? contractRes;

  /// Bootstrap state after IPS accounts are available.
  final AcntBootstrapState? bootstrapState;

  /// Portfolio/pricing overview.
  final PortfolioOverview? overview;

  /// Host payment result.
  final MiniAppPaymentRes? paymentRes;

  /// User-facing error message.
  final String? errorMessage;

  /// Creates contract setup and purchase state.
  const ContractState({
    this.isInitializing = false,
    this.isSubmitting = false,
    this.purchaseQty = 1,
    this.contractRes,
    this.bootstrapState,
    this.overview,
    this.paymentRes,
    this.errorMessage,
  });

  /// Sentinel used to distinguish omitted nullable fields from explicit null.
  static const Object sentinel = Object();

  /// Whether required initialization data is present.
  bool get isReady => contractRes != null && bootstrapState != null && overview != null;

  /// Whether purchase price is available.
  bool get hasPricing => (overview?.packAmount ?? 0) > 0;

  /// Whether submit button should be enabled.
  bool get canSubmit => isReady && hasPricing && purchaseQty > 0 && !isSubmitting;

  /// Unit pack price used by contract purchase calculation.
  double get unitPrice => overview?.packAmount ?? 0;

  /// Service fee added to the contract purchase total.
  double get serviceFee => overview?.packFee ?? 0;

  /// Current pack balance shown before purchasing more packs.
  double get currentPackBalance => overview?.packQty ?? 0;

  /// Total payable amount for the selected quantity and service fee.
  double get totalPayable => purchaseQty <= 0 ? 0 : purchaseQty * (unitPrice + serviceFee);

  /// Copies state while allowing explicit null assignment for nullable fields.
  ContractState copyWith({
    bool? isInitializing,
    bool? isSubmitting,
    int? purchaseQty,
    Object? contractRes = sentinel,
    Object? bootstrapState = sentinel,
    Object? overview = sentinel,
    Object? paymentRes = sentinel,
    Object? errorMessage = sentinel,
  }) {
    return ContractState(
      isInitializing: isInitializing ?? this.isInitializing,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      purchaseQty: purchaseQty ?? this.purchaseQty,
      contractRes: contractRes == sentinel ? this.contractRes : contractRes as ContractRes?,
      bootstrapState: bootstrapState == sentinel ? this.bootstrapState : bootstrapState as AcntBootstrapState?,
      overview: overview == sentinel ? this.overview : overview as PortfolioOverview?,
      paymentRes: paymentRes == sentinel ? this.paymentRes : paymentRes as MiniAppPaymentRes?,
      errorMessage: errorMessage == sentinel ? this.errorMessage : errorMessage as String?,
    );
  }
}
