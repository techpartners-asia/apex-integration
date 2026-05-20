/// Result returned after submitting a securities account opening request.
class SecAcntRequestResult {
  /// Backend message, if any.
  final String? message;

  /// Reference number for the request.
  final int? refNo;

  /// Source financial institution code.
  final String? srcFiCode;

  /// Nested MCSD request payload returned by the backend.
  final SecAcntMcsdRequest? mcsdRequest;

  /// Creates a securities account request result.
  const SecAcntRequestResult({
    this.message,
    this.refNo,
    this.srcFiCode,
    this.mcsdRequest,
  });
}

/// Detailed MCSD request payload returned for a securities account request.
class SecAcntMcsdRequest {
  /// Broker identifier.
  final int? brokerId;

  /// Country code/name.
  final String? country;

  /// Settlement bank account number.
  final String? bankAccountNumber;

  /// BDC account number.
  final String? bdcAccountNumber;

  /// Gender code/name.
  final String? gender;

  /// User registration number.
  final String? registryNumber;

  /// Settlement bank code.
  final String? bankCode;

  /// User first name.
  final String? firstName;

  /// User last name.
  final String? lastName;

  /// Settlement bank name.
  final String? bankName;

  /// Backend customer type.
  final int? customerType;

  /// Debt fee value.
  final double? feeDebt;

  /// Equity fee value.
  final double? feeEquity;

  /// BDC account identifier.
  final String? bdcAccountId;

  /// Home address.
  final String? homeAddress;

  /// MCSD account identifier.
  final String? mcsdAccountId;

  /// Home phone number.
  final String? homePhone;

  /// Mobile phone number.
  final String? mobilePhone;

  /// Occupation text.
  final String? occupation;

  /// Corporate debt fee value.
  final double? feeCorpDebt;

  /// Birth date string.
  final String? birthDate;

  /// Created timestamp.
  final String? createdDate;

  /// Received timestamp.
  final String? receivedDate;

  /// CASA accounts included in the response.
  final List<SecAcntCasaAccount> casaAccounts;

  /// Creates an MCSD request detail model.
  const SecAcntMcsdRequest({
    this.brokerId,
    this.country,
    this.bankAccountNumber,
    this.bdcAccountNumber,
    this.gender,
    this.registryNumber,
    this.bankCode,
    this.firstName,
    this.lastName,
    this.bankName,
    this.customerType,
    this.feeDebt,
    this.feeEquity,
    this.bdcAccountId,
    this.homeAddress,
    this.mcsdAccountId,
    this.homePhone,
    this.mobilePhone,
    this.occupation,
    this.feeCorpDebt,
    this.birthDate,
    this.createdDate,
    this.receivedDate,
    this.casaAccounts = const <SecAcntCasaAccount>[],
  });
}

/// CASA account entry attached to the MCSD request result.
class SecAcntCasaAccount {
  /// CASA account code.
  final String? accountCode;

  /// Currency code.
  final String? currencyCode;

  /// Backend account type.
  final int? type;

  /// Creates a CASA account entry.
  const SecAcntCasaAccount({this.accountCode, this.currencyCode, this.type});
}
