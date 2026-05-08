import 'package:mini_app_sdk/mini_app_sdk.dart';
import 'package:mini_app_ui/mini_app_ui.dart';

import '../host/apex_mini_app_host_context.dart';

class MiniAppPaymentExecutor {
  static const String invoiceCreateFailedMessageKey = 'invoice_create_failed';
  static const String invalidInvoiceMessageKey = 'invalid_invoice_response';
  static const String hostResponseTimedOutMessageKey =
      'host_response_timed_out';
  static const String hostCallbackFailedMessageKey = 'host_callback_failed';
  static const String paymentCallbackFailedMessageKey =
      'payment_callback_failed';

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
    required MiniAppWalletPaymentFlow flow,
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

      return MiniAppPaymentRes.failed(
        message: backendMessage,
        paymentReference: invoiceRequest.refId,
        metadata: const <String, Object?>{
          'messageKey': invoiceCreateFailedMessageKey,
        },
        failure: MiniAppFailure(
          code: 'invoice_create_failed',
          message: backendMessage ?? 'invoice_create_failed',
        ),
        isTransaction: invoiceRequest.isTransaction,
      );
    }

    final String? invoiceId = invoice.resolvedInvoiceId;
    if (invoiceId == null || invoiceId.trim().isEmpty) {
      return MiniAppPaymentRes.failed(
        paymentReference: invoiceRequest.refId,
        metadata: const <String, Object?>{
          'messageKey': invalidInvoiceMessageKey,
        },
        failure: MiniAppFailure(
          code: 'invalid_invoice_response',
          message: 'invalid_invoice_response',
        ),
        isTransaction: invoiceRequest.isTransaction,
      );
    }

    final MiniAppWalletPaymentRequest request = MiniAppWalletPaymentRequest(
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
        onTimeout: () => MiniAppPaymentRes.timedOut(
          metadata: <String, Object?>{
            'messageKey': hostResponseTimedOutMessageKey,
          },
          isTransaction: invoiceRequest.isTransaction,
        ),
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
          metadata: const <String, Object?>{
            'messageKey': hostCallbackFailedMessageKey,
          },
          failure: MiniAppFailure(
            code: 'host_payment_exception',
            message: 'host_payment_exception',
          ),
          isTransaction: invoiceRequest.isTransaction,
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
        ApiException(:final String message) when message.trim().isNotEmpty =>
          message.trim(),
        _ => null,
      };

      return _attachPaymentContext(
        MiniAppPaymentRes.failed(
          message: backendMessage,
          metadata: const <String, Object?>{
            'messageKey': paymentCallbackFailedMessageKey,
          },
          failure: MiniAppFailure(
            code: 'payment_callback_failed',
            message: backendMessage ?? 'payment_callback_failed',
          ),
          isTransaction: invoiceRequest.isTransaction,
        ),
        request: request,
      );
    }
  }

  MiniAppPaymentRes _attachPaymentContext(
    MiniAppPaymentRes result, {
    required MiniAppWalletPaymentRequest request,
  }) {
    final Map<String, Object?> metadata = <String, Object?>{
      ...result.metadata,
      'invoiceId': request.invoiceId,
      'flow': request.flow.name,
      'amount': request.amount,
      'note': request.note,
      'refId': request.refId,
      'paymentRecordId': request.paymentRecordId,
      'externalInvoiceId': request.externalInvoiceId,
      'uuid': request.uuid,
    };
    final String paymentReference =
        _normalized(result.paymentReference) ?? request.invoiceId;

    switch (result.status) {
      case MiniAppPaymentStatus.success:
        return MiniAppPaymentRes.success(
          message: result.message,
          transactionId: result.transactionId,
          paymentReference: paymentReference,
          metadata: metadata,
          isTransaction: request.isTransaction,
        );
      case MiniAppPaymentStatus.failed:
        return MiniAppPaymentRes.failed(
          message: result.message,
          transactionId: result.transactionId,
          paymentReference: paymentReference,
          failure: result.failure,
          metadata: metadata,
          isTransaction: request.isTransaction,
        );
      case MiniAppPaymentStatus.cancelled:
        return MiniAppPaymentRes.cancelled(
          message: result.message,
          transactionId: result.transactionId,
          paymentReference: paymentReference,
          metadata: metadata,
          isTransaction: request.isTransaction,
        );
      case MiniAppPaymentStatus.timedOut:
        return MiniAppPaymentRes.timedOut(
          message: result.message,
          transactionId: result.transactionId,
          paymentReference: paymentReference,
          metadata: metadata,
          isTransaction: request.isTransaction,
        );
      case MiniAppPaymentStatus.unsupported:
        return MiniAppPaymentRes.unsupported(
          message: result.message,
          failure: result.failure,
          metadata: metadata,
          isTransaction: request.isTransaction,
        );
      case MiniAppPaymentStatus.pending:
        return MiniAppPaymentRes.pending(
          message: result.message,
          transactionId: result.transactionId,
          paymentReference: paymentReference,
          metadata: metadata,
          isTransaction: request.isTransaction,
        );
      case MiniAppPaymentStatus.paid:
        return MiniAppPaymentRes.success(
          message: result.message,
          transactionId: result.transactionId,
          paymentReference: paymentReference,
          metadata: <String, Object?>{
            ...metadata,
            'originalStatus': MiniAppPaymentStatus.paid.name,
          },
          isTransaction: request.isTransaction,
        );
      case MiniAppPaymentStatus.unknown:
        return MiniAppPaymentRes.unknown(
          message: result.message,
          transactionId: result.transactionId,
          paymentReference: paymentReference,
          failure: result.failure,
          metadata: metadata,
          isTransaction: request.isTransaction,
        );
    }
  }

  String? _normalized(String? value) {
    final String? trimmed = value?.trim();
    if (trimmed == null || trimmed.isEmpty) {
      return null;
    }
    return trimmed;
  }
}
