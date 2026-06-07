import 'package:apex_mini_app_sdk/apex_mini_app_sdk.dart';

/// Backend-backed questionnaire service for loading questions and scoring.
class ApiQuestionnaireService implements QuestionnaireService {
  static const Duration _questionsCacheTtl = Duration(minutes: 10);

  /// IPS backend facade.
  final IpsBackendApi api;

  /// Profile repository used to append target-goal questions.
  final MiniAppProfileRepository appApi;

  /// Runtime backend config for FI defaults.
  final SdkBackendConfig config;

  /// Session controller used to ensure login-session auth before calls.
  final MiniAppSessionController session;

  /// Cache for questionnaire definitions and goal options.
  final TimedMemoryCache<List<QuestionnaireQuestion>> _questionsCache;

  /// Cache for grape questionnaire completion state.
  final TimedMemoryCache<GrapeQuestionnaireCompletionStatus> _completionCache;

  /// Creates the questionnaire service.
  ApiQuestionnaireService({
    required this.api,
    required this.appApi,
    required this.config,
    required this.session,
    TimedMemoryCache<List<QuestionnaireQuestion>>? questionsCache,
    TimedMemoryCache<GrapeQuestionnaireCompletionStatus>? completionCache,
  }) : _questionsCache =
           questionsCache ??
           TimedMemoryCache<List<QuestionnaireQuestion>>(
             ttl: _questionsCacheTtl,
           ),
       _completionCache =
           completionCache ??
           TimedMemoryCache<GrapeQuestionnaireCompletionStatus>(
             ttl: _questionsCacheTtl,
           );

  @override
  Future<GrapeQuestionnaireCompletionStatus> checkCompletionStatus({
    bool forceRefresh = false,
  }) {
    return _completionCache.getOrLoad(
      () async {
        await session.ensureLoginSession();
        return appApi.checkGrapeQuestionnaireCompleted();
      },
      forceRefresh: forceRefresh,
    );
  }

  @override
  Future<void> completeQuestionnaire({
    required List<GrapeQuestionAnswerSubmission> questions,
  }) async {
    await session.ensureLoginSession();
    await appApi.completeGrapeQuestionnaire(questions: questions);
    _completionCache.invalidate();
  }

  @override
  Future<QuestionnaireRes> saveTotalScore(int totalScore) async {
    await session.ensureLoginSession();
    final QuestionnaireRes res = await appApi.setGrapeQuestionnaireScore(
      totalScore: totalScore,
    );
    _completionCache.invalidate();
    return res;
  }

  @override
  Future<List<QuestionnaireQuestion>> getQuestions({
    bool forceRefresh = false,
  }) async {
    return _questionsCache.getOrLoad(
      () async {
        await session.ensureLoginSession();

        final List<QuestionnaireQuestionDto> questionsList = await api
            .getQuestionList(
              srcFiCode: config.runtime.defaultSrcFiCode,
            );

        final List<QuestionnaireQuestion> questions = <QuestionnaireQuestion>[
          ...questionsList.map(
            (QuestionnaireQuestionDto dto) => dto.toDomain(),
          ),
          ...await appApi.getAllGoals(),
        ];

        return List<QuestionnaireQuestion>.unmodifiable(questions);
      },
      forceRefresh: forceRefresh,
    );
  }
}
