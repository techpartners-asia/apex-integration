/// Optional bootstrap values supplied by host/config or resolved during startup.
class SdkBootstrapContext {
  /// User registration number.
  final String? registerCode;

  /// User phone number.
  final String? phone;

  /// Host/session identifier.
  final String? sessionId;

  /// Existing securities account code.
  final String? secAcntCode;

  /// User first name.
  final String? firstName;

  /// User last name.
  final String? lastName;

  /// User family name.
  final String? familyName;

  /// User email.
  final String? email;

  /// Login name used by securities account APIs.
  final String? loginName;

  /// User birth date.
  final String? birthDate;

  /// Backend sex code.
  final int? sexCode;

  /// Source account id.
  final int? sourceAcntId;

  /// Fee account code.
  final String? feeAcnt;

  /// Securities account request status.
  final String? acntReqStatus;

  /// Transaction id used by account-opening/payment flows.
  final String? txnId;

  /// Creates optional bootstrap context for account-opening flows.
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
