part of '../mini_app_api_repository.dart';

/// Remote implementation of invoice creation and payment polling.
class RemoteMiniAppPaymentsRepository implements MiniAppPaymentsRepository {
  /// Low-level API facade for payment endpoints.
  final MiniAppApiBackend api;

  /// Session controller that supplies the admin auth token.
  final MiniAppSessionController session;

  /// Logger used for endpoint failures.
  final MiniAppLogger logger;

  /// Creates the remote payments repository.
  const RemoteMiniAppPaymentsRepository({
    required this.api,
    required this.session,
    this.logger = const SilentMiniAppLogger(),
  });

  @override
  Future<MiniAppPayment> createInvoice(CreateInvoiceApiReq req) async {
    try {
      await _ensureAdminAuthToken(session);
      final response = await api.createInvoice(req);
      return response.toDomain();
    } catch (error, stackTrace) {
      logger.onError(
        'create_invoice_failed',
        error: error,
        stackTrace: stackTrace,
      );
      rethrow;
    }
  }

  @override
  Future<String> getPaymentCallback({required String uuid}) async {
    try {
      await _ensureAdminAuthToken(session);
      final response = await api.getPaymentCallback(
        PaymentCallbackQuery(uuid: uuid),
      );
      return response.body;
    } catch (error, stackTrace) {
      logger.onError(
        'payment_callback_failed',
        error: error,
        stackTrace: stackTrace,
      );
      rethrow;
    }
  }
}
