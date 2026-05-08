import 'package:mini_app_sdk/mini_app_sdk.dart';

part 'sec_acnt_list/get_sec_acnt_list_account_dto.dart';

part 'sec_acnt_list/get_sec_acnt_list_detail_dto.dart';

part 'sec_acnt_list/get_sec_acnt_settlement_account_dto.dart';

part 'sec_acnt_list/sec_acnt_account_support_dto.dart';

class GetSecuritiesAcntListResDto {
  final GetSecuritiesAcntListDetailDto detail;
  final List<GetSecAcntListAccountDto> acnts;
  final List<GetSecAcntSettlementAccountDto> stlAcnts;
  final int responseCode;
  final String? responseDesc;

  const GetSecuritiesAcntListResDto({
    required this.detail,
    required this.acnts,
    required this.stlAcnts,
    required this.responseCode,
    this.responseDesc,
  });

  factory GetSecuritiesAcntListResDto.fromJson(Map<String, Object?> json) {
    final int responseCode = ApiParser.asNullableInt(json['responseCode']) ?? 1;
    final String? responseDesc = ApiParser.asNullableString(
      json['responseDesc'],
    );

    if (responseCode != 0) {
      throw ApiBusinessException(
        responseCode: responseCode,
        message: responseDesc ?? 'Failed to load securities account list.',
      );
    }

    return GetSecuritiesAcntListResDto(
      detail: GetSecuritiesAcntListDetailDto.fromJson(
        ApiParser.asObjectMap(json['detail']),
      ),
      acnts: ApiParser.asObjectMapList(
        json['acnts'],
      ).map(GetSecAcntListAccountDto.fromJson).toList(growable: false),
      stlAcnts: ApiParser.asObjectMapList(
        json['stlAcnts'],
      ).map(GetSecAcntSettlementAccountDto.fromJson).toList(growable: false),
      responseCode: responseCode,
      responseDesc: responseDesc,
    );
  }

  GetSecuritiesAcntListResDto copyWith({
    GetSecuritiesAcntListDetailDto? detail,
    List<GetSecAcntListAccountDto>? acnts,
    List<GetSecAcntSettlementAccountDto>? stlAcnts,
    int? responseCode,
    String? responseDesc,
  }) {
    return GetSecuritiesAcntListResDto(
      detail: detail ?? this.detail,
      acnts: acnts ?? this.acnts,
      stlAcnts: stlAcnts ?? this.stlAcnts,
      responseCode: responseCode ?? this.responseCode,
      responseDesc: responseDesc ?? this.responseDesc,
    );
  }

  GetSecAcntListAccountDto? get securitiesAccount => accountByFlag(3);

  GetSecAcntListAccountDto? get ipsMasterAccount => accountByFlag(11);

  GetSecAcntListAccountDto? get ipsCasaAccount => accountByFlag(12);

  GetSecAcntListAccountDto? get primaryAccount =>
      securitiesAccount ?? ipsCasaAccount ?? ipsMasterAccount ?? firstAccount;

  GetSecAcntListAccountDto? get firstAccount =>
      acnts.isEmpty ? null : acnts.first;

  GetSecAcntListAccountDto? accountByFlag(int flag) {
    for (final GetSecAcntListAccountDto account in acnts) {
      if (account.flag == flag) {
        return account;
      }
    }

    return null;
  }
}
