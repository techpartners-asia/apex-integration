import 'package:apex_mini_app_sdk/apex_mini_app_sdk.dart';
import 'package:flutter_test/flutter_test.dart';


void main() {
  test(
    'resolves bootstrap banking values from account and settlement fallbacks',
    () {
      final AcntBootstrapState state = AcntBootstrapState(
        response: GetSecuritiesAcntListResDto(
          detail: const GetSecuritiesAcntListDetailDto(
            hasAcnt: true,
            hasIpsAcnt: false,
          ),
          acnts: const <GetSecAcntListAccountDto>[
            GetSecAcntListAccountDto(
              flag: 3,
              bankCode: 'SEC001',
              bankName: 'Securities Bank',
              acntCode: 'SC-0001',
              scAcntCode: 'SCA-001',
              status: 1,
              availableBalance: 12500,
              balance: 15000,
              symbol: 'MNT',
            ),
          ],
          stlAcnts: const <GetSecAcntSettlementAccountDto>[
            GetSecAcntSettlementAccountDto(
              isDefault: true,
              bkrFiCode: 'FI001',
              bkrFiName: 'Settlement Bank',
              bkrAcntCode: '49900112233',
            ),
          ],
          responseCode: 0,
        ),
      );

      expect(state.bootstrapBankCode, 'SEC001');
      expect(state.bootstrapBankName, 'Securities Bank');
      expect(state.bootstrapIban, '49900112233');
      expect(state.currency, 'MNT');
      expect(state.hasOpenSecAcnt, isTrue);
    },
  );

  test(
    'derives hasAcnt from flag=3 account row when detail flag is false',
    () {
      final AcntBootstrapState state = AcntBootstrapState(
        response: GetSecuritiesAcntListResDto(
          detail: const GetSecuritiesAcntListDetailDto(
            hasAcnt: false,
            hasIpsAcnt: false,
          ),
          acnts: const <GetSecAcntListAccountDto>[
            GetSecAcntListAccountDto(
              flag: 3,
              status: AcntBootstrapState.secAcntStatusUnpaid,
            ),
          ],
          stlAcnts: const <GetSecAcntSettlementAccountDto>[],
          responseCode: 0,
        ),
      );

      expect(state.hasAcnt, isTrue);
      expect(state.hasPaidSecAcntOpeningFeeFromApi, isFalse);
      expect(state.requiresSecAcntOpeningFeePayment, isTrue);
    },
  );

  test(
    'treats status=0 and isPaid as paid opening fee from backend',
    () {
      final AcntBootstrapState pendingState = AcntBootstrapState(
        response: GetSecuritiesAcntListResDto(
          detail: const GetSecuritiesAcntListDetailDto(
            hasAcnt: true,
            hasIpsAcnt: true,
          ),
          acnts: const <GetSecAcntListAccountDto>[
            GetSecAcntListAccountDto(
              flag: 3,
              status: AcntBootstrapState.secAcntStatusPending,
            ),
          ],
          stlAcnts: const <GetSecAcntSettlementAccountDto>[],
          responseCode: 0,
        ),
      );
      final AcntBootstrapState paidFlagState = AcntBootstrapState(
        response: GetSecuritiesAcntListResDto(
          detail: const GetSecuritiesAcntListDetailDto(
            hasAcnt: true,
            hasIpsAcnt: true,
          ),
          acnts: const <GetSecAcntListAccountDto>[
            GetSecAcntListAccountDto(
              flag: 3,
              status: AcntBootstrapState.secAcntStatusUnpaid,
              isPaid: true,
            ),
          ],
          stlAcnts: const <GetSecAcntSettlementAccountDto>[],
          responseCode: 0,
        ),
      );

      expect(pendingState.hasPaidSecAcntOpeningFeeFromApi, isTrue);
      expect(pendingState.hasPendingSecAcntActivation, isTrue);
      expect(pendingState.canContinueToQuestionnaireFromOverview, isTrue);
      expect(pendingState.hasOpenSecAcnt, isFalse);
      expect(paidFlagState.hasPaidSecAcntOpeningFeeFromApi, isTrue);
    },
  );

  test('copyWithBalanceState overlays refreshed balance values', () {
    final AcntBootstrapState currentState = AcntBootstrapState(
      response: GetSecuritiesAcntListResDto(
        detail: const GetSecuritiesAcntListDetailDto(
          hasAcnt: true,
          hasIpsAcnt: true,
        ),
        acnts: const <GetSecAcntListAccountDto>[
          GetSecAcntListAccountDto(
            flag: 3,
            acntCode: 'SC-0001',
            scAcntCode: 'SCA-001',
            balance: 10,
            availableBalance: 8,
          ),
        ],
        stlAcnts: const <GetSecAcntSettlementAccountDto>[],
        responseCode: 0,
      ),
    );

    final AcntBootstrapState refreshedState = currentState.copyWithBalanceState(
      const GetSecuritiesAcntListResDto(
        detail: GetSecuritiesAcntListDetailDto(hasAcnt: true, hasIpsAcnt: true),
        acnts: <GetSecAcntListAccountDto>[
          GetSecAcntListAccountDto(
            flag: 3,
            balance: 42,
            availableBalance: 39,
            custId: 77,
          ),
        ],
        stlAcnts: <GetSecAcntSettlementAccountDto>[],
        responseCode: 0,
      ),
    );

    expect(refreshedState.secBalance, 39);
    expect(refreshedState.secAcntStatusCode, currentState.secAcntStatusCode);
  });
}
