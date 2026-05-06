import 'package:mini_app_sdk/mini_app_sdk.dart';

class ApiQuestionnaireService implements QuestionnaireService {
  static const Duration _questionsCacheTtl = Duration(minutes: 10);

  final IpsBackendApi api;
  final MiniAppProfileRepository appApi;
  final SdkBackendConfig config;
  final MiniAppSessionController session;
  final TimedMemoryCache<List<QuestionnaireQuestion>> _questionsCache;

  ApiQuestionnaireService({
    required this.api,
    required this.appApi,
    required this.config,
    required this.session,
    TimedMemoryCache<List<QuestionnaireQuestion>>? questionsCache,
  }) : _questionsCache =
           questionsCache ??
           TimedMemoryCache<List<QuestionnaireQuestion>>(
             ttl: _questionsCacheTtl,
           );

  @override
  Future<QuestionnaireRes> calculateScore(List<QuestionnaireAnswer> answers) async {
    await session.ensureLoginSession();

    final QuestionnaireResDto res = await api.calculateScore(
      answers,
      srcFiCode: config.runtime.defaultSrcFiCode,
    );

    return res.toDomain(true);
  }

  @override
  Future<List<QuestionnaireQuestion>> getQuestions({bool forceRefresh = false}) async {
    return _questionsCache.getOrLoad(
      () async {
        await session.ensureLoginSession();

        final List<QuestionnaireQuestionDto> questionsList = await api.getQuestionList(
          srcFiCode: config.runtime.defaultSrcFiCode,
        );

        final List<QuestionnaireQuestion> questions = <QuestionnaireQuestion>[
          ...questionsList.map((QuestionnaireQuestionDto dto) => dto.toDomain()),
          ...await appApi.getAllGoals(),
        ];

        return List<QuestionnaireQuestion>.unmodifiable(questions);
      },
      forceRefresh: forceRefresh,
    );
  }
}
