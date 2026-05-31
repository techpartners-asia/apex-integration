import 'package:apex_mini_app_sdk/apex_mini_app_sdk.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('MiniAppBootstrapFlow.resolveNextRoute', () {
    test('routes ready users directly to overview', () {
      final AcntBootstrapState state = _bootstrapState(
        hasAcnt: true,
        hasIpsAcnt: true,
        secAcntStatusCode: 1,
      );

      expect(
        MiniAppBootstrapFlow.resolveNextRoute(state),
        MiniAppRoutes.overview,
      );
    });

    test(
      'routes short-flow users with complete onboarding to overview',
      () {
        final AcntBootstrapState state = _bootstrapState(
          hasAcnt: true,
          hasIpsAcnt: false,
          secAcntStatusCode: 1,
        );

        expect(
          MiniAppBootstrapFlow.resolveNextRoute(
            state,
            currentUser: _completeUser(
              account: const AccountDto(
                isPaidContract: true,
                isInvestContract: true,
              ),
            ),
          ),
          MiniAppRoutes.overview,
        );
      },
    );

    test(
      'routes short-flow open accounts to overview even when contract is pending',
      () {
        final AcntBootstrapState state = _bootstrapState(
          hasAcnt: true,
          hasIpsAcnt: false,
          secAcntStatusCode: 1,
        );

        expect(
          MiniAppBootstrapFlow.resolveNextRoute(
            state,
            currentUser: _completeUser(),
          ),
          MiniAppRoutes.overview,
        );
      },
    );

    test(
      'routes short-flow pending accounts to overview',
      () {
        final AcntBootstrapState state = _bootstrapState(
          hasAcnt: true,
          hasIpsAcnt: false,
          secAcntStatusCode: AcntBootstrapState.secAcntStatusPending,
        );

        expect(
          MiniAppBootstrapFlow.resolveNextRoute(
            state,
            currentUser: _completeUser(),
          ),
          MiniAppRoutes.overview,
        );
      },
    );

    test(
      'routes short-flow unpaid accounts to sec account',
      () {
        final AcntBootstrapState state = _bootstrapState(
          hasAcnt: true,
          hasIpsAcnt: false,
          secAcntStatusCode: AcntBootstrapState.secAcntStatusUnpaid,
        );

        expect(
          MiniAppBootstrapFlow.resolveNextRoute(
            state,
            currentUser: _completeUser(
              account: const AccountDto(isPaidContract: true),
            ),
          ),
          MiniAppRoutes.secAcnt,
        );
      },
    );

    test(
      'routes short-flow users with incomplete profile to sec account',
      () {
        final AcntBootstrapState state = _bootstrapState(
          hasAcnt: true,
          hasIpsAcnt: false,
          secAcntStatusCode: 1,
        );

        expect(
          MiniAppBootstrapFlow.resolveNextRoute(
            state,
            currentUser: _completeUser(email: ''),
          ),
          MiniAppRoutes.secAcnt,
        );
      },
    );

    test('routes users without main account to sec account', () {
      final AcntBootstrapState state = _bootstrapState(
        hasAcnt: false,
        hasIpsAcnt: false,
      );

      expect(
        MiniAppBootstrapFlow.resolveNextRoute(state),
        MiniAppRoutes.secAcnt,
      );
    });

    test(
      'paid contract does not make a missing securities account routable as opened',
      () {
        final AcntBootstrapState state = _bootstrapState(
          hasAcnt: false,
          hasIpsAcnt: false,
        );

        expect(
          MiniAppBootstrapFlow.resolveNextRoute(
            state,
            currentUser: _completeUser(
              account: const AccountDto(isPaidContract: true),
            ),
          ),
          MiniAppRoutes.secAcnt,
        );
        expect(state.hasAcnt, isFalse);
        expect(state.hasOpenSecAcnt, isFalse);
      },
    );

    test('does not route to overview when sec account is not open', () {
      final AcntBootstrapState state = _bootstrapState(
        hasAcnt: true,
        hasIpsAcnt: true,
        secAcntStatusCode: AcntBootstrapState.secAcntStatusPending,
      );

      expect(
        MiniAppBootstrapFlow.resolveNextRoute(state),
        MiniAppRoutes.secAcnt,
      );
    });

    test(
      'routes to overview when paid pending account only has calculation left',
      () {
        final AcntBootstrapState state = _bootstrapState(
          hasAcnt: true,
          hasIpsAcnt: true,
          secAcntStatusCode: AcntBootstrapState.secAcntStatusPending,
        );

        expect(
          MiniAppBootstrapFlow.resolveNextRoute(
            state,
            currentUser: _completeUser(
              account: const AccountDto(
                isInvestContract: true,
                isPaidContract: false,
                signatureId: 31,
              ),
            ),
          ),
          MiniAppRoutes.overview,
        );
      },
    );

    test(
      'routes to sec account when API status is unpaid even if profile is paid',
      () {
        final AcntBootstrapState state = _bootstrapState(
          hasAcnt: true,
          hasIpsAcnt: true,
          secAcntStatusCode: AcntBootstrapState.secAcntStatusUnpaid,
        );

        expect(
          MiniAppBootstrapFlow.resolveNextRoute(
            state,
            currentUser: _completeUser(
              account: const AccountDto(
                isInvestContract: true,
                isPaidContract: true,
                signatureId: 31,
              ),
            ),
          ),
          MiniAppRoutes.secAcnt,
        );
      },
    );
  });
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
