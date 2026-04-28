part of '../get_sec_acnt_list_res_dto.dart';

class GetSecAcntListDetailDto {
  final bool hasAcnt;
  final bool hasIpsAcnt;
  final double? commission;
  final String? intro;
  final String? introIps;
  final String? info;
  final String? registerCode;
  final String? brokerCode;
  final String? verfType;
  final String? bankCode;
  final String? bankName;
  final String? toAcntCode;
  final String? toAcntName;
  final String? toAcntCurCode;
  final String? description;
  final String? toFiCode;
  final String? toFiName;
  final String? qrCode;
  final String? verfStatus;
  final String? paymentStatus;
  final String? esignStatus;
  final bool hideBalance;
  final String? templateType;

  const GetSecAcntListDetailDto({
    required this.hasAcnt,
    required this.hasIpsAcnt,
    this.commission,
    this.intro,
    this.introIps,
    this.info,
    this.registerCode,
    this.brokerCode,
    this.verfType,
    this.bankCode,
    this.bankName,
    this.toAcntCode,
    this.toAcntName,
    this.toAcntCurCode,
    this.description,
    this.toFiCode,
    this.toFiName,
    this.qrCode,
    this.verfStatus,
    this.paymentStatus,
    this.esignStatus,
    this.hideBalance = false,
    this.templateType,
  });

  factory GetSecAcntListDetailDto.fromJson(Map<String, Object?> json) {
    return GetSecAcntListDetailDto(
      hasAcnt: ApiParser.asFlag(json['hasAcnt']),
      hasIpsAcnt: ApiParser.asFlag(json['hasIpsAcnt']),
      commission: ApiParser.asNullableDouble(json['commission']),
      intro: ApiParser.asNullableString(json['intro']),
      introIps: ApiParser.asNullableString(json['introIps']),
      info: ApiParser.asNullableString(json['info']),
      registerCode: ApiParser.asNullableString(json['registerCode']),
      brokerCode: ApiParser.asNullableString(json['brokerCode']),
      verfType: ApiParser.asNullableString(json['verfType']),
      bankCode: ApiParser.asNullableString(json['bankCode']),
      bankName: ApiParser.asNullableString(json['bankName']),
      toAcntCode: ApiParser.asNullableString(json['toAcntCode']),
      toAcntName: ApiParser.asNullableString(json['toAcntName']),
      toAcntCurCode: ApiParser.asNullableString(json['toAcntCurCode']),
      description: ApiParser.asNullableString(json['description']),
      toFiCode: ApiParser.asNullableString(json['toFiCode']),
      toFiName: ApiParser.asNullableString(json['toFiName']),
      qrCode: ApiParser.asNullableString(json['qrCode']),
      verfStatus: ApiParser.asNullableString(json['verfStatus']),
      paymentStatus: ApiParser.asNullableString(json['paymentStatus']),
      esignStatus: ApiParser.asNullableString(json['esignStatus']),
      hideBalance: ApiParser.asFlag(json['hideBalance']),
      templateType: ApiParser.asNullableString(json['templateType']),
    );
  }
}
