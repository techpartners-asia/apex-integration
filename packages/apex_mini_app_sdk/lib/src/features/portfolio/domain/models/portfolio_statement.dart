// class PortfolioStatementEntry {
//   final String id;
//   final String description;
//   final DateTime? postedAt;
//   final String? postedAtText;
//   final double amount;
//   final double? balance;
//   final bool isCredit;
//   final String? typeLabel;
//   final String? referenceNo;
//
//   const PortfolioStatementEntry({
//     required this.id,
//     required this.description,
//     required this.amount,
//     required this.isCredit,
//     this.postedAt,
//     this.postedAtText,
//     this.balance,
//     this.typeLabel,
//     this.referenceNo,
//   });
// }

import 'package:apex_mini_app_sdk/apex_mini_app_sdk.dart';

/// Statement response normalized for the portfolio statement screen.
class PortfolioStatementsData {
  /// Human-readable summary generated from the selected period.
  final String summary;

  /// Statement currency code.
  final String currency;

  /// Start date of the queried period.
  final String startDate;

  /// End date of the queried period.
  final String endDate;

  /// Opening balance.
  final double? beginBalance;

  /// Closing balance.
  final double? endBalance;

  /// Total row count reported by backend.
  final int totalCount;

  /// Customer name if included in the response.
  final String? custName;

  /// Statement transaction date.
  final String? txnDate;

  /// Current page count.
  final int pageCount;

  /// Total page count.
  final int totalPage;

  /// Backend result value/message.
  final String? resultValue;

  /// Statement rows.
  final List<MgBkrCasaAcntStatementResDataDto> stmtList;

  /// Creates normalized portfolio statement data.
  const PortfolioStatementsData({
    required this.summary,
    required this.currency,
    required this.startDate,
    required this.endDate,
    this.beginBalance,
    this.endBalance,
    this.totalCount = 0,
    required this.pageCount,
    required this.totalPage,
    this.custName,
    this.txnDate,
    this.resultValue,
    this.stmtList = const <MgBkrCasaAcntStatementResDataDto>[],
  });

  /// Whether the statement response contains at least one row.
  bool get hasStmtList => stmtList.isNotEmpty;
}
