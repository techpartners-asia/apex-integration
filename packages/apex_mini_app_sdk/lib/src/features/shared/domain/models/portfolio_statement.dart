class PortfolioStatementEntry {
  final String id;
  final String description;
  final DateTime? postedAt;
  final String? postedAtText;
  final double amount;
  final double? balance;
  final bool isCredit;
  final String? typeLabel;
  final String? referenceNo;

  const PortfolioStatementEntry({
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
}

class PortfolioStatementsData {
  final String summary;
  final String currency;
  final String startDate;
  final String endDate;
  final double? beginBalance;
  final double? endBalance;
  final int totalCount;
  final List<PortfolioStatementEntry> entries;

  const PortfolioStatementsData({
    required this.summary,
    required this.currency,
    required this.startDate,
    required this.endDate,
    this.beginBalance,
    this.endBalance,
    this.totalCount = 0,
    this.entries = const <PortfolioStatementEntry>[],
  });

  bool get hasEntries => entries.isNotEmpty;
}
