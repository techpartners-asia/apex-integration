import '../../../../../core/exception/api_exception.dart';
import '../../../../../utils/timed_memory_cache.dart';
import '../dto/fi_bom_inst_dto.dart';
import '../req/get_fi_bom_inst_api_req.dart';

typedef FiBomInstLoader = Future<List<FiBomInstDto>> Function(GetFiBomInstApiReq req);

class FiBomInstRepository {
  const FiBomInstRepository();

  Future<List<FiBomInstDto>> getFiBomInstList({bool forceRefresh = false}) {
    throw UnimplementedError();
  }

  Future<FiBomInstDto> getDefaultFiBomInst({bool forceRefresh = false}) {
    throw UnimplementedError();
  }
}

class CachedFiBomInstRepository implements FiBomInstRepository {
  static const Duration _fiBomInstCacheTtl = Duration(minutes: 10);

  final FiBomInstLoader loadFiBomInst;
  final String fiBomInst;
  final int dicVersion;
  final TimedMemoryCache<List<FiBomInstDto>> _fiBomInstCache;

  CachedFiBomInstRepository({
    required this.loadFiBomInst,
    required String fiBomInst,
    this.dicVersion = 0,
    TimedMemoryCache<List<FiBomInstDto>>? fiBomInstCache,
  }) : fiBomInst = fiBomInst.trim(),
       _fiBomInstCache = fiBomInstCache ?? TimedMemoryCache<List<FiBomInstDto>>(ttl: _fiBomInstCacheTtl) {
    if (this.fiBomInst.isEmpty) {
      throw const ApiIntegrationException('A non-empty fiBomInst is required.');
    }
  }

  @override
  Future<List<FiBomInstDto>> getFiBomInstList({
    bool forceRefresh = false,
  }) async {
    return _fiBomInstCache.getOrLoad(
      () async => List<FiBomInstDto>.unmodifiable(
        await loadFiBomInst(
          GetFiBomInstApiReq(fiBomInst: fiBomInst, dicVersion: dicVersion),
        ),
      ),
      forceRefresh: forceRefresh,
    );
  }

  @override
  Future<FiBomInstDto> getDefaultFiBomInst({bool forceRefresh = false}) async {
    final List<FiBomInstDto> fiBomInsts = await getFiBomInstList(
      forceRefresh: forceRefresh,
    );
    if (fiBomInsts.isEmpty) {
      throw const ApiParsingException(
        'FI institution payload requires at least one responseData item.',
      );
    }
    return fiBomInsts.first;
  }
}
