import 'package:mini_app_sdk/mini_app_sdk.dart';

class IpsContractState {
  final bool isInitializing;
  final bool isSubmitting;
  final int purchaseQty;
  final ContractRes? contractRes;
  final AcntBootstrapState? bootstrapState;
  final PortfolioOverview? overview;
  final MiniAppPaymentRes? paymentRes;
  final String? errorMessage;

  const IpsContractState({
    this.isInitializing = false,
    this.isSubmitting = false,
    this.purchaseQty = 1,
    this.contractRes,
    this.bootstrapState,
    this.overview,
    this.paymentRes,
    this.errorMessage,
  });

  static const Object sentinel = Object();

  bool get isReady =>
      contractRes != null && bootstrapState != null && overview != null;

  bool get hasPricing => (overview?.packAmount ?? 0) > 0;

  bool get canSubmit =>
      isReady && hasPricing && purchaseQty > 0 && !isSubmitting;

  double get unitPrice => overview?.packAmount ?? 0;

  double get serviceFee => overview?.packFee ?? 0;

  double get currentPackBalance => overview?.packQty ?? 0;

  double get totalPayable =>
      purchaseQty <= 0 ? 0 : (purchaseQty * unitPrice) + serviceFee;

  IpsContractState copyWith({
    bool? isInitializing,
    bool? isSubmitting,
    int? purchaseQty,
    Object? contractRes = sentinel,
    Object? bootstrapState = sentinel,
    Object? overview = sentinel,
    Object? paymentRes = sentinel,
    Object? errorMessage = sentinel,
  }) {
    return IpsContractState(
      isInitializing: isInitializing ?? this.isInitializing,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      purchaseQty: purchaseQty ?? this.purchaseQty,
      contractRes: contractRes == sentinel
          ? this.contractRes
          : contractRes as ContractRes?,
      bootstrapState: bootstrapState == sentinel
          ? this.bootstrapState
          : bootstrapState as AcntBootstrapState?,
      overview: overview == sentinel
          ? this.overview
          : overview as PortfolioOverview?,
      paymentRes: paymentRes == sentinel
          ? this.paymentRes
          : paymentRes as MiniAppPaymentRes?,
      errorMessage: errorMessage == sentinel
          ? this.errorMessage
          : errorMessage as String?,
    );
  }
}
