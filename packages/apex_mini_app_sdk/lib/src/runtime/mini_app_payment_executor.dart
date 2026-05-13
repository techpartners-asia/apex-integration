import 'package:mini_app_sdk/apex_mini_app_sdk.dart';
import 'package:mini_app_sdk/mini_app_sdk.dart';

import '../host/apex_mini_app_host_context.dart';

class MiniAppPaymentExecutor {
  static const String invoiceCreateFailedMessageKey = 'invoice_create_failed';
  static const String invalidInvoiceMessageKey = 'invalid_invoice_response';
  static const String hostResponseTimedOutMessageKey = 'host_response_timed_out';
  static const String hostCallbackFailedMessageKey = 'host_callback_failed';
  static const String paymentCallbackFailedMessageKey = 'payment_callback_failed';

  final MiniAppPaymentsRepository appApi;
  final MiniAppWalletPaymentHandler walletPaymentHandler;
  final Duration paymentTimeout;
  final MiniAppLogger logger;

  MiniAppPaymentExecutor({
    required this.appApi,
    required this.walletPaymentHandler,
    this.paymentTimeout = MiniAppSdkConfig.defaultPaymentTimeout,
    this.logger = const SilentMiniAppLogger(),
  });

  Future<MiniAppPaymentRes> execute({
    required MiniAppPaymentFlow flow,
    required CreateInvoiceApiReq invoiceRequest,
  }) async {
    final MiniAppPayment invoice;
    try {
      invoice = await appApi.createInvoice(invoiceRequest);
    } catch (error) {
      final String? backendMessage = switch (error) {
        ApiException(:final String message) when message.trim().isNotEmpty => message.trim(),
        _ => null,
      };

      var req = MiniAppPaymentReq(
        flow: flow,
        invoiceId: '',
        amount: invoiceRequest.amount,
        note: invoiceRequest.note,
        refId: invoiceRequest.refId,
        paymentRecordId: 0,
        isTransaction: invoiceRequest.isTransaction,
      );

      return MiniAppPaymentRes.failed(
        message: backendMessage,
        failure: MiniAppFailure(code: 'invoice_create_failed', message: backendMessage ?? 'invoice_create_failed'),
        req: req,
      );
    }

    var req = MiniAppPaymentReq(
      flow: flow,
      invoiceId: '',
      amount: invoiceRequest.amount,
      note: invoiceRequest.note,
      refId: invoiceRequest.refId,
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
      refId: invoiceRequest.refId,
      paymentRecordId: invoice.id,
      externalInvoiceId: invoice.externalInvoiceId,
      uuid: invoice.uuid,
      isTransaction: invoiceRequest.isTransaction,
    );

    final MiniAppPaymentRes hostResult;
    try {
      hostResult = await walletPaymentHandler(request).timeout(
        paymentTimeout,
        onTimeout: () => MiniAppPaymentRes.failed(req: request),
      );
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
          failure: MiniAppFailure(code: 'host_payment_exception', message: 'host_payment_exception'),
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
      await appApi.getPaymentCallback(invoiceId: request.invoiceId);
      return result;
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

      final String? backendMessage = switch (error) {
        ApiException(:final String message) when message.trim().isNotEmpty => message.trim(),
        _ => null,
      };

      return _attachPaymentContext(
        MiniAppPaymentRes.failed(
          message: backendMessage,
          failure: MiniAppFailure(code: 'payment_callback_failed', message: backendMessage ?? 'payment_callback_failed'),
          req: request,
        ),
        request: request,
      );
    }
  }

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
