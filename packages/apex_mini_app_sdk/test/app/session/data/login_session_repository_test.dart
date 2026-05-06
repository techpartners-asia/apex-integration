import 'package:flutter_test/flutter_test.dart';
import 'package:mini_app_sdk/mini_app_sdk.dart';

const _runtimeConfig = SdkRuntimeConfig(
  loginSessionBaseUrl: 'https://example.com',
  ipsApiBaseUrl: 'https://example.com',
  credentials: AppCredentials(appId: 'app-id', appSecret: 'app-secret'),
  neSession: 'ne-session',
);

class _FakeLoginSessionBackendApi extends LoginSessionBackendApi {
  _FakeLoginSessionBackendApi()
    : super(executor: null, runtimeConfig: _runtimeConfig);

  GetLoginSessionApiReq? capturedReq;

  @override
  Future<LoginSessionResponseDto> getLoginSession(
    GetLoginSessionApiReq req,
  ) async {
    capturedReq = req;
    return const LoginSessionResponseDto(accessToken: 'access-token');
  }
}

void main() {
  test('repository builds login session request from real user mode', () async {
    final api = _FakeLoginSessionBackendApi();
    final repository = RemoteLoginSessionRepository(
      api: api,
      runtimeConfig: _runtimeConfig,
      userDataSourceMode: MiniAppUserDataSourceMode.realUser,
    );

    final session = await repository.getLoginSession(
      UserEntityDto(
        registerNo: 'AB12345678',
        firstName: 'Bold',
        lastName: 'Baatar',
        phone: '88993076',
        email: 'bold@example.com',
      ),
    );

    expect(session.accessToken, 'access-token');
    expect(api.capturedReq?.registerNo, 'AB12345678');
    expect(api.capturedReq?.firstName, 'Bold');
    expect(api.capturedReq?.lastName, 'Baatar');
    expect(api.capturedReq?.mobile, '88993076');
    expect(api.capturedReq?.email, 'bold@example.com');
  });
}
