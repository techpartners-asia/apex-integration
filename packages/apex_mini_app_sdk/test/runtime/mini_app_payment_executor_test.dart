import 'package:flutter_test/flutter_test.dart';
import 'package:mini_app_sdk/apex_mini_app_sdk.dart';
import 'package:mini_app_sdk/mini_app_sdk.dart';

void main() {
  test('calls payment callback after successful wallet payment', () async {
    final _FakePaymentsRepository paymentsRepository = _FakePaymentsRepository();
    final MiniAppPaymentExecutor executor = MiniAppPaymentExecutor(
      appApi: paymentsRepository,
      walletPaymentHandler: (_) async {
        return MiniAppPaymentRes.success(
          req: MiniAppPaymentReq(
            flow: MiniAppPaymentFlow.ipsRecharge,
            invoiceId: '',
            amount: 0,
            note: '',
            paymentRecordId: 0,
            isTransaction: true,
          ),
        );
      },
    );

    final MiniAppPaymentRes result = await executor.execute(
      flow: MiniAppPaymentFlow.ipsRecharge,
      invoiceRequest: _invoiceRequest(),
    );

    expect(result.status, MiniAppPaymentStatus.success);
    expect(paymentsRepository.callbackInvoiceIds, <String>['INV-123']);
  });

  test('does not call payment callback when wallet payment fails', () async {
    final _FakePaymentsRepository paymentsRepository = _FakePaymentsRepository();
    final MiniAppPaymentExecutor executor = MiniAppPaymentExecutor(
      appApi: paymentsRepository,
      walletPaymentHandler: (_) async {
        return MiniAppPaymentRes.failed(
          req: MiniAppPaymentReq(
            flow: MiniAppPaymentFlow.ipsRecharge,
            invoiceId: '',
            amount: 0,
            note: '',
            paymentRecordId: 0,
            isTransaction: true,
          ),
        );
      },
    );

    final MiniAppPaymentRes result = await executor.execute(
      flow: MiniAppPaymentFlow.ipsRecharge,
      invoiceRequest: _invoiceRequest(),
    );

    expect(result.status, MiniAppPaymentStatus.failed);
    expect(paymentsRepository.callbackInvoiceIds, isEmpty);
  });

  test('returns failed result when payment callback fails', () async {
    final _FakePaymentsRepository paymentsRepository = _FakePaymentsRepository(
      callbackError: const ApiBusinessException(
        responseCode: 9999,
        message: 'Callback failed',
      ),
    );
    final MiniAppPaymentExecutor executor = MiniAppPaymentExecutor(
      appApi: paymentsRepository,
      walletPaymentHandler: (_) async {
        return MiniAppPaymentRes.success(
          req: MiniAppPaymentReq(
            flow: MiniAppPaymentFlow.ipsRecharge,
            invoiceId: '',
            amount: 0,
            note: '',
            paymentRecordId: 0,
            isTransaction: true,
          ),
        );
      },
    );

    final MiniAppPaymentRes result = await executor.execute(
      flow: MiniAppPaymentFlow.ipsRecharge,
      invoiceRequest: _invoiceRequest(),
    );

    expect(result.status, MiniAppPaymentStatus.failed);
    expect(result.message, 'Callback failed');
    expect(paymentsRepository.callbackInvoiceIds, <String>['INV-123']);
  });
}

CreateInvoiceApiReq _invoiceRequest() {
  return CreateInvoiceApiReq(
    amount: 1000,
    note: 'test_payment',
    isTransaction: true,
  );
}

class _FakePaymentsRepository implements MiniAppPaymentsRepository {
  _FakePaymentsRepository({this.callbackError});

  final Object? callbackError;
  final List<String> callbackInvoiceIds = <String>[];

  @override
  Future<MiniAppPayment> createInvoice(CreateInvoiceApiReq req) async {
    return const MiniAppPayment(
      id: 1,
      amount: 1000,
      status: MiniAppPaymentStatus.unknown,
      externalInvoiceId: 'INV-123',
      note: 'test_payment',
    );
  }

  @override
  Future<String> getPaymentCallback({required String uuid}) async {
    callbackInvoiceIds.add(uuid);
    final Object? error = callbackError;
    if (error != null) {
      throw error;
    }
    return 'ok';
  }
}
