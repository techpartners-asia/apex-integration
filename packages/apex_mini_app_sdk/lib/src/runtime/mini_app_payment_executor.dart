import 'package:apex_mini_app_sdk/apex_mini_app_sdk.dart';

import '../host/apex_mini_app_host_context.dart';

/// Coordinates mini-app payment with the backend and host wallet UI.
///
/// The flow is:
/// 1. create invoice through the SDK API repository;
/// 2. pass the resolved invoice to the host payment callback;
/// 3. notify the backend after host wallet success;
/// 4. return a normalized `MiniAppPaymentRes` to the feature flow.
class MiniAppPaymentExecutor {
  /// Error code used when invoice creation fails.
  static const String invoiceCreateFailedMessageKey = 'invoice_create_failed';

  /// Error code used when invoice response misses required identifiers.
  static const String invalidInvoiceMessageKey = 'invalid_invoice_response';

  /// Error code used when the host wallet callback does not answer in time.
  static const String hostResponseTimedOutMessageKey =
      'host_response_timed_out';

  /// Error code used when the host wallet callback throws.
  static const String hostCallbackFailedMessageKey = 'host_callback_failed';

  /// Error code used when backend payment callback fails after wallet success.
  static const String paymentCallbackFailedMessageKey =
      'payment_callback_failed';

  /// API repository used for invoice creation and payment callback.
  final MiniAppPaymentsRepository appApi;

  /// Host wallet/payment callback.
  final MiniAppWalletPaymentHandler walletPaymentHandler;

  /// Max duration allowed for [walletPaymentHandler]. null = no timeout.
  final Duration? paymentTimeout;

  /// Logger for payment diagnostics.
  final MiniAppLogger logger;

  /// Creates a payment executor for one SDK runtime.
  ///
  /// [walletPaymentHandler] is supplied by the host app and is the only place
  /// where native wallet/payment UI should be opened.
  MiniAppPaymentExecutor({
    required this.appApi,
    required this.walletPaymentHandler,
    this.paymentTimeout,
    this.logger = const SilentMiniAppLogger(),
  });

  /// Executes the full payment handoff for [flow].
  Future<MiniAppPaymentRes> execute({
    required MiniAppPaymentFlow flow,
    required CreateInvoiceApiReq invoiceRequest,
  }) async {
    final MiniAppPayment invoice;
    try {
      invoice = await appApi.createInvoice(invoiceRequest);
    } catch (error) {
      final String? backendMessage = switch (error) {
        ApiException(:final String message) when message.trim().isNotEmpty =>
          message.trim(),
        _ => null,
      };

      var req = MiniAppPaymentReq(
        flow: flow,
        invoiceId: '',
        amount: invoiceRequest.amount,
        note: invoiceRequest.note,
        paymentRecordId: 0,
        isTransaction: invoiceRequest.isTransaction,
      );

      return MiniAppPaymentRes.failed(
        message: backendMessage,
        failure: MiniAppFailure(
          code: 'invoice_create_failed',
          message: backendMessage ?? 'invoice_create_failed',
        ),
        req: req,
      );
    }

    var req = MiniAppPaymentReq(
      flow: flow,
      invoiceId: '',
      amount: invoiceRequest.amount,
      note: invoiceRequest.note,
      paymentRecordId: 0,
      isTransaction: invoiceRequest.isTransaction,
    );

    final String? invoiceId = invoice.resolvedInvoiceId;
    if (invoiceId == null || invoiceId.trim().isEmpty) {
      return MiniAppPaymentRes.failed(
        failure: MiniAppFailure(
          code: 'invalid_invoice_response',
          message: 'invalid_invoice_response',
        ),
        req: req,
      );
    }

    final MiniAppPaymentReq request = MiniAppPaymentReq(
      flow: flow,
      invoiceId: invoiceId,
      amount: invoice.amount,
      note: invoice.note ?? invoiceRequest.note,
      paymentRecordId: invoice.id,
      externalInvoiceId: invoice.externalInvoiceId,
      uuid: invoice.uuid,
      isTransaction: invoiceRequest.isTransaction,
    );

    final MiniAppPaymentRes hostResult;
    try {
      final Future<MiniAppPaymentRes> walletFuture = walletPaymentHandler(request);
      hostResult = await (paymentTimeout != null
          ? walletFuture.timeout(
              paymentTimeout!,
              onTimeout: () => MiniAppPaymentRes.failed(req: request),
            )
          : walletFuture);
    } catch (error, stackTrace) {
      ApexMiniAppHostContext.emitError(error, stackTrace);
      logger.onError(
        'host_wallet_callback_failed',
        error: error,
        stackTrace: stackTrace,
        data: <String, Object?>{
          'invoiceId': request.invoiceId,
          'flow': request.flow.name,
        },
      );
      return _attachPaymentContext(
        MiniAppPaymentRes.failed(
          failure: MiniAppFailure(
            code: 'host_payment_exception',
            message: 'host_payment_exception',
          ),
          req: request,
        ),
        request: request,
      );
    }

    final MiniAppPaymentRes result = _attachPaymentContext(
      hostResult,
      request: request,
    );
    if (result.status != MiniAppPaymentStatus.success) {
      return result;
    }

    try {
      await appApi.getPaymentCallback(uuid: invoice.uuid ?? '');
    } catch (error, stackTrace) {
      logger.onError(
        'payment_callback_failed_after_wallet_success',
        error: error,
        stackTrace: stackTrace,
        data: <String, Object?>{
          'invoiceId': request.invoiceId,
          'flow': request.flow.name,
        },
      );
    }

    return result;
  }

  /// Ensures every host result carries the original SDK payment request.
  MiniAppPaymentRes _attachPaymentContext(
    MiniAppPaymentRes result, {
    required MiniAppPaymentReq request,
  }) {
    switch (result.status) {
      case MiniAppPaymentStatus.success:
        return MiniAppPaymentRes.success(
          message: result.message,
          transactionId: result.transactionId,
          req: request,
        );
      case MiniAppPaymentStatus.failed:
        return MiniAppPaymentRes.failed(
          message: result.message,
          transactionId: result.transactionId,
          failure: result.failure,
          req: request,
        );
      case MiniAppPaymentStatus.unknown:
        return MiniAppPaymentRes.unknown(
          message: result.message,
          transactionId: result.transactionId,
          req: request,
        );
    }
  }
}
