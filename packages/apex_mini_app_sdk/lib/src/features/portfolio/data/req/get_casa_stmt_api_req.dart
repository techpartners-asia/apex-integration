import 'package:apex_mini_app_sdk/apex_mini_app_sdk.dart';

/// Request for CASA/account statement history.
class GetCasaStmtApiReq {
  /// Account identifier to query.
  final int acntId;

  /// Statement start date.
  final String startDate;

  /// Statement end date.
  final String endDate;

  /// Zero-based current page.
  final int currentPage;

  /// Number of rows per page.
  final int pageCount;

  /// Optional posting date filter.
  final String? postDate;

  /// Optional backend mode.
  final String? mode;

  /// Optional "last X" filter.
  final int? isLastX;

  /// Optional transaction number filter.
  final int? txnNo;

  /// Optional screen/type filter.
  final String? scrType;

  /// Optional export type requested by backend.
  final String? exportType;

  /// Whether to query pack statement data.
  final bool pack;

  /// Creates a CASA statement request.
  const GetCasaStmtApiReq({
    required this.acntId,
    required this.startDate,
    required this.endDate,
    required this.pack,
    this.currentPage = 0,
    this.pageCount = 20,
    this.postDate,
    this.mode,
    this.isLastX,
    this.txnNo,
    this.scrType,
    this.exportType,
  });

  /// Converts statement filters to backend JSON and omits blank optionals.
  Map<String, Object?> toJson() {
    return <String, Object?>{
      'acntId': acntId,
      'startDate': DateTimeFormatter.normalizeDateOnlyOrDateTime(startDate),
      'endDate': DateTimeFormatter.normalizeDateOnlyOrDateTime(endDate),
      'currentPage': currentPage,
      'pageCount': pageCount,
      'pack': pack,
      if (postDate case final String value when value.trim().isNotEmpty)
        'postDate': value.trim(),
      if (mode case final String value when value.trim().isNotEmpty)
        'mode': value.trim(),
      if (isLastX case final int value) 'isLastX': value,
      if (txnNo case final int value) 'txnNo': value,
      if (scrType case final String value when value.trim().isNotEmpty)
        'scrType': value.trim(),
      if (exportType case final String value when value.trim().isNotEmpty)
        'exportType': value.trim(),
    };
  }
}
