import 'package:mini_app_sdk/mini_app_sdk.dart';

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
