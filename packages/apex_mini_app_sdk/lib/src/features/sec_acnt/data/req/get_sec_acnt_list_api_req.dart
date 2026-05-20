/// Request body for fetching securities accounts for the current user.
///
/// The response's `hasAcnt`/account list is the source of truth for actions
/// that require an actual opened securities account.
class GetSecuritiesAcntListApiReq {
  /// User registration number.
  final String registerCode;

  /// Optional IPO code filter.
  final String? ipoCode;

  /// Optional mobile number.
  final String? mobile;

  /// Optional account-code filter list.
  final List<String> acnts;

  /// Source financial institution code.
  final String srcFiCode;

  /// Creates a securities account list request.
  const GetSecuritiesAcntListApiReq({
    required this.registerCode,
    this.ipoCode,
    this.mobile,
    this.acnts = const <String>[],
    required this.srcFiCode,
  });

  /// Converts this request to backend JSON, omitting blank optional strings.
  Map<String, Object?> toJson() {
    return <String, Object?>{
      'registerCode': registerCode,
      if (ipoCode case final String value when value.trim().isNotEmpty)
        'ipoCode': value.trim(),
      if (mobile case final String value when value.trim().isNotEmpty)
        'mobile': value.trim(),
      'acnts': acnts,
      'srcFiCode': srcFiCode,
    };
  }
}
