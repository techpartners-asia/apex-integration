import 'package:mini_app_sdk/mini_app_sdk.dart';

class ApiPackService implements PackService {
  static const Duration _packsCacheTtl = Duration(minutes: 10);

  final IpsBackendApi api;
  final MiniAppSessionController session;
  final TimedMemoryCacheMap<String, List<IpsPack>> _packsCache;

  ApiPackService({
    required this.api,
    required this.session,
    TimedMemoryCacheMap<String, List<IpsPack>>? packsCache,
  }) : _packsCache =
           packsCache ??
           TimedMemoryCacheMap<String, List<IpsPack>>(ttl: _packsCacheTtl);

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
