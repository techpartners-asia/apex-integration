class SecAcntRequestResult {
  final String? message;
  final int? refNo;
  final String? srcFiCode;
  final SecAcntMcsdRequest? mcsdRequest;

  const SecAcntRequestResult({
    this.message,
    this.refNo,
    this.srcFiCode,
    this.mcsdRequest,
  });
}

class SecAcntMcsdRequest {
  final int? brokerId;
  final String? country;
  final String? bankAccountNumber;
  final String? bdcAccountNumber;
  final String? gender;
  final String? registryNumber;
  final String? bankCode;
  final String? firstName;
  final String? lastName;
  final String? bankName;
  final int? customerType;
  final double? feeDebt;
  final double? feeEquity;
  final String? bdcAccountId;
  final String? homeAddress;
  final String? mcsdAccountId;
  final String? homePhone;
  final String? mobilePhone;
  final String? occupation;
  final double? feeCorpDebt;
  final String? birthDate;
  final String? createdDate;
  final String? receivedDate;
  final List<SecAcntCasaAccount> casaAccounts;

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

class SecAcntCasaAccount {
  final String? accountCode;
  final String? currencyCode;
  final int? type;

  const SecAcntCasaAccount({this.accountCode, this.currencyCode, this.type});
}
