import 'package:apex_mini_app_sdk/apex_mini_app_sdk.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Cubit for questionnaire answer selection, score calculation, and target goal save.
class IpsQuestionnaireCubit extends Cubit<IpsQuestionnaireState> {
  /// Questionnaire API service.
  final QuestionnaireService service;

  /// Profile repository used to save selected target goal.
  final MiniAppProfileRepository appApi;

  /// Bootstrap service used when the screen was opened without initial state.
  final InvestmentBootstrapService? bootstrapService;

  /// Optional bootstrap state passed from startup/overview flow.
  final AcntBootstrapState? initialBootstrapState;

  /// Localizations used for user-facing errors.
  final SdkLocalizations l10n;

  IpsQuestionnaireCubit({
    required this.service,
    required this.appApi,
    required this.l10n,
    this.bootstrapService,
    this.initialBootstrapState,
  }) : super(IpsQuestionnaireState(bootstrapState: initialBootstrapState));

  /// Loads bootstrap state and questionnaire questions.
  Future<void> load() async {
    emit(
      state.copyWith(
        isLoading: true,
        errorMessage: null,
        bootstrapState: state.bootstrapState ?? initialBootstrapState,
      ),
    );

    try {
      final AcntBootstrapState bootstrapState =
          state.bootstrapState ??
          initialBootstrapState ??
          await BootstrapStateResolver(service: bootstrapService!).load();
      final GrapeQuestionnaireCompletionStatus completionStatus =
          await service.checkCompletionStatus();
      final List<QuestionnaireQuestion> questions = await service.getQuestions();
      final QuestionnaireRes? existingResult =
          completionStatus.toQuestionnaireRes();
      // Skip questionnaire screens only when score is already persisted — if
      // completed but no score, the user must re-answer so calculateScore has
      // valid answers.
      final bool skipContractAndQuestions = completionStatus.hasPersistedScore;
      final bool skipCalculation = completionStatus.hasPersistedScore;

      emit(
        state.copyWith(
          isLoading: false,
          bootstrapState: bootstrapState,
          questions: questions,
          answers: const <String, String>{},
          res: existingResult,
          skipContractAndQuestions: skipContractAndQuestions,
          skipCalculation: skipCalculation,
          errorMessage: null,
        ),
      );
    } catch (error) {
      emit(
        state.copyWith(
          isLoading: false,
          errorMessage: formatIpsError(error, l10n),
        ),
      );
    }
  }

  /// Stores the selected option for a question in local state only.
  void selectAnswer({required String questionId, required String optionId}) {
    final Map<String, String> nextAnswers = Map<String, String>.from(
      state.answers,
    )..[questionId] = optionId;
    emit(state.copyWith(answers: nextAnswers, errorMessage: null));
  }

  /// Persists all selected answers through the grape complete endpoint.
  Future<bool> completeQuestionnaire() async {
    if (state.isPersistingAnswers) {
      return false;
    }

    emit(
      state.copyWith(
        isPersistingAnswers: true,
        errorMessage: null,
      ),
    );

    try {
      final List<GrapeQuestionAnswerSubmission>? submissions =
          _buildQuestionnaireSubmissions();
      if (submissions == null) {
        emit(
          state.copyWith(
            isPersistingAnswers: false,
            errorMessage: l10n.validationQuestionnaireIncomplete,
          ),
        );
        return false;
      }

      await service.completeQuestionnaire(questions: submissions);
      emit(
        state.copyWith(
          isPersistingAnswers: false,
          errorMessage: null,
        ),
      );
      return true;
    } catch (error) {
      emit(
        state.copyWith(
          isPersistingAnswers: false,
          errorMessage: formatIpsError(error, l10n),
        ),
      );
      return false;
    }
  }

