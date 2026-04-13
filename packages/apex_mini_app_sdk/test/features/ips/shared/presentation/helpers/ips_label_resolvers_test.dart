import 'package:flutter_test/flutter_test.dart';
import 'package:mini_app_core/mini_app_core.dart';
import 'package:mini_app_sdk/l10n/sdk_localizations_mn.dart';
import 'package:mini_app_sdk/src/features/ips/shared/presentation/helpers/ips_label_resolvers.dart';
import 'package:mini_app_sdk/src/runtime/mini_app_payment_executor.dart';

void main() {
  final SdkLocalizationsMn l10n = SdkLocalizationsMn();

  test('prefers explicit payment error message over generic message key', () {
    final MiniAppPaymentRes result = MiniAppPaymentRes.failed(
      message: 'Дансны нэр хоосон байна.',
      metadata: const <String, Object?>{
        'messageKey': MiniAppPaymentExecutor.invoiceCreateFailedMessageKey,
      },
      failure: MiniAppFailure(
        code: 'invoice_create_failed',
        message: 'Дансны нэр хоосон байна.',
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
        metadata: const <String, Object?>{
          'messageKey': MiniAppPaymentExecutor.invoiceCreateFailedMessageKey,
        },
        failure: MiniAppFailure(
          code: 'invoice_create_failed',
          message: 'invoice_create_failed',
        ),
      );

      expect(
        resolvePaymentResultMessage(l10n, result),
        l10n.ipsPaymentInvoiceCreateFailed,
      );
    },
  );
}
