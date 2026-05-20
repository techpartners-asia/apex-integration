import 'package:apex_mini_app_sdk/apex_mini_app_sdk.dart';

/// Pack service implementation that loads and caches IPS pack options.
class ApiPackService implements PackService {
  /// Time window for reusing pack data inside one SDK runtime.
  static const Duration _packsCacheTtl = Duration(minutes: 10);

  /// Backend API facade.
  final IpsBackendApi api;

  /// Session controller used to ensure login before pack requests.
  final MiniAppSessionController session;

  /// In-memory cache keyed by source FI code.
  final TimedMemoryCacheMap<String, List<IpsPack>> _packsCache;

  /// Creates an API-backed pack service.
  ApiPackService({
    required this.api,
    required this.session,
    TimedMemoryCacheMap<String, List<IpsPack>>? packsCache,
  }) : _packsCache =
           packsCache ??
           TimedMemoryCacheMap<String, List<IpsPack>>(ttl: _packsCacheTtl);

  /// Returns available packs, optionally bypassing the short-lived cache.
  @override
  Future<List<IpsPack>> getPacks({
    String? srcFiCode,
    bool forceRefresh = false,
  }) async {
    final String cacheKey = (srcFiCode?.trim().isNotEmpty ?? false)
        ? srcFiCode!.trim()
        : '_default_';
    return _packsCache.getOrLoad(
      cacheKey,
      () async {
        await session.ensureLoginSession();
        final List<PackDto> packs = await api.getPacks(srcFiCode: srcFiCode);
        return List<IpsPack>.unmodifiable(
          packs.map((PackDto dto) => dto.toDomain()),
        );
      },
      forceRefresh: forceRefresh,
    );
  }
}
