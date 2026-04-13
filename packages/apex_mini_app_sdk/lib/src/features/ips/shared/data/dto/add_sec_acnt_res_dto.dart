import '../../../../../core/api/api_action_result_parser.dart';
import '../../../../../core/api/api_parser.dart';
import '../../domain/models/ips_models.dart';

class AddSecuritiesAcntResDto {
  final String? message;
  final int? refNo;
  final String? srcFiCode;
  final McsdReqDto? mcsdReq;

  const AddSecuritiesAcntResDto({
    this.message,
    this.refNo,
    this.srcFiCode,
    this.mcsdReq,
  });

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

  SecAcntRequestResult toDomain() {
    return SecAcntRequestResult(
      message: message,
      refNo: refNo,
      srcFiCode: srcFiCode,
      mcsdRequest: mcsdReq?.toDomain(),
    );
  }
}

class McsdReqDto {
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
  final List<CasaAccountDto> casaAccounts;

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

  static McsdReqDto? fromNullableJson(Map<String, Object?>? json) {
    if (json == null || json.isEmpty) {
      return null;
    }
    return McsdReqDto.fromJson(json);
  }

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

class CasaAccountDto {
  final String? accountCode;
  final String? currencyCode;
  final int? type;

  const CasaAccountDto({this.accountCode, this.currencyCode, this.type});

  factory CasaAccountDto.fromJson(Map<String, Object?> json) {
    return CasaAccountDto(
      accountCode: ApiParser.asNullableString(json['casaAcntCode']),
      currencyCode: ApiParser.asNullableString(json['curCode']),
      type: ApiParser.asNullableInt(json['type']),
    );
  }

  static CasaAccountDto? fromNullableJson(Map<String, Object?>? json) {
    if (json == null || json.isEmpty) {
      return null;
    }
    return CasaAccountDto.fromJson(json);
  }

  SecAcntCasaAccount toDomain() {
    return SecAcntCasaAccount(
      accountCode: accountCode,
      currencyCode: currencyCode,
      type: type,
    );
  }
}
