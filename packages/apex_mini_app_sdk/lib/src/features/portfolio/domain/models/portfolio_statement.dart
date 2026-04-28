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

import 'package:mini_app_sdk/mini_app_sdk.dart';

class PortfolioStatementsData {
  final String summary;
  final String currency;
  final String startDate;
  final String endDate;
  final double? beginBalance;
  final double? endBalance;
  final int totalCount;
  final String? custName;
  final String? txnDate;
  final int pageCount;
  final int totalPage;
  final String? resultValue;
  final List<MgBkrCasaAcntStatementResDataDto> stmtList;

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

  bool get hasStmtList => stmtList.isNotEmpty;
}
