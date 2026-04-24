import 'package:mini_app_sdk/mini_app_sdk.dart';

class CasaStatementEntryDto {
  final String id;
  final String description;
  final DateTime? postedAt;
  final String? postedAtText;
  final double amount;
  final double? balance;
  final bool isCredit;
  final String? typeLabel;
  final String? referenceNo;

  const CasaStatementEntryDto({
    required this.id,
    required this.description,
    required this.amount,
    required this.isCredit,
    this.postedAt,
    this.postedAtText,
    this.balance,
    this.typeLabel,
    this.referenceNo,
  });

  factory CasaStatementEntryDto.fromJson(Map<String, Object?> json) {
    final double creditAmount = ApiParser.asNullableDouble(json['credit']) ?? 0;
    final double debitAmount = ApiParser.asNullableDouble(json['debit']) ?? 0;
    final bool isCredit = creditAmount > 0 && debitAmount <= 0;
    final double rawAmount = isCredit ? creditAmount.abs() : debitAmount.abs();
    final String? postedAtText = ApiParser.asNullableString(json['postDate']);
    final String? referenceNo = ApiParser.asNullableString(json['txnNo']);
    final String description = ApiParser.asNullableString(json['txnDesc']) ?? referenceNo ?? 'Transaction';

    return CasaStatementEntryDto(
      id: referenceNo ?? '${postedAtText ?? 'stmt'}_${description}_$rawAmount',
      description: description,
      amount: rawAmount,
      isCredit: isCredit,
      postedAtText: postedAtText,
      postedAt: ApiParser.asNullableDateTime(postedAtText),
      balance: ApiParser.asNullableDouble(json['balance']),
      typeLabel: ApiParser.asNullableString(json['txnCode']),
      referenceNo: referenceNo,
    );
  }

  PortfolioStatementEntry toDomain() {
    return PortfolioStatementEntry(
      id: id,
      description: description,
      amount: amount,
      isCredit: isCredit,
      postedAt: postedAt,
      postedAtText: postedAtText,
      balance: balance,
      typeLabel: typeLabel,
      referenceNo: referenceNo,
    );
  }
}

class CasaStatementResponseDto {
  final String summary;
  final String currency;
  final String startDate;
  final String endDate;
  final double? beginBalance;
  final double? endBalance;
  final int totalCount;
  final List<CasaStatementEntryDto> entries;

  const CasaStatementResponseDto({
    required this.summary,
    required this.currency,
    required this.startDate,
    required this.endDate,
    this.beginBalance,
    this.endBalance,
    this.totalCount = 0,
    this.entries = const <CasaStatementEntryDto>[],
  });

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

    final String startDate = ApiParser.asNullableString(json['startDate']) ?? fallbackStartDate;
    final String endDate = ApiParser.asNullableString(json['endDate']) ?? fallbackEndDate;
    final double? beginBalance = ApiParser.asNullableDouble(json['beginBalance']);
    final double? endBalance = ApiParser.asNullableDouble(json['endBalance']);
    final int totalCount = ApiParser.asNullableInt(json['totalCount']) ?? 0;

    final List<CasaStatementEntryDto> entries = ApiParser.asObjectMapList(
      json['MgBkrCasaAcntStatementResData'],
    ).map(CasaStatementEntryDto.fromJson).toList(growable: false);

    return CasaStatementResponseDto(
      summary: _buildSummary(startDate: startDate, endDate: endDate),
      currency: 'MNT',
      startDate: startDate,
      endDate: endDate,
      beginBalance: beginBalance,
      endBalance: endBalance,
      totalCount: totalCount,
      entries: entries,
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
      entries: entries
          .map((CasaStatementEntryDto entry) => entry.toDomain())
          .toList(growable: false),
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
