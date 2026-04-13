import 'get_login_session_api_req.dart';

import '../../../core/api/static_api_config.dart';
import '../constants/login_session_contract.dart';

class GetLoginSessionApiReqFactory {
  const GetLoginSessionApiReqFactory._();

  ///Temporary req contract for getLoginSession().
  ///
  ///Remove this factory once the backend is ready to accept the real current
  ///user payload dynamically.
  static GetLoginSessionApiReq temporary({required String admSession}) {
    return GetLoginSessionApiReq(
      fiCode: StaticApiConfig.defaultFiCode,
      admSession: admSession,
      registerNo: LoginSessionContract.registerNo,
      firstName: LoginSessionContract.firstName,
      lastName: LoginSessionContract.lastName,
      familyName: LoginSessionContract.familyName,
      sexCode: LoginSessionContract.sexCode,
      birthDate: LoginSessionContract.birthDate,
      mobile: LoginSessionContract.mobile,
      email: LoginSessionContract.email,
    );
  }
}
