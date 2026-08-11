import 'package:apex_mini_app_sdk/apex_mini_app_sdk.dart';

/// UI state for securities-account opening flow.
class IpsSecAcntState {
  /// Whether a submit/payment action is running.
  final bool isSubmitting;

  /// Account-opening request result.
  final SecAcntRequestResult? requestResult;

  /// Host payment result.
  final MiniAppPaymentRes? paymentRes;

  /// User-facing error message.
  final String? errorMessage;

  /// Additional account fee loaded for securities account opening payment.
  final double accountFeesAmount;

  /// Whether the account-fees amount endpoint is loading.
  final bool isLoadingAccountFees;

  /// Whether account fees were loaded at least once for this payment session.
  final bool hasLoadedAccountFees;

  /// Whether the opening-fee commission payment is currently required.
  ///
  /// Defaults to `true` (real payment) until the backend check completes, so
  /// a pending/failed check never silently skips the wallet handoff.
  final bool isPaymentActive;

  /// Whether the is-payment-active endpoint is loading.
  final bool isCheckingPaymentActive;

  /// Whether the is-payment-active check completed at least once for this
  /// payment session.
  final bool hasCheckedPaymentActive;

  /// Creates securities-account opening state.
  const IpsSecAcntState({
    this.isSubmitting = false,
    this.requestResult,
    this.paymentRes,
    this.errorMessage,
    this.accountFeesAmount = 0,
    this.isLoadingAccountFees = false,
    this.hasLoadedAccountFees = false,
    this.isPaymentActive = true,
    this.isCheckingPaymentActive = false,
    this.hasCheckedPaymentActive = false,
  });

  /// Opening commission plus account fees from [accountFeesAmount].
  double totalPayableAmount(double baseCommission) =>
      baseCommission + accountFeesAmount;

  /// Sentinel used to distinguish omitted nullable fields from explicit null.
  static const Object sentinel = Object();

  /// Copies state while allowing explicit null assignment for nullable fields.
  IpsSecAcntState copyWith({
    bool? isSubmitting,
    Object? requestResult = sentinel,
    Object? paymentRes = sentinel,
    Object? errorMessage = sentinel,
    double? accountFeesAmount,
    bool? isLoadingAccountFees,
    bool? hasLoadedAccountFees,
    bool? isPaymentActive,
    bool? isCheckingPaymentActive,
    bool? hasCheckedPaymentActive,
  }) {
    return IpsSecAcntState(
      isSubmitting: isSubmitting ?? this.isSubmitting,
      requestResult: requestResult == sentinel
          ? this.requestResult
          : requestResult as SecAcntRequestResult?,
      paymentRes: paymentRes == sentinel
          ? this.paymentRes
          : paymentRes as MiniAppPaymentRes?,
      errorMessage: errorMessage == sentinel
          ? this.errorMessage
          : errorMessage as String?,
      accountFeesAmount: accountFeesAmount ?? this.accountFeesAmount,
      isLoadingAccountFees:
          isLoadingAccountFees ?? this.isLoadingAccountFees,
      hasLoadedAccountFees:
          hasLoadedAccountFees ?? this.hasLoadedAccountFees,
      isPaymentActive: isPaymentActive ?? this.isPaymentActive,
      isCheckingPaymentActive:
          isCheckingPaymentActive ?? this.isCheckingPaymentActive,
      hasCheckedPaymentActive:
          hasCheckedPaymentActive ?? this.hasCheckedPaymentActive,
    );
  }
}
