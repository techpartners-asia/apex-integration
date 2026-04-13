import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mini_app_sdk/src/app/investx_api/dto/user_entity_dto.dart';
import 'package:mini_app_sdk/src/app/session/mini_app_session_controller.dart';
import 'package:mini_app_sdk/src/app/session/mini_app_session_store.dart';
import 'package:mini_app_sdk/src/app/session/models/login_session.dart';
import 'package:mini_app_sdk/src/core/api/api_client.dart';
import 'package:mini_app_sdk/src/core/api/api_config.dart';
import 'package:mini_app_sdk/src/core/api/api_endpoints.dart';
import 'package:mini_app_sdk/src/core/api/api_executor.dart';
import 'package:mini_app_sdk/src/core/api/api_headers_builder.dart';
import 'package:mini_app_sdk/src/core/api/app_credentials.dart';
import 'package:mini_app_sdk/src/core/api/req_context.dart';
import 'package:mini_app_sdk/src/core/backend/sdk_backend_config.dart';
import 'package:mini_app_sdk/src/core/backend/sdk_runtime_config.dart';
import 'package:mini_app_sdk/src/core/token/token_provider_contract.dart';
import 'package:mini_app_sdk/src/features/ips/shared/data/api/ips_backend_api.dart';
import 'package:mini_app_sdk/src/features/ips/shared/data/dto/ips_response_dtos.dart';
import 'package:mini_app_sdk/src/features/ips/shared/data/services/api_portfolio_service.dart';
import 'package:mini_app_sdk/src/features/ips/shared/domain/models/ips_models.dart';
import 'package:mini_app_sdk/src/features/ips/shared/domain/services/investment_bootstrap_service.dart';

void main() {
  test('getDashboardData does not call the statement endpoint', () async {
    final _FakeApiExecutor executor = _FakeApiExecutor();
    final ApiPortfolioService service = ApiPortfolioService(
      api: IpsBackendApi(
        backendConfig: SdkBackendConfig(
          runtime: const SdkRuntimeConfig(
            loginSessionBaseUrl: 'https://session.example.com',
            ipsApiBaseUrl: 'https://ips.example.com',
            credentials: AppCredentials(appId: 'app', appSecret: 'secret'),
            defaultSrcFiCode: '181001',
          ),
          portfolio: const SdkPortfolioContext(
            srcFiCode: '181001',
            brokerId: '390000',
            securityCode: 'SEC001',
            casaAcntId: 99,
            stmtStartDate: '2026-04-01',
            stmtEndDate: '2026-04-09',
          ),
        ),
        protectedExecutor: executor,
      ),
      config: SdkBackendConfig(
        runtime: const SdkRuntimeConfig(
          loginSessionBaseUrl: 'https://session.example.com',
          ipsApiBaseUrl: 'https://ips.example.com',
          credentials: AppCredentials(appId: 'app', appSecret: 'secret'),
          defaultSrcFiCode: '181001',
        ),
        portfolio: const SdkPortfolioContext(
          srcFiCode: '181001',
          brokerId: '390000',
          securityCode: 'SEC001',
          casaAcntId: 99,
          stmtStartDate: '2026-04-01',
          stmtEndDate: '2026-04-09',
        ),
      ),
      session: _FakeSessionController(),
    );

    final result = await service.getDashboardData();

    expect(result.overview.currency, 'MNT');
    expect(result.yieldProfitHoldings, isNotEmpty);
    expect(result.stockYieldDetails, isNotEmpty);
    expect(
      executor.calledPaths,
      isNot(contains(ApiEndpoints.getBkrPublicCasaAcntStmt)),
    );
  });

  test(
    'getStatements uses the flag 12 account id from getSecuritiesAcntList',
    () async {
      final _FakeApiExecutor executor = _FakeApiExecutor();
      final ApiPortfolioService service = ApiPortfolioService(
        api: IpsBackendApi(
          backendConfig: SdkBackendConfig(
            runtime: const SdkRuntimeConfig(
              loginSessionBaseUrl: 'https://session.example.com',
              ipsApiBaseUrl: 'https://ips.example.com',
              credentials: AppCredentials(appId: 'app', appSecret: 'secret'),
              defaultSrcFiCode: '181001',
            ),
            portfolio: const SdkPortfolioContext(
              srcFiCode: '181001',
              brokerId: '390000',
              securityCode: 'SEC001',
              casaAcntId: 99,
              stmtStartDate: '2026-04-01',
              stmtEndDate: '2026-04-09',
            ),
          ),
          protectedExecutor: executor,
        ),
        config: SdkBackendConfig(
          runtime: const SdkRuntimeConfig(
            loginSessionBaseUrl: 'https://session.example.com',
            ipsApiBaseUrl: 'https://ips.example.com',
            credentials: AppCredentials(appId: 'app', appSecret: 'secret'),
            defaultSrcFiCode: '181001',
          ),
          portfolio: const SdkPortfolioContext(
            srcFiCode: '181001',
            brokerId: '390000',
            securityCode: 'SEC001',
            casaAcntId: 88,
            stmtStartDate: '2026-04-01',
            stmtEndDate: '2026-04-09',
          ),
        ),
        session: _FakeSessionController(),
        bootstrapService: _FakeBootstrapService(),
      );

      await service.getStatements(
        context: const SdkPortfolioContext(
          casaAcntId: 77,
          stmtStartDate: '2026-01-01',
          stmtEndDate: '2026-01-31',
        ),
      );

      expect(executor.statementAcntId, 12);
      expect(executor.statementStartDate, '2026-01-01T00:00:00.000');
      expect(executor.statementEndDate, '2026-01-31T00:00:00.000');
    },
  );
}

