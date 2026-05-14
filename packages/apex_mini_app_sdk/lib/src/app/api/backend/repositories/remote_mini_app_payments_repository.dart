part of '../mini_app_api_repository.dart';

class RemoteMiniAppPaymentsRepository implements MiniAppPaymentsRepository {
  final MiniAppApiBackend api;
  final MiniAppSessionController session;
  final MiniAppLogger logger;

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
      final response = await api.getPaymentCallback(PaymentCallbackQuery(uuid: uuid));
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
