class SdkBootstrapContext {
  final String? registerCode;
  final String? phone;
  final String? sessionId;
  final String? secAcntCode;
  final String? firstName;
  final String? lastName;
  final String? familyName;
  final String? email;
  final String? loginName;
  final String? birthDate;
  final int? sexCode;
  final int? sourceAcntId;
  final String? feeAcnt;
  final String? acntReqStatus;
  final String? txnId;

  const SdkBootstrapContext({
    this.registerCode,
    this.phone,
    this.sessionId,
    this.secAcntCode,
    this.firstName,
    this.lastName,
    this.familyName,
    this.email,
    this.loginName,
    this.birthDate,
    this.sexCode,
    this.sourceAcntId,
    this.feeAcnt,
    this.acntReqStatus,
    this.txnId,
  });
}
