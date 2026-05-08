import 'package:mini_app_sdk/mini_app_sdk.dart';

abstract interface class LoginSessionRepository {
  Future<LoginSession> getLoginSession(UserEntityDto user);
}

class RemoteLoginSessionRepository implements LoginSessionRepository {
  final LoginSessionBackendApi api;
  final SdkRuntimeConfig runtimeConfig;
  final MiniAppUserDataSourceMode userDataSourceMode;

  const RemoteLoginSessionRepository({
    required this.api,
    required this.runtimeConfig,
    this.userDataSourceMode = MiniAppUserDataSourceMode.realUser,
  });

  @override
  Future<LoginSession> getLoginSession(UserEntityDto user) async {
    final LoginSessionResponseDto response = await api.getLoginSession(
      GetLoginSessionApiReqFactory.build(
        admSession: runtimeConfig.neSession!,
        fiCode: runtimeConfig.defaultFiCode,
        userDataSourceMode: userDataSourceMode,
        user: user,
      ),
    );

    return response.toDomain();
  }
}
