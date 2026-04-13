import 'package:flutter_test/flutter_test.dart';
import 'package:mini_app_sdk/src/app/investx_api/dto/user_entity_dto.dart';
import 'package:mini_app_sdk/src/core/backend/sdk_portfolio_context.dart';
import 'package:mini_app_sdk/src/features/ips/shared/application/portfolio_context_resolver.dart';
import 'package:mini_app_sdk/src/features/ips/shared/data/dto/get_sec_acnt_list_res_dto.dart';
import 'package:mini_app_sdk/src/features/ips/shared/domain/models/acnt_bootstrap_state.dart';

void main() {
  group('PortfolioContextResolver', () {
    test('builds a meaningful normalized context from bootstrap state', () {
      final PortfolioContextResolver resolver = PortfolioContextResolver(
        defaultSrcFiCode: '181',
        now: () => DateTime(2026, 4, 7, 15, 0),
      );

      final SdkPortfolioContext context = resolver.resolve(
        bootstrapState: const AcntBootstrapState(
          response: GetSecuritiesAccountListResDto(
            detail: GetSecAcntListDetailDto(
              hasAcnt: true,
              hasIpsAcnt: true,
              brokerCode: 'DETAIL-BROKER',
            ),
            acnts: <GetSecAcntListAccountDto>[
              GetSecAcntListAccountDto(
                flag: 3,
                brokerId: 'BROKER-1',
                instrumentCode: 'SEC-1',
              ),
              GetSecAcntListAccountDto(
                flag: 12,
                acntId: 55,
                statementMaxDay: '7',
              ),
            ],
            stlAcnts: <GetSecAcntSettlementAccountDto>[],
            responseCode: 0,
          ),
        ),
      );

      expect(context.normalizedBrokerId, 'BROKER-1');
      expect(context.normalizedSecurityCode, 'SEC-1');
      expect(context.normalizedCasaAcntId, 55);
      expect(context.normalizedStmtStartDate, '2026-04-01');
      expect(context.normalizedStmtEndDate, '2026-04-07');
      expect(context.resolveSrcFiCode('181'), '181');
    });

    test('keeps explicit seed values and uses user account as fallback', () {
      final PortfolioContextResolver resolver = PortfolioContextResolver(
        seed: const SdkPortfolioContext(
          brokerId: 'SEEDED-BROKER',
          casaAcntId: 90,
        ),
        defaultSrcFiCode: '181',
      );

      final SdkPortfolioContext context = resolver.resolve(
        user: UserEntityDto(
          account: const AccountDto(
            scAcntCode: 'USER-SC-ACCOUNT',
          ),
        ),
      );

      expect(context.normalizedBrokerId, 'SEEDED-BROKER');
      expect(context.normalizedSecurityCode, 'USER-SC-ACCOUNT');
      expect(context.normalizedCasaAcntId, 90);
      expect(context.resolveSrcFiCode('181'), '181');
    });
  });
}
