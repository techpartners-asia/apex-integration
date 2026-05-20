import 'package:apex_mini_app_sdk/apex_mini_app_sdk.dart';

/// Response DTO for a securities account opening request.
class AddSecuritiesAcntResDto {
  /// Backend success or informational message.
  final String? message;

  /// Backend reference number for the request.
  final int? refNo;

  /// Source financial institution code returned by the backend.
  final String? srcFiCode;

  /// MCSD request details created by the backend.
  final McsdReqDto? mcsdReq;

  /// Creates a securities account opening response DTO.
  const AddSecuritiesAcntResDto({
    this.message,
    this.refNo,
    this.srcFiCode,
    this.mcsdReq,
  });

  /// Parses and validates the action response before mapping fields.
  factory AddSecuritiesAcntResDto.fromJson(Map<String, Object?> json) {
    ApiActionResultParser.ensureSuccess(
      json,
      fallbackErrorMessage: 'Securities account request failed.',
    );

    return AddSecuritiesAcntResDto(
      message: ApiActionResultParser.messageOf(json),
      refNo: ApiParser.asNullableInt(json['refNo']),
      srcFiCode: ApiParser.asNullableString(json['srcFiCode']),
      mcsdReq: McsdReqDto.fromNullableJson(
        ApiParser.asObjectMap(json['mcsdReq']),
      ),
    );
  }

  /// Converts the API DTO into the domain result used by onboarding flow.
  SecAcntRequestResult toDomain() {
    return SecAcntRequestResult(
      message: message,
      refNo: refNo,
      srcFiCode: srcFiCode,
      mcsdRequest: mcsdReq?.toDomain(),
    );
  }
}

/// MCSD request payload returned after securities account opening.
class McsdReqDto {
  /// Broker identifier.
  final int? brokerId;

  /// User country.
  final String? country;

  /// Bank account number.
  final String? bankAccountNumber;

  /// BDC account number.
  final String? bdcAccountNumber;

  /// User gender.
  final String? gender;

  /// Registration number.
  final String? registryNumber;

  /// Bank code.
  final String? bankCode;

  /// User first name.
  final String? firstName;

  /// User last name.
  final String? lastName;

  /// Bank name.
  final String? bankName;

  /// Backend customer type code.
  final int? customerType;

  /// Debt fee amount.
  final double? feeDebt;

  /// Equity fee amount.
  final double? feeEquity;

  /// BDC account identifier.
  final String? bdcAccountId;

  /// Home/residential address.
  final String? homeAddress;

  /// MCSD account identifier.
  final String? mcsdAccountId;

  /// Home phone number.
  final String? homePhone;

  /// Mobile phone number.
  final String? mobilePhone;

  /// Occupation text.
  final String? occupation;

  /// Corporate debt fee amount.
  final double? feeCorpDebt;

  /// User birth date.
  final String? birthDate;

  /// Request creation date.
  final String? createdDate;

  /// Request received date.
  final String? receivedDate;

  /// CASA accounts returned with the MCSD request.
  final List<CasaAccountDto> casaAccounts;

  /// Creates an MCSD request DTO.
  const McsdReqDto({
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
    this.casaAccounts = const <CasaAccountDto>[],
  });

