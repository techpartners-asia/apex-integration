part of '../get_sec_acnt_list_res_dto.dart';

/// Detail object returned with the securities account list.
///
/// `hasAcnt` identifies whether an actual securities account exists and must
/// remain separate from contract/payment completion flags.
class GetSecuritiesAcntListDetailDto {
  /// Whether the user has an actual securities account.
  final bool hasAcnt;

  /// Whether the user has an IPS account.
  final bool hasIpsAcnt;

  /// Commission amount/percentage returned by the backend.
  final double? commission;

  /// Introductory text.
  final String? intro;

  /// IPS-specific intro text.
  final String? introIps;

  /// Additional information text.
  final String? info;

  /// User registration number echoed by backend.
  final String? registerCode;

  /// Broker code.
  final String? brokerCode;

  /// Verification type.
  final String? verfType;

  /// Settlement bank code.
  final String? bankCode;

  /// Settlement bank name.
  final String? bankName;

  /// Destination account code.
  final String? toAcntCode;

  /// Destination account holder name.
  final String? toAcntName;

  /// Destination account currency code.
  final String? toAcntCurCode;

  /// Payment or contract description.
  final String? description;

  /// Destination financial institution code.
  final String? toFiCode;

  /// Destination financial institution name.
  final String? toFiName;

  /// QR payload for payment/account opening.
  final String? qrCode;

  /// Verification status value.
  final String? verfStatus;

  /// Payment status value.
  final String? paymentStatus;

  /// Electronic signature status value.
  final String? esignStatus;

  /// Whether balance should be hidden in the UI.
  final bool hideBalance;

  /// Backend template type for contract/payment rendering.
  final String? templateType;

  /// Creates account-list detail metadata.
  const GetSecuritiesAcntListDetailDto({
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

  /// Parses account-list detail fields with false defaults for flags.
  factory GetSecuritiesAcntListDetailDto.fromJson(Map<String, Object?> json) {
    return GetSecuritiesAcntListDetailDto(
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