class _FakeApiExecutor extends ApiExecutor {
  _FakeApiExecutor()
    : super(
        client: ApiClient(
          config: const ApiConfig(
            baseUrl: 'https://example.com',
            credentials: AppCredentials(appId: 'app', appSecret: 'secret'),
          ),
          dio: Dio(),
        ),
        headersBuilder: const ApiHeadersBuilder(
          credentials: AppCredentials(appId: 'app', appSecret: 'secret'),
          tokenProvider: _FakeTokenProvider(),
        ),
      );

  final List<String> calledPaths = <String>[];
  int? statementAcntId;
  String? statementStartDate;
  String? statementEndDate;

  @override
  Future<Map<String, Object?>> postJson(
    String path, {
    required Map<String, Object?> body,
    ReqContext context = const ReqContext(),
  }) async {
    calledPaths.add(path);

    if (path == ApiEndpoints.getIpsBalance) {
      return <String, Object?>{
        'responseCode': 0,
        'responseData': <String, Object?>{
          'stockTotal': 500000,
          'bondTotal': 100000,
          'packAmount': 600000,
          'packFee': 1500,
        },
      };
    }

    if (path == ApiEndpoints.getAcntYieldProfit) {
      return <String, Object?>{
        'responseCode': 0,
        'profit': <Map<String, Object?>>[
          <String, Object?>{
            'symbol': 'PACK',
            'securityName': 'Growth Pack',
            'balance': 2,
            'buyAmount': 500000,
            'profit': 25000,
          },
        ],
      };
    }

    if (path == ApiEndpoints.getStockAcntYieldDtl) {
      return <String, Object?>{
        'responseCode': 0,
        'yield': <String, Object?>{
          'securityCode': 'SEC001',
          'securityName': 'Package Asset',
          'investmentValue': 1,
          'currentValue': 500000,
          'totalYield': 25000,
        },
      };
    }

    if (path == ApiEndpoints.getBkrPublicCasaAcntStmt) {
      statementAcntId = body['acntId'] as int?;
      statementStartDate = body['startDate'] as String?;
      statementEndDate = body['endDate'] as String?;
      return <String, Object?>{
        'responseCode': 0,
        'startDate': '2026-04-01',
        'endDate': '2026-04-09',
        'beginBalance': '0',
        'endBalance': '0',
        'totalCount': 0,
        'MgBkrCasaAcntStatementResData': const <Map<String, Object?>>[],
      };
    }

    fail('Unexpected endpoint called: $path');
  }
}

class _FakeTokenProvider extends TokenProvider {
  const _FakeTokenProvider();

  @override
  Future<String?> getAccessToken() async => 'token';
}

class _FakeSessionController extends MiniAppSessionController {
  @override
  MiniAppSessionStore get store => MiniAppSessionStore();

  @override
  Future<LoginSession> ensureLoginSession() async {
    return const LoginSession(accessToken: 'token');
  }

  @override
  Future<UserEntityDto> ensureCurrentUser() async {
    return UserEntityDto();
  }
}

class _FakeBootstrapService extends InvestmentBootstrapService {
  @override
  Future<AcntBootstrapState> getSecAcntListState({
    bool forceRefresh = false,
  }) async {
    return AcntBootstrapState(
      response: const GetSecuritiesAccountListResDto(
        detail: GetSecAcntListDetailDto(
          hasAcnt: true,
          hasIpsAcnt: true,
        ),
        acnts: <GetSecAcntListAccountDto>[
          GetSecAcntListAccountDto(
            flag: 11,
            acntId: 11,
          ),
          GetSecAcntListAccountDto(
            flag: 12,
            acntId: 12,
          ),
        ],
        stlAcnts: <GetSecAcntSettlementAccountDto>[],
        responseCode: 0,
      ),
    );
  }
}
