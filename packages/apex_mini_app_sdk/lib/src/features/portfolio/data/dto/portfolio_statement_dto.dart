import 'package:mini_app_sdk/mini_app_sdk.dart';

class MgBkrCasaAcntStatementResDataDto {
  final String? txnDate;
  final String? jrNo;
  final String? jritemNo;
  final String? txnCode;
  final double credit;
  final double debit;
  final double? balance;
  final String description;
  final String? postDate;
  final int? isFee;
  final String? txnNo;

  const MgBkrCasaAcntStatementResDataDto({
    required this.description,
    required this.credit,
    required this.debit,
    this.txnDate,
    this.jrNo,
    this.jritemNo,
    this.txnCode,
    this.balance,
    this.postDate,
    this.isFee,
    this.txnNo,
  });

  bool get isCredit => credit > 0 && debit <= 0;

  double get amount => isCredit ? credit.abs() : debit.abs();

  factory MgBkrCasaAcntStatementResDataDto.fromJson(Map<String, Object?> json) {
    final String? txnNo = ApiParser.asNullableString(json['txnNo']);
    final String? jrNo = ApiParser.asNullableString(json['jrNo']);
    final String? jritemNo = ApiParser.asNullableString(json['jritemNo']);
    final String? txnCode = ApiParser.asNullableString(json['txnCode']);
    final String? txnDate = ApiParser.asNullableString(json['txnDate']);
    final String? postDate = ApiParser.asNullableString(json['postDate']);
    final double credit = ApiParser.asNullableDouble(json['credit']) ?? 0;
    final double debit = ApiParser.asNullableDouble(json['debit']) ?? 0;

    return MgBkrCasaAcntStatementResDataDto(
      txnDate: txnDate,
      jrNo: jrNo,
      jritemNo: jritemNo,
      txnCode: txnCode,
      credit: credit,
      debit: debit,
      balance: ApiParser.asNullableDouble(json['balance']),
      description:
          ApiParser.asNullableString(json['txnDesc']) ??
          txnCode ??
          txnNo ??
          jrNo ??
          'Transaction',
      postDate: postDate,
      isFee: ApiParser.asNullableInt(json['isFee']),
      txnNo: txnNo,
    );
  }

  // PortfolioStatementEntry toDomain() {
  //   final String? postedAtText = postDate ?? txnDate;
  //
  //   return PortfolioStatementEntry(
  //     description: description,
  //     amount: amount,
  //     isCredit: isCredit,
  //     postedAt: ApiParser.asNullableDateTime(postedAtText),
  //     postedAtText: postedAtText,
  //     balance: balance,
  //     typeLabel: txnCode,
  //     referenceNo: txnNo ?? jrNo,
  //   );
  // }
}

class CasaStatementResponseDto {
  final String? custName;
  final String? txnDate;
  final double? beginBalance;
  final double? endBalance;
  final String startDate;
  final String endDate;
  final int pageCount;
  final int totalPage;
  final int totalCount;
  final int responseCode;
  final String? responseDesc;
  final String? resultValue;
  final List<MgBkrCasaAcntStatementResDataDto> stmtList;

  const CasaStatementResponseDto({
    required this.startDate,
    required this.endDate,
    required this.pageCount,
    required this.totalPage,
    required this.totalCount,
    required this.responseCode,
    this.custName,
    this.txnDate,
    this.beginBalance,
    this.endBalance,
    this.responseDesc,
    this.resultValue,
    this.stmtList = const <MgBkrCasaAcntStatementResDataDto>[],
  });

  String get summary => _buildSummary(startDate: startDate, endDate: endDate);

  String get currency => 'MNT';

  factory CasaStatementResponseDto.fromJson(
    Map<String, Object?> json, {
    required String fallbackStartDate,
    required String fallbackEndDate,
  }) {
    ApiActionResultParser.ensureSuccess(
      json,
      fallbackErrorMessage: 'CASA statement req failed.',
      strictResponseCode: true,
    );

    final List<MgBkrCasaAcntStatementResDataDto> stmtList =
        ApiParser.asObjectMapList(
              json['MgBkrCasaAcntStatementResData'] ?? json['casafintxn'],
            )
            .map(MgBkrCasaAcntStatementResDataDto.fromJson)
            .toList(
              growable: false,
            );

    return CasaStatementResponseDto(
      custName: ApiParser.asNullableString(json['custName']),
      txnDate: ApiParser.asNullableString(json['txnDate']),
      beginBalance: ApiParser.asNullableDouble(json['beginBalance']),
      endBalance: ApiParser.asNullableDouble(json['endBalance']),
      startDate:
          ApiParser.asNullableString(json['startDate']) ?? fallbackStartDate,
      endDate: ApiParser.asNullableString(json['endDate']) ?? fallbackEndDate,
      pageCount: ApiParser.asNullableInt(json['pageCount']) ?? 0,
      totalPage: ApiParser.asNullableInt(json['totalPage']) ?? 0,
      totalCount:
          ApiParser.asNullableInt(json['totalCount']) ?? stmtList.length,
      responseCode: ApiParser.asNullableInt(json['responseCode']) ?? 0,
      responseDesc: ApiParser.asNullableString(json['responseDesc']),
      resultValue: ApiParser.asNullableString(json['resultValue']),
      stmtList: stmtList,
    );
  }

  PortfolioStatementsData toDomain() {
    return PortfolioStatementsData(
      summary: summary,
      currency: currency,
      startDate: startDate,
      endDate: endDate,
      beginBalance: beginBalance,
      endBalance: endBalance,
      totalCount: totalCount,
      pageCount: pageCount,
      totalPage: totalPage,
      custName: custName,
      txnDate: txnDate,
      resultValue: resultValue,
      stmtList: stmtList,
    );
  }

  String toSummary() => summary;
}

String _buildSummary({
  required String startDate,
  required String endDate,
}) {
  final String trimmedStart = startDate.trim();
  final String trimmedEnd = endDate.trim();
  if (trimmedStart.isEmpty && trimmedEnd.isEmpty) {
    return '';
  }
  if (trimmedStart.isEmpty) {
    return trimmedEnd;
  }
  if (trimmedEnd.isEmpty) {
    return trimmedStart;
  }
  return '$trimmedStart - $trimmedEnd';
}
