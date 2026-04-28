part of '../mini_app_api_repository.dart';

class RemoteMiniAppFeedbackRepository implements MiniAppFeedbackRepository {
  static const Duration _feedbackListCacheTtl = Duration(minutes: 2);

  final MiniAppApiBackend api;
  final MiniAppSessionController session;
  final MiniAppLogger logger;
  final TimedMemoryCacheMap<String, FeedbackListResponse> _feedbackListCache;

  String? _feedbackCacheScope;

  RemoteMiniAppFeedbackRepository({
    required this.api,
    required this.session,
    this.logger = const SilentMiniAppLogger(),
    TimedMemoryCacheMap<String, FeedbackListResponse>? feedbackListCache,
  }) : _feedbackListCache =
           feedbackListCache ??
           TimedMemoryCacheMap<String, FeedbackListResponse>(
             ttl: _feedbackListCacheTtl,
           );

  @override
  Future<FeedbackEntity> createFeedback(CreateFeedbackApiReq req) async {
    try {
      await _ensureAdminAuthToken(session);
      final response = await api.createFeedback(req);
      _feedbackListCache.invalidateAll();
      return response.entity;
    } catch (error, stackTrace) {
      logger.onError(
        'create_feedback_failed',
        error: error,
        stackTrace: stackTrace,
      );
      rethrow;
    }
  }

  @override
  Future<FeedbackListResponse> getFeedbackList({
    required int limit,
    required int page,
    bool forceRefresh = false,
  }) async {
    try {
      await _ensureAdminAuthToken(session);
      final String scope = _feedbackScope(session);
      if (_feedbackCacheScope != scope) {
        _feedbackListCache.invalidateAll();
        _feedbackCacheScope = scope;
      }

      return _feedbackListCache.getOrLoad(
        _feedbackListCacheKey(limit: limit, page: page),
        () async {
          final response = await api.getFeedbackList(
            FeedbackListApiReq(limit: limit, page: page),
          );
          return response.toDomain();
        },
        forceRefresh: forceRefresh,
      );
    } catch (error, stackTrace) {
      logger.onError(
        'get_feedback_list_failed',
        error: error,
        stackTrace: stackTrace,
      );
      rethrow;
    }
  }

  String _feedbackListCacheKey({
    required int limit,
    required int page,
  }) {
    return 'limit:$limit|page:$page';
  }
}