  /// Parses MCSD request JSON returned by the account-opening API.
  factory McsdReqDto.fromJson(Map<String, Object?> json) {
    return McsdReqDto(
      brokerId: ApiParser.asNullableInt(json['brokerId']),
      country: ApiParser.asNullableString(json['country']),
      bankAccountNumber: ApiParser.asNullableString(json['bankAccountNumber']),
      bdcAccountNumber: ApiParser.asNullableString(json['BDCAccountNumber']),
      gender: ApiParser.asNullableString(json['gender']),
      registryNumber: ApiParser.asNullableString(json['regNo']),
      bankCode: ApiParser.asNullableString(json['bankCode']),
      firstName: ApiParser.asNullableString(json['fname']),
      lastName: ApiParser.asNullableString(json['lname']),
      bankName: ApiParser.asNullableString(json['bankName']),
      customerType: ApiParser.asNullableInt(json['customerType']),
      feeDebt: ApiParser.asNullableDouble(json['feeDebt']),
      feeEquity: ApiParser.asNullableDouble(json['feeEquity']),
      bdcAccountId: ApiParser.asNullableString(json['BDCAccountId']),
      homeAddress: ApiParser.asNullableString(json['homeAddress']),
      mcsdAccountId: ApiParser.asNullableString(json['mSXAccountId']),
      homePhone: ApiParser.asNullableString(json['homePhone']),
      mobilePhone: ApiParser.asNullableString(json['mobilePhone']),
      occupation: ApiParser.asNullableString(json['occupation']),
      feeCorpDebt: ApiParser.asNullableDouble(json['feeCorpDebt']),
      birthDate: ApiParser.asNullableString(json['birthDate']),
      createdDate: ApiParser.asNullableString(json['createdDate']),
      receivedDate: ApiParser.asNullableString(json['recievedDate']),
      casaAccounts: ApiParser.asObjectMapList(json['casaAcnt'])
          .map(
            (Map<String, Object?> item) =>
                CasaAccountDto.fromNullableJson(item),
          )
          .whereType<CasaAccountDto>()
          .toList(growable: false),
    );
  }

  /// Returns null for absent/empty nested MCSD payloads.
  static McsdReqDto? fromNullableJson(Map<String, Object?>? json) {
    if (json == null || json.isEmpty) {
      return null;
    }
    return McsdReqDto.fromJson(json);
  }

  /// Converts this DTO into the domain MCSD request.
  SecAcntMcsdRequest toDomain() {
    return SecAcntMcsdRequest(
      brokerId: brokerId,
      country: country,
      bankAccountNumber: bankAccountNumber,
      bdcAccountNumber: bdcAccountNumber,
      gender: gender,
      registryNumber: registryNumber,
      bankCode: bankCode,
      firstName: firstName,
      lastName: lastName,
      bankName: bankName,
      customerType: customerType,
      feeDebt: feeDebt,
      feeEquity: feeEquity,
      bdcAccountId: bdcAccountId,
      homeAddress: homeAddress,
      mcsdAccountId: mcsdAccountId,
      homePhone: homePhone,
      mobilePhone: mobilePhone,
      occupation: occupation,
      feeCorpDebt: feeCorpDebt,
      birthDate: birthDate,
      createdDate: createdDate,
      receivedDate: receivedDate,
      casaAccounts: casaAccounts
          .map((CasaAccountDto account) => account.toDomain())
          .toList(growable: false),
    );
  }
}

/// CASA account item nested in an MCSD request response.
class CasaAccountDto {
  /// CASA account code.
  final String? accountCode;

  /// Currency code.
  final String? currencyCode;

  /// Backend account type.
  final int? type;

  /// Creates a nested CASA account DTO.
  const CasaAccountDto({this.accountCode, this.currencyCode, this.type});

  /// Parses CASA account JSON.
  factory CasaAccountDto.fromJson(Map<String, Object?> json) {
    return CasaAccountDto(
      accountCode: ApiParser.asNullableString(json['casaAcntCode']),
      currencyCode: ApiParser.asNullableString(json['curCode']),
      type: ApiParser.asNullableInt(json['type']),
    );
  }

  /// Returns null for absent/empty CASA JSON objects.
  static CasaAccountDto? fromNullableJson(Map<String, Object?>? json) {
    if (json == null || json.isEmpty) {
      return null;
    }
    return CasaAccountDto.fromJson(json);
  }

  /// Converts this DTO into the domain CASA account model.
  SecAcntCasaAccount toDomain() {
    return SecAcntCasaAccount(
      accountCode: accountCode,
      currencyCode: currencyCode,
      type: type,
    );
  }
}
