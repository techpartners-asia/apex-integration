import 'package:flutter_test/flutter_test.dart';
import 'package:mini_app_core/mini_app_core.dart';
import 'package:mini_app_sdk/l10n/sdk_localizations_mn.dart';
import 'package:mini_app_sdk/src/features/shared/presentation/helpers/ips_label_resolvers.dart';

void main() {
  final SdkLocalizationsMn l10n = SdkLocalizationsMn();

  test('prefers explicit payment error message over generic message key', () {
    final MiniAppPaymentRes result = MiniAppPaymentRes.failed(
      message: 'Дансны нэр хоосон байна.',
      failure: MiniAppFailure(
        code: 'invoice_create_failed',
        message: 'Дансны нэр хоосон байна.',
      ),
      req: MiniAppPaymentReq(
        flow: MiniAppPaymentFlow.ipsRecharge,
        invoiceId: '',
        amount: 0,
        note: '',
        refId: '',
        paymentRecordId: 0,
        isTransaction: true,
      ),
    );

    expect(
      resolvePaymentResultMessage(l10n, result),
      'Дансны нэр хоосон байна.',
    );
  });

  test(
    'falls back to localized payment copy when no explicit message exists',
    () {
      final MiniAppPaymentRes result = MiniAppPaymentRes.failed(
        failure: MiniAppFailure(
          code: 'invoice_create_failed',
          message: 'invoice_create_failed',
        ),
        req: MiniAppPaymentReq(
          flow: MiniAppPaymentFlow.ipsRecharge,
          invoiceId: '',
          amount: 0,
          note: '',
          refId: '',
          paymentRecordId: 0,
          isTransaction: true,
        ),
      );

      expect(
        resolvePaymentResultMessage(l10n, result),
        l10n.ipsPaymentInvoiceCreateFailed,
      );
    },
  );
}
