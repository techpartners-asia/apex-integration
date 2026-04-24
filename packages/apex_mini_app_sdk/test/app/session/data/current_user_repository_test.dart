import 'package:flutter_test/flutter_test.dart';
import 'package:mini_app_sdk/mini_app_sdk.dart';

class _FakeSignUpBackendApi extends SignUpBackendApi {
  _FakeSignUpBackendApi(this.response) : super(executor: null);

  final UserEntityDto response;
  String? capturedUserToken;

  @override
  Future<UserEntityDto> signUp(SignUpApiReq req) async {
    capturedUserToken = req.token;
    return response;
  }
}

class _FakeMiniAppApiBackend extends MiniAppApiBackend {
  _FakeMiniAppApiBackend(this.response)
    : super(publicExecutor: null, authorizedExecutor: null);

  final UserEntityDto response;
  int getProfileInfoCalls = 0;

  @override
  Future<UserEntityDto> getProfileInfo() async {
    getProfileInfoCalls += 1;
    return response;
  }
}

void main() {
  test(
    'signup repository updates shared token provider before profile hydration',
    () async {
      final signUpApi = _FakeSignUpBackendApi(
        UserEntityDto.fromJson(<String, Object?>{
          'message': '',
          'body': <String, Object?>{
            'token': 'signup-jwt-token',
            'user': <String, Object?>{
              'rd': '',
              'first_name': '',
              'last_name': '',
              'phone': '88993076',
            },
          },
        }),
      );
      final profileApi = _FakeMiniAppApiBackend(
        UserEntityDto.fromJson(<String, Object?>{
          'message': '',
          'body': <String, Object?>{
            'rd': 'AB12345678',
            'first_name': 'Bold',
            'last_name': 'Baatar',
            'phone': '88993076',
            'email': 'bold@example.com',
            'gender': 'M',
          },
        }),
      );
      final adminTokenProvider = MutableTokenProvider();

      final repo = RemoteSignupBootstrapRepository(
        api: signUpApi,
        profileApi: profileApi,
        adminTokenProvider: adminTokenProvider,
      );

      final user = await repo.getCurrentUser(userToken: 'host-user-token');

      expect(signUpApi.capturedUserToken, 'host-user-token');
      expect(profileApi.getProfileInfoCalls, 1);
      expect(adminTokenProvider.currentAccessToken, 'signup-jwt-token');
      expect(user.admSession, 'signup-jwt-token');
      expect(user.registerNo, 'AB12345678');
      expect(user.firstName, 'Bold');
      expect(user.lastName, 'Baatar');
      expect(user.phone, '88993076');
    },
  );

  test(
    'signup repository preserves admin token without profile hydration',
    () async {
      final signUpApi = _FakeSignUpBackendApi(
        UserEntityDto(
          token: 'signup-jwt-token',
          registerNo: 'AB12345678',
          firstName: 'Bold',
          lastName: 'Baatar',
          phone: '88993076',
        ),
      );
      final adminTokenProvider = MutableTokenProvider();

      final repo = RemoteSignupBootstrapRepository(
        api: signUpApi,
        adminTokenProvider: adminTokenProvider,
      );

      final user = await repo.getCurrentUser(userToken: 'host-user-token');

      expect(signUpApi.capturedUserToken, 'host-user-token');
      expect(adminTokenProvider.currentAccessToken, 'signup-jwt-token');
      expect(user.admSession, 'signup-jwt-token');
      expect(user.phone, '88993076');
    },
  );
}
