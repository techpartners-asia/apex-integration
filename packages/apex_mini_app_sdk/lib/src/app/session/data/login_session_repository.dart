import 'package:mini_app_sdk/mini_app_sdk.dart';

abstract interface class LoginSessionRepository {
  Future<LoginSession> getLoginSession(UserEntityDto user);
}

class RemoteLoginSessionRepository implements LoginSessionRepository {
  final LoginSessionBackendApi api;
  final SdkRuntimeConfig runtimeConfig;

  const RemoteLoginSessionRepository({
    required this.api,
    required this.runtimeConfig,
  });

  @override
  Future<LoginSession> getLoginSession(UserEntityDto user) async {
    final LoginSessionResponseDto response = await api.getLoginSession(
      GetLoginSessionApiReqFactory.temporary(
        admSession: runtimeConfig.neSession!,
      ),
    );

    return response.toDomain();
  }
}
