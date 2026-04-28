import 'package:mini_app_sdk/mini_app_sdk.dart';

class GetLoginSessionApiReq {
  final String fiCode;
  final String admSession;
  final String mobile;
  final String registerNo;
  final String firstName;
  final String lastName;
  final String? familyName;
  final String? email;
  final String? sexCode;
  final String? birthDate;

  GetLoginSessionApiReq({
    required String fiCode,
    required String admSession,
    required String mobile,
    required String registerNo,
    required String firstName,
    required String lastName,
    this.familyName,
    this.email,
    this.sexCode,
    this.birthDate,
  }) : fiCode = fiCode.trim(),
       admSession = admSession.trim(),
       mobile = mobile.trim(),
       registerNo = registerNo.trim(),
       firstName = firstName.trim(),
       lastName = lastName.trim() {
    if ([
      this.fiCode,
      this.admSession,
      this.mobile,
      this.registerNo,
      this.firstName,
      this.lastName,
    ].any((String value) => value.isEmpty)) {
      throw const ApiIntegrationException(
        'getLoginSession requires fiCode, admSession, mobile, registerNo, firstName, and lastName.',
      );
    }
  }

  Map<String, Object?> toJson() {
    return <String, Object?>{
      'fiCode': fiCode,
      'admSession': admSession,
      'mobile': mobile,
      'registerNo': registerNo,
      'firstName': firstName,
      'lastName': lastName,
      if (familyName case final String value when value.trim().isNotEmpty)
        'familyName': value.trim(),
      if (email case final String value when value.trim().isNotEmpty)
        'email': value.trim(),
      if (sexCode case final String value when value.trim().isNotEmpty)
        'sexCode': value.trim(),
      if (birthDate case final String value when value.trim().isNotEmpty)
        'birthDate': value.trim(),
    };
  }
}
