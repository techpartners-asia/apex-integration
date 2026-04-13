class AddSecuritiesAcntApiReq {
  final String srcFiCode;
  final int? srcAcntId;
  final String? bankCode;
  final String? bankAcntCode;
  final String? bankAcntName;
  final String? acntCode;
  final String? feeAcnt;
  final String? firstName;
  final String? lastName;
  final String? mobile;
  final String? loginName;
  final String? email;
  final String? familyName;
  final String? status;
  final String? birthDate;
  final int? sexCode;
  final String? registerCode;
  final String? txnId;
  final String? qrCode;

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
