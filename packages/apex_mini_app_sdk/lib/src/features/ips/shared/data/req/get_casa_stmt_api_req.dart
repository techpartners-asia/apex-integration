import '../../../../../utils/date_time_formatter.dart';

class GetCasaStmtApiReq {
  final int acntId;
  final String startDate;
  final String endDate;
  final int currentPage;
  final int pageCount;
  final String? postDate;
  final String? mode;
  final int? isLastX;
  final int? txnNo;
  final String? scrType;
  final String? exportType;
  final bool pack;

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

  Map<String, Object?> toJson() {
    return <String, Object?>{
      'acntId': acntId,
      'startDate': DateTimeFormatter.normalizeDateOnlyOrDateTime(startDate),
      'endDate': DateTimeFormatter.normalizeDateOnlyOrDateTime(endDate),
      'currentPage': currentPage,
      'pageCount': pageCount,
      'pack': pack,
      if (postDate case final String value when value.trim().isNotEmpty) 'postDate': value.trim(),
      if (mode case final String value when value.trim().isNotEmpty) 'mode': value.trim(),
      if (isLastX case final int value) 'isLastX': value,
      if (txnNo case final int value) 'txnNo': value,
      if (scrType case final String value when value.trim().isNotEmpty) 'scrType': value.trim(),
      if (exportType case final String value when value.trim().isNotEmpty) 'exportType': value.trim(),
    };
  }
}
