import 'package:flutter_test/flutter_test.dart';
import 'package:mini_app_sdk/mini_app_sdk.dart';

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
      'routes users with main account and bank account to questionnaire',
      () {
        final AcntBootstrapState state = _bootstrapState(
          hasAcnt: true,
          hasIpsAcnt: false,
          secAcntStatusCode: 1,
        );

        expect(
          MiniAppBootstrapFlow.resolveNextRoute(
            state,
            currentUser: UserEntityDto(
              bank: const BankDto(accountNumber: '325005005800716755'),
            ),
          ),
          MiniAppRoutes.questionnaire,
        );
      },
    );

    test(
      'routes users with main account but no bank account to sec account',
      () {
        final AcntBootstrapState state = _bootstrapState(
          hasAcnt: true,
          hasIpsAcnt: false,
          secAcntStatusCode: 1,
        );

        expect(
          MiniAppBootstrapFlow.resolveNextRoute(
            state,
            currentUser: UserEntityDto(
              bank: const BankDto(accountNumber: '  '),
            ),
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

    test('does not route to overview when sec account is not open', () {
      final AcntBootstrapState state = _bootstrapState(
        hasAcnt: true,
        hasIpsAcnt: true,
        secAcntStatusCode: 0,
      );

      expect(
        MiniAppBootstrapFlow.resolveNextRoute(state),
        MiniAppRoutes.secAcnt,
      );
    });
  });
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
