import '../../../../../app/session/mini_app_session_controller.dart';
import '../../../../../core/backend/sdk_backend_config.dart';
import '../../../../../utils/timed_memory_cache.dart';
import '../../domain/services/investment_services.dart';
import '../api/ips_backend_api.dart';
import '../dto/ips_response_dtos.dart';

class ApiQuestionnaireService implements QuestionnaireService {
  static const Duration _questionsCacheTtl = Duration(minutes: 10);

  final IpsBackendApi api;
  final SdkBackendConfig config;
  final MiniAppSessionController session;
  final TimedMemoryCache<List<QuestionnaireQuestion>> _questionsCache;

  ApiQuestionnaireService({
    required this.api,
    required this.config,
    required this.session,
    TimedMemoryCache<List<QuestionnaireQuestion>>? questionsCache,
  }) : _questionsCache =
           questionsCache ??
           TimedMemoryCache<List<QuestionnaireQuestion>>(
             ttl: _questionsCacheTtl,
           );

  @override
  Future<QuestionnaireRes> calculateScore(
    List<QuestionnaireAnswer> answers,
  ) async {
    await session.ensureLoginSession();

    final QuestionnaireResDto res = await api.calculateScore(
      answers,
      srcFiCode: config.runtime.defaultSrcFiCode,
    );

    return res.toDomain();
  }

  @override
  Future<List<QuestionnaireQuestion>> getQuestions({
    bool forceRefresh = false,
  }) async {
    return _questionsCache.getOrLoad(
      () async {
        await session.ensureLoginSession();

        final List<QuestionnaireQuestionDto> questions = await api
            .getQuestionList(
              srcFiCode: config.runtime.defaultSrcFiCode,
            );

        return List<QuestionnaireQuestion>.unmodifiable(
          questions.map((QuestionnaireQuestionDto dto) => dto.toDomain()),
        );
      },
      forceRefresh: forceRefresh,
    );
  }
}
