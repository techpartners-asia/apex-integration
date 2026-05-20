import 'package:apex_mini_app_sdk/apex_mini_app_sdk.dart';

/// DTO for one CASA account statement transaction row.
class MgBkrCasaAcntStatementResDataDto {
  /// Transaction date text from backend.
  final String? txnDate;

  /// Journal/reference number.
  final String? jrNo;

  /// Journal item number.
  final String? jritemNo;

  /// Transaction code.
  final String? txnCode;

  /// Credit amount.
  final double credit;

  /// Debit amount.
  final double debit;

  /// Balance after the transaction.
  final double? balance;

  /// User-facing transaction description.
  final String description;

  /// Posted date text from backend.
  final String? postDate;

  /// Backend fee marker.
  final int? isFee;

  /// Transaction number.
  final String? txnNo;

  /// Creates a CASA account statement row DTO.
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

  /// Whether this row should be shown as incoming money.
  bool get isCredit => credit > 0 && debit <= 0;

  /// Absolute amount shown in statement lists.
  double get amount => isCredit ? credit.abs() : debit.abs();

  /// Parses a statement row while tolerating alternate backend key shapes.
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

/// DTO for a paginated CASA account statement response.
class CasaStatementResponseDto {
  /// Customer name returned by the statement endpoint.
  final String? custName;

  /// Statement transaction date text.
  final String? txnDate;

  /// Beginning balance for the requested period.
  final double? beginBalance;

  /// Ending balance for the requested period.
  final double? endBalance;

  /// Requested or resolved start date.
  final String startDate;

  /// Requested or resolved end date.
  final String endDate;

  /// Current page count from backend.
  final int pageCount;

  /// Total pages from backend.
  final int totalPage;

  /// Total statement row count.
  final int totalCount;

  /// Backend response code.
  final int responseCode;

  /// Backend response description.
  final String? responseDesc;

  /// Raw backend result value.
  final String? resultValue;

  /// Statement rows.
  final List<MgBkrCasaAcntStatementResDataDto> stmtList;

  /// Creates a CASA statement response DTO.
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

  /// Date-range summary for the current statement query.
  String get summary => _buildSummary(startDate: startDate, endDate: endDate);

  /// Statement currency; current backend response is always MNT.
  String get currency => 'MNT';

  /// Parses a statement response and falls back to requested date bounds.
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

  /// Converts statement data into the domain object used by the UI.
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

  /// Returns the formatted statement summary.
  String toSummary() => summary;
}

/// Formats the requested statement date range without dangling separators.
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
