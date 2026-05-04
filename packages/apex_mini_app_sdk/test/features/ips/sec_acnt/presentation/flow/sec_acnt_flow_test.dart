import 'package:flutter_test/flutter_test.dart';
import 'package:mini_app_sdk/mini_app_sdk.dart';

void main() {
  group('resolveSecAcntFlowSteps', () {
    test('uses short flow for users with main account and no IPS account', () {
      expect(
        resolveSecAcntFlowSteps(
          _bootstrapState(hasAcnt: true, hasIpsAcnt: false),
        ),
        const <SecAcntFlowStep>[
          SecAcntFlowStep.consent,
          SecAcntFlowStep.personalInformation,
          SecAcntFlowStep.success,
          SecAcntFlowStep.serviceAgreement,
        ],
      );
    });

    test(
      'uses full flow for users without main account and without IPS account',
      () {
        expect(
          resolveSecAcntFlowSteps(
            _bootstrapState(hasAcnt: false, hasIpsAcnt: false),
          ),
          const <SecAcntFlowStep>[
            SecAcntFlowStep.consent,
            SecAcntFlowStep.personalInformation,
            SecAcntFlowStep.secAgreement,
            SecAcntFlowStep.signature,
            SecAcntFlowStep.payment,
            SecAcntFlowStep.calculation,
          ],
        );
      },
    );

    test('keeps payment flow when IPS exists but SEC account is not open', () {
      expect(
        resolveSecAcntFlowSteps(
          _bootstrapState(
            hasAcnt: true,
            hasIpsAcnt: true,
            secAcntStatusCode: 0,
          ),
        ),
        const <SecAcntFlowStep>[
          SecAcntFlowStep.payment,
          SecAcntFlowStep.calculation,
        ],
      );
    });
  });

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

AcntBootstrapState _bootstrapState({
  required bool hasAcnt,
  required bool hasIpsAcnt,
  int? secAcntStatusCode,
}) {
  return AcntBootstrapState(
    response: GetSecuritiesAccountListResDto(
      detail: GetSecAcntListDetailDto(
        hasAcnt: hasAcnt,
        hasIpsAcnt: hasIpsAcnt,
      ),
      acnts: <GetSecAcntListAccountDto>[
        if (hasAcnt)
          GetSecAcntListAccountDto(
            flag: 3,
            status: secAcntStatusCode,
          ),
      ],
      stlAcnts: const <GetSecAcntSettlementAccountDto>[],
      responseCode: 0,
    ),
  );
}
