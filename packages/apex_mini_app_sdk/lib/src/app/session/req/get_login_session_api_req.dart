/// Request body for bootstrapping a login session.
class GetLoginSessionApiReq {
  /// Financial institution code.
  final String fiCode;

  /// ADM session token.
  final String admSession;

  /// User mobile number.
  final String mobile;

  /// User registration number.
  final String registerNo;

  /// User first name.
  final String firstName;

  /// User last name.
  final String lastName;

  /// Optional family name.
  final String? familyName;

  /// Optional email.
  final String? email;

  /// Optional sex code.
  final String? sexCode;

  /// Optional birth date.
  final String? birthDate;

  /// Creates and normalizes a login-session bootstrap request.
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
      // throw const ApiIntegrationException(
      //   'getLoginSession requires fiCode, admSession, mobile, registerNo, firstName, and lastName.',
      // );
    }
  }

  /// Converts this request to backend JSON.
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
