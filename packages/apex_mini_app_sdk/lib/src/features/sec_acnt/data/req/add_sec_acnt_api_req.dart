/// Request body for creating/opening a securities account.
///
/// The endpoint accepts a large mixed payload from user profile, selected bank,
/// and payment/contract context. Optional empty strings are omitted in
/// [toJson] so the backend only receives values the mini app actually knows.
class AddSecuritiesAcntApiReq {
  /// Source financial institution code required by the backend.
  final String srcFiCode;

  /// Source account identifier when an existing bank/account row is selected.
  final int? srcAcntId;

  /// Bank code for the settlement account.
  final String? bankCode;

  /// Bank account or IBAN number.
  final String? bankAcntCode;

  /// Bank account holder name.
  final String? bankAcntName;

  /// Existing Apex account code, if available.
  final String? acntCode;

  /// Fee account code used for account opening payment.
  final String? feeAcnt;

  /// User first name.
  final String? firstName;

  /// User last name.
  final String? lastName;

  /// User mobile number.
  final String? mobile;

  /// Login/user name value required by backend account opening.
  final String? loginName;

  /// User email address.
  final String? email;

  /// Family name when available in the user profile.
  final String? familyName;

  /// Account request status value.
  final String? status;

  /// User birth date.
  final String? birthDate;

  /// Backend sex code.
  final int? sexCode;

  /// Registration number.
  final String? registerCode;

  /// Payment transaction id associated with account opening.
  final String? txnId;

  /// QR/payment code when account opening is linked to payment flow.
  final String? qrCode;

  /// Creates a securities account opening request.
  const AddSecuritiesAcntApiReq({
    required this.srcFiCode,
    this.srcAcntId,
    this.bankCode,
    this.bankAcntCode,
    this.bankAcntName,
    this.acntCode,
    this.feeAcnt,
    this.firstName,
    this.lastName,
    this.mobile,
    this.loginName,
    this.email,
    this.familyName,
    this.status,
    this.birthDate,
    this.sexCode,
    this.registerCode,
    this.txnId,
    this.qrCode,
  });

  /// Builds JSON and omits null/empty optional fields.
  Map<String, Object?> toJson() {
    final Map<String, Object?> json = <String, Object?>{'srcFiCode': srcFiCode};
    void put(String key, Object? value) {
      if (value == null) {
        return;
      }
      if (value is String && value.trim().isEmpty) {
        return;
      }
      json[key] = value is String ? value.trim() : value;
    }

    put('srcAcntId', srcAcntId);
    put('bankCode', bankCode);
    put('bankAcntCode', bankAcntCode);
    put('bankAcntName', bankAcntName);
    put('acntCode', acntCode);
    put('feeAcnt', feeAcnt);
    put('firstName', firstName);
    put('lastName', lastName);
    put('mobile', mobile);
    put('loginName', loginName);
    put('email', email);
    put('familyName', familyName);
    put('status', status);
    put('birthDate', birthDate);
    put('sexCode', sexCode);
    put('registerCode', registerCode);
    put('txnId', txnId);
    put('qrCode', qrCode);
    return json;
  }
}
