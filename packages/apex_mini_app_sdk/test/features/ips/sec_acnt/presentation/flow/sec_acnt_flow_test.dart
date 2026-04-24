import 'package:flutter_test/flutter_test.dart';
import 'package:mini_app_sdk/mini_app_sdk.dart';

void main() {
  test(
    'fromBootstrap uses bank id as display label when bootstrap bank name is missing',
    () {
      final SecAcntFlowDraft draft = SecAcntFlowDraft.fromBootstrap(
        null,
        user: UserEntityDto(
          bank: const BankDto(
            bankCode: 'FI001',
            bankId: 'Khan Bank',
            accountNumber: 'MN991122334455',
          ),
        ),
      );

      expect(draft.selectedBank, isNotNull);
      expect(draft.selectedBank!.id, 'FI001');
      expect(draft.selectedBank!.label, 'Khan Bank');
      expect(draft.iban, '991122334455');
    },
  );
}
