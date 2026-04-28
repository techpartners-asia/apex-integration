class SdkPortfolioContext {
  final String? brokerId;
  final String? srcFiCode;
  final String? securityCode;
  final int? casaAcntId;
  final String? stmtStartDate;
  final String? stmtEndDate;

  const SdkPortfolioContext({
    this.brokerId,
    this.srcFiCode,
    this.securityCode,
    this.casaAcntId,
    this.stmtStartDate,
    this.stmtEndDate,
  });

  static const Object _sentinel = Object();

  String? get normalizedBrokerId => _normalizeText(brokerId);

  String? get normalizedSrcFiCode => _normalizeText(srcFiCode);

  String? get normalizedSecurityCode => _normalizeText(securityCode);

  int? get normalizedCasaAcntId =>
      casaAcntId != null && casaAcntId! > 0 ? casaAcntId : null;

  String? get normalizedStmtStartDate => _normalizeText(stmtStartDate);

  String? get normalizedStmtEndDate => _normalizeText(stmtEndDate);

  bool get hasStockYieldDetailContext =>
      normalizedBrokerId != null && normalizedSecurityCode != null;

  bool get hasStatementContext =>
      normalizedCasaAcntId != null &&
      normalizedStmtStartDate != null &&
      normalizedStmtEndDate != null;

  bool get isEmpty =>
      normalizedBrokerId == null &&
      normalizedSrcFiCode == null &&
      normalizedSecurityCode == null &&
      normalizedCasaAcntId == null &&
      normalizedStmtStartDate == null &&
      normalizedStmtEndDate == null;

  String resolveSrcFiCode(String fallback) {
    final String? normalizedFallback = _normalizeText(fallback);
    return normalizedSrcFiCode ?? normalizedFallback ?? '';
  }

  SdkPortfolioContext copyWith({
    Object? brokerId = _sentinel,
    Object? srcFiCode = _sentinel,
    Object? securityCode = _sentinel,
    Object? casaAcntId = _sentinel,
    Object? stmtStartDate = _sentinel,
    Object? stmtEndDate = _sentinel,
  }) {
    return SdkPortfolioContext(
      brokerId: brokerId == _sentinel ? this.brokerId : brokerId as String?,
      srcFiCode: srcFiCode == _sentinel ? this.srcFiCode : srcFiCode as String?,
      securityCode: securityCode == _sentinel
          ? this.securityCode
          : securityCode as String?,
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

  SdkPortfolioContext merge(SdkPortfolioContext other) {
    return SdkPortfolioContext(
      brokerId: normalizedBrokerId ?? other.normalizedBrokerId,
      srcFiCode: normalizedSrcFiCode ?? other.normalizedSrcFiCode,
      securityCode: normalizedSecurityCode ?? other.normalizedSecurityCode,
      casaAcntId: normalizedCasaAcntId ?? other.normalizedCasaAcntId,
      stmtStartDate: normalizedStmtStartDate ?? other.normalizedStmtStartDate,
      stmtEndDate: normalizedStmtEndDate ?? other.normalizedStmtEndDate,
    );
  }

  SdkPortfolioContext normalized({String? fallbackSrcFiCode}) {
    final String? normalizedFallbackSrcFiCode = _normalizeText(
      fallbackSrcFiCode,
    );

    return SdkPortfolioContext(
      brokerId: normalizedBrokerId,
      srcFiCode: normalizedSrcFiCode ?? normalizedFallbackSrcFiCode,
      securityCode: normalizedSecurityCode,
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
