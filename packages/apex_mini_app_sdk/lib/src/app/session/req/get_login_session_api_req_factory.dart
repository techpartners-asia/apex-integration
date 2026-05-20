import 'package:apex_mini_app_sdk/apex_mini_app_sdk.dart';

/// Factory for building login-session requests from the selected user source.
class GetLoginSessionApiReqFactory {
  const GetLoginSessionApiReqFactory._();

  /// Builds a request using either real user data or contract fixture data.
  static GetLoginSessionApiReq build({
    required String admSession,
    required MiniAppUserDataSourceMode userDataSourceMode,
    UserEntityDto? user,
    String fiCode = StaticApiConfig.defaultFiCode,
  }) {
    final ResolvedUserIdentity identity = ResolvedUserIdentity.resolve(
      mode: userDataSourceMode,
      user: user,
    );

    return GetLoginSessionApiReq(
      fiCode: fiCode,
      admSession: admSession,
      registerNo: identity.registerNo,
      firstName: identity.firstName,
      lastName: identity.lastName,
      familyName: identity.familyName,
      sexCode: identity.sexCode,
      birthDate: identity.birthDate,
      mobile: identity.mobile,
      email: identity.email,
    );
  }
}
