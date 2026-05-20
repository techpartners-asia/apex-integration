part of '../mini_app_api_repository.dart';

/// Remote implementation of support/company-info operations.
class RemoteMiniAppSupportRepository implements MiniAppSupportRepository {
  static const Duration _companyInfoCacheTtl = Duration(minutes: 10);

  /// Low-level API facade for support endpoints.
  final MiniAppApiBackend api;

  /// Session controller that supplies the admin auth token.
  final MiniAppSessionController session;

  /// Logger used for endpoint failures.
  final MiniAppLogger logger;

  /// Cache for the company info payload, which changes infrequently.
  final TimedMemoryCache<BranchInfoEntity> _companyInfoCache;

  /// Creates the remote support repository.
  RemoteMiniAppSupportRepository({
    required this.api,
    required this.session,
    this.logger = const SilentMiniAppLogger(),
    TimedMemoryCache<BranchInfoEntity>? companyInfoCache,
  }) : _companyInfoCache =
           companyInfoCache ??
           TimedMemoryCache<BranchInfoEntity>(ttl: _companyInfoCacheTtl);

  @override
  Future<BranchInfoEntity> getCompanyInfo({bool forceRefresh = false}) async {
    try {
      return _companyInfoCache.getOrLoad(
        () async {
          await _ensureAdminAuthToken(session);
          final response = await api.getCompanyInfo();
          return response.entity;
        },
        forceRefresh: forceRefresh,
      );
    } catch (error, stackTrace) {
      logger.onError(
        'get_company_info_failed',
        error: error,
        stackTrace: stackTrace,
      );
      rethrow;
    }
  }
}
