part of '../mini_app_api_repository.dart';

class RemoteMiniAppSupportRepository implements MiniAppSupportRepository {
  static const Duration _companyInfoCacheTtl = Duration(minutes: 10);

  final MiniAppApiBackend api;
  final MiniAppSessionController session;
  final MiniAppLogger logger;
  final TimedMemoryCache<BranchInfoEntity> _companyInfoCache;

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