  /// Saves the selected investment target goal to the profile API.
  Future<bool> saveSelectedTargetGoal({required String questionId}) async {
    if (state.isSavingTargetGoal) {
      return false;
    }

    final int? selectedGoalId = int.tryParse(state.answers[questionId] ?? '');
    if (selectedGoalId == null) {
      emit(
        state.copyWith(
          errorMessage: l10n.ipsQuestionnaireTargetGoalMissing,
        ),
      );
      return false;
    }

    emit(
      state.copyWith(
        isSavingTargetGoal: true,
        errorMessage: null,
      ),
    );

    try {
      await appApi.updateTargetGoal(
        UpdateTargetGoalApiReq(goalId: selectedGoalId),
      );
      emit(
        state.copyWith(
          isSavingTargetGoal: false,
          errorMessage: null,
        ),
      );
      return true;
    } catch (error) {
      emit(
        state.copyWith(
          isSavingTargetGoal: false,
          errorMessage: formatIpsError(error, l10n),
        ),
      );
      return false;
    }
  }

  /// Calculates the score from submitted or state answers, then persists it.
  Future<void> submit() async {
    if (state.isSubmitting) {
      return;
    }

    final QuestionnaireRes? existingResult = state.res;
    if (existingResult != null) {
      return;
    }

    emit(state.copyWith(isSubmitting: true, errorMessage: null));

    try {
      final List<GrapeQuestionAnswerSubmission>? submissions =
          _buildQuestionnaireSubmissions();
      final Set<String> goalIds = state.questions
          .where((QuestionnaireQuestion q) => q.isGoal)
          .map((QuestionnaireQuestion q) => q.id)
          .toSet();
      final List<QuestionnaireAnswer> answers = submissions != null
          ? submissions
                .where(
                  (GrapeQuestionAnswerSubmission s) =>
                      !goalIds.contains(s.questionId.toString()),
                )
                .map(
                  (GrapeQuestionAnswerSubmission s) => QuestionnaireAnswer(
                    questionId: s.questionId.toString(),
                    optionId: s.answerId.toString(),
                  ),
                )
                .toList(growable: false)
          : _buildAnswers();

      final QuestionnaireRes scoreRes = await service.calculateScore(answers);
      final QuestionnaireRes res = await service.saveTotalScore(scoreRes.score);

      emit(state.copyWith(isSubmitting: false, res: res, errorMessage: null));
    } catch (error) {
      emit(
        state.copyWith(
          isSubmitting: false,
          errorMessage: formatIpsError(error, l10n),
        ),
      );
    }
  }

  List<QuestionnaireAnswer> _buildAnswers() {
    return state.questions
        .where((QuestionnaireQuestion q) => !q.isGoal)
        .map(
          (QuestionnaireQuestion q) => QuestionnaireAnswer(
            questionId: q.id,
            optionId: state.answers[q.id] ?? '',
          ),
        )
        .where((QuestionnaireAnswer a) => a.optionId.isNotEmpty)
        .toList(growable: false);
  }

  List<GrapeQuestionAnswerSubmission>? _buildQuestionnaireSubmissions() {
    final List<GrapeQuestionAnswerSubmission> submissions =
        <GrapeQuestionAnswerSubmission>[];

    for (final QuestionnaireQuestion question in state.questions) {
      final String? answerId = state.answers[question.id]?.trim();
      if (answerId == null || answerId.isEmpty) {
        return null;
      }

      final int? questionId = int.tryParse(question.id);
      final int? parsedAnswerId = int.tryParse(answerId);
      if (questionId == null || parsedAnswerId == null) {
        return null;
      }

      submissions.add(
        GrapeQuestionAnswerSubmission(
          questionId: questionId,
          answerId: parsedAnswerId,
          scoreValue: _resolveScoreValue(question, answerId),
        ),
      );
    }

    return submissions;
  }

  int _resolveScoreValue(QuestionnaireQuestion question, String answerId) {
    for (final QuestionnaireOption option in question.options) {
      if (option.id == answerId) {
        return option.scoreValue ?? 0;
      }
    }

    return 0;
  }


}
