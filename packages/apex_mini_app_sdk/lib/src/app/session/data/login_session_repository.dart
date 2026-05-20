import 'package:apex_mini_app_sdk/apex_mini_app_sdk.dart';

/// Resolves the normalized session used by mini-app API calls.
abstract interface class LoginSessionRepository {
  /// Fetches a login session for the current user.
  Future<LoginSession> getLoginSession(UserEntityDto user);
}

/// Login-session repository backed by the host-configured Apex endpoint.
class RemoteLoginSessionRepository implements LoginSessionRepository {
  /// API wrapper for the login-session endpoint.
  final LoginSessionBackendApi api;

  /// Runtime values used to build request headers and defaults.
  final SdkRuntimeConfig runtimeConfig;

  /// Selects whether the request uses real user or contract fixture data.
  final MiniAppUserDataSourceMode userDataSourceMode;

  /// Creates a login-session repository.
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
