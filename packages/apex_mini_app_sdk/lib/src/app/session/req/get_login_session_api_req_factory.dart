import 'package:mini_app_sdk/mini_app_sdk.dart';

class GetLoginSessionApiReqFactory {
  const GetLoginSessionApiReqFactory._();

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
