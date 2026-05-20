import 'package:apex_mini_app_sdk/apex_mini_app_sdk.dart';

/// Function used by the cached repository to load FI institution data.
typedef FiBomInstLoader =
    Future<List<FiBomInstDto>> Function(GetFiBomInstApiReq req);

/// Repository for FI/BOM institution lookup data.
abstract interface class FiBomInstRepository {
  /// Returns the FI institution list.
  Future<List<FiBomInstDto>> getFiBomInstList({bool forceRefresh = false});

  /// Returns the first/default FI institution.
  Future<FiBomInstDto> getDefaultFiBomInst({bool forceRefresh = false});
}

/// Cached implementation of FI/BOM institution lookup.
class CachedFiBomInstRepository implements FiBomInstRepository {
  static const Duration _fiBomInstCacheTtl = Duration(minutes: 10);

  /// Loader function that calls the backend.
  final FiBomInstLoader loadFiBomInst;

  /// FI institution code configured for the SDK.
  final String fiBomInst;

  /// Dictionary version sent to the backend.
  final int dicVersion;

  /// Cache used because FI institution data changes infrequently.
  final TimedMemoryCache<List<FiBomInstDto>> _fiBomInstCache;

  /// Creates a cached FI institution repository.
  CachedFiBomInstRepository({
    required this.loadFiBomInst,
    required String fiBomInst,
    this.dicVersion = 0,
    TimedMemoryCache<List<FiBomInstDto>>? fiBomInstCache,
  }) : fiBomInst = fiBomInst.trim(),
       _fiBomInstCache =
           fiBomInstCache ??
           TimedMemoryCache<List<FiBomInstDto>>(ttl: _fiBomInstCacheTtl) {
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
