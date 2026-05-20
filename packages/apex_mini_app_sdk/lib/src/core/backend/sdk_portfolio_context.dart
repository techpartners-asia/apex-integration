/// Account context used by portfolio, statement, and holding APIs.
class SdkPortfolioContext {
  /// Broker identifier.
  final String? brokerId;

  /// Source financial institution code.
  final String? srcFiCode;

  /// IPS account code.
  final String? ipsAcntCode;

  /// CASA account id used for statements.
  final int? casaAcntId;

  /// Statement start date.
  final String? stmtStartDate;

  /// Statement end date.
  final String? stmtEndDate;

  /// Creates optional account context for portfolio and statement requests.
  const SdkPortfolioContext({
    this.brokerId,
    this.srcFiCode,
    this.ipsAcntCode,
    this.casaAcntId,
    this.stmtStartDate,
    this.stmtEndDate,
  });

  /// Sentinel that lets [copyWith] distinguish omitted values from `null`.
  static const Object _sentinel = Object();

  /// Normalized broker id, or null when blank.
  String? get normalizedBrokerId => _normalizeText(brokerId);

  /// Normalized source FI code, or null when blank.
  String? get normalizedSrcFiCode => _normalizeText(srcFiCode);

  /// Normalized IPS account code, or null when blank.
  String? get normalizedIpsAcntCode => _normalizeText(ipsAcntCode);

  /// Positive CASA account id, or null when missing/invalid.
  int? get normalizedCasaAcntId =>
      casaAcntId != null && casaAcntId! > 0 ? casaAcntId : null;

  /// Normalized statement start date, or null when blank.
  String? get normalizedStmtStartDate => _normalizeText(stmtStartDate);

  /// Normalized statement end date, or null when blank.
  String? get normalizedStmtEndDate => _normalizeText(stmtEndDate);

  // bool get hasStockYieldDetailContext =>
  //     normalizedBrokerId != null && normalizedSecurityCode != null;

  /// Whether this context can load statement data.
  bool get hasStatementContext =>
      normalizedCasaAcntId != null &&
      normalizedStmtStartDate != null &&
      normalizedStmtEndDate != null;

  /// Whether no usable context fields are present.
  bool get isEmpty =>
      normalizedBrokerId == null &&
      normalizedSrcFiCode == null &&
      normalizedIpsAcntCode == null &&
      normalizedCasaAcntId == null &&
      normalizedStmtStartDate == null &&
      normalizedStmtEndDate == null;

  /// Resolves the source FI code using this context before [fallback].
  String resolveSrcFiCode(String fallback) {
    final String? normalizedFallback = _normalizeText(fallback);
    return normalizedSrcFiCode ?? normalizedFallback ?? '';
  }

  /// Returns a copy with selected fields replaced.
  SdkPortfolioContext copyWith({
    Object? brokerId = _sentinel,
    Object? srcFiCode = _sentinel,
    Object? ipsAcntCode = _sentinel,
    Object? casaAcntId = _sentinel,
    Object? stmtStartDate = _sentinel,
    Object? stmtEndDate = _sentinel,
  }) {
    return SdkPortfolioContext(
      brokerId: brokerId == _sentinel ? this.brokerId : brokerId as String?,
      srcFiCode: srcFiCode == _sentinel ? this.srcFiCode : srcFiCode as String?,
      ipsAcntCode: ipsAcntCode == _sentinel
          ? this.ipsAcntCode
          : ipsAcntCode as String?,
      casaAcntId: casaAcntId == _sentinel
          ? this.casaAcntId
          : casaAcntId as int?,
      stmtStartDate: stmtStartDate == _sentinel
          ? this.stmtStartDate
          : stmtStartDate as String?,
      stmtEndDate: stmtEndDate == _sentinel
          ? this.stmtEndDate
          : stmtEndDate as String?,
    );
  }

  /// Merges this context over [other], preferring non-empty values from this.
  SdkPortfolioContext merge(SdkPortfolioContext other) {
    return SdkPortfolioContext(
      brokerId: normalizedBrokerId ?? other.normalizedBrokerId,
      srcFiCode: normalizedSrcFiCode ?? other.normalizedSrcFiCode,
      ipsAcntCode: normalizedIpsAcntCode ?? other.normalizedIpsAcntCode,
      casaAcntId: normalizedCasaAcntId ?? other.normalizedCasaAcntId,
      stmtStartDate: normalizedStmtStartDate ?? other.normalizedStmtStartDate,
      stmtEndDate: normalizedStmtEndDate ?? other.normalizedStmtEndDate,
    );
  }

  /// Returns a context with all text fields trimmed and invalid values removed.
  SdkPortfolioContext normalized({String? fallbackSrcFiCode}) {
    final String? normalizedFallbackSrcFiCode = _normalizeText(
      fallbackSrcFiCode,
    );

    return SdkPortfolioContext(
      brokerId: normalizedBrokerId,
      srcFiCode: normalizedSrcFiCode ?? normalizedFallbackSrcFiCode,
      ipsAcntCode: normalizedIpsAcntCode,
      casaAcntId: normalizedCasaAcntId,
      stmtStartDate: normalizedStmtStartDate,
      stmtEndDate: normalizedStmtEndDate,
    );
  }

  static String? _normalizeText(String? value) {
    final String trimmed = value?.trim() ?? '';
    return trimmed.isEmpty ? null : trimmed;
  }
}
