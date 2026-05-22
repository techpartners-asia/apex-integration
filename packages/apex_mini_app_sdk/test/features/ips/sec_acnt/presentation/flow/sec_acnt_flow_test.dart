import 'package:apex_mini_app_sdk/apex_mini_app_sdk.dart';
import 'package:flutter_test/flutter_test.dart';

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

    test('continues flow when account-opening request is already pending', () {
      expect(
        resolveSecAcntFlowSteps(
          _bootstrapState(
            hasAcnt: true,
            hasIpsAcnt: true,
            secAcntStatusCode: 0,
          ),
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
    });

    test(
      'returns consent initial step for pending account-opening request',
      () {
        expect(
          resolveInitialSecAcntFlowStep(
            _bootstrapState(
              hasAcnt: true,
              hasIpsAcnt: true,
              secAcntStatusCode: 0,
            ),
          ),
          SecAcntFlowStep.consent,
        );
      },
    );

    test('skips personal information when profile fields are complete', () {
      expect(
        resolveSecAcntFlowSteps(
          _bootstrapState(hasAcnt: false, hasIpsAcnt: false),
          currentUser: _completeUser(),
        ),
        const <SecAcntFlowStep>[
          SecAcntFlowStep.consent,
          SecAcntFlowStep.secAgreement,
          SecAcntFlowStep.signature,
          SecAcntFlowStep.payment,
          SecAcntFlowStep.calculation,
        ],
      );
    });

    test(
      'keeps personal information when one required profile field is missing',
      () {
        expect(
          resolveSecAcntFlowSteps(
            _bootstrapState(hasAcnt: false, hasIpsAcnt: false),
            currentUser: _completeUser(email: ''),
          ),
          contains(SecAcntFlowStep.personalInformation),
        );
      },
    );

    test(
      'skips account contract and signature when saved signature exists',
      () {
        expect(
          resolveSecAcntFlowSteps(
            _bootstrapState(hasAcnt: false, hasIpsAcnt: false),
            currentUser: _completeUser(
              account: const AccountDto(signatureId: 31),
            ),
          ),
          const <SecAcntFlowStep>[
            SecAcntFlowStep.consent,
            SecAcntFlowStep.payment,
            SecAcntFlowStep.calculation,
          ],
        );
      },
    );

    test('keeps signature flow when saved signature is missing', () {
      expect(
        resolveSecAcntFlowSteps(
          _bootstrapState(hasAcnt: false, hasIpsAcnt: false),
          currentUser: _completeUser(),
        ),
        containsAllInOrder(<SecAcntFlowStep>[
          SecAcntFlowStep.secAgreement,
          SecAcntFlowStep.signature,
        ]),
      );
    });

    test(
      'paid contract skips payment without treating missing account as opened',
      () {
        final AcntBootstrapState state = _bootstrapState(
          hasAcnt: false,
          hasIpsAcnt: false,
        );

        expect(
          resolveSecAcntFlowSteps(
            state,
            currentUser: _completeUser(
              account: const AccountDto(isPaidContract: true),
            ),
          ),
          const <SecAcntFlowStep>[
            SecAcntFlowStep.consent,
            SecAcntFlowStep.secAgreement,
            SecAcntFlowStep.signature,
            SecAcntFlowStep.calculation,
          ],
        );
        expect(state.hasAcnt, isFalse);
        expect(state.hasOpenSecAcnt, isFalse);
      },
    );

    test(
      'unpaid contract keeps payment step when account is still missing',
      () {
        expect(
          resolveSecAcntFlowSteps(
            _bootstrapState(hasAcnt: false, hasIpsAcnt: false),
            currentUser: _completeUser(
              account: const AccountDto(isPaidContract: false),
            ),
          ),
          contains(SecAcntFlowStep.payment),
        );
      },
    );
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

UserEntityDto _completeUser({
  String phone = '88993076',
  String phoneAddition = '99112233',
  String email = 'investx@example.com',
  AccountDto? account,
}) {
  return UserEntityDto(
    phone: phone,
    phoneAddition: phoneAddition,
    email: email,
    account: account,
    bank: const BankDto(
      accountNumber: '325005005800716755',
      accountName: 'Investor Name',
      bankCode: '390000',
      bankName: 'Хаан банк',
    ),
  );
}

AcntBootstrapState _bootstrapState({
  required bool hasAcnt,
  required bool hasIpsAcnt,
  int? secAcntStatusCode,
}) {
  return AcntBootstrapState(
    response: GetSecuritiesAcntListResDto(
      detail: GetSecuritiesAcntListDetailDto(
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
