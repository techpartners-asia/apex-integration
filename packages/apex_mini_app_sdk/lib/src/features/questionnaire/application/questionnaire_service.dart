import 'package:apex_mini_app_sdk/apex_mini_app_sdk.dart';

/// Questionnaire service contract.
abstract interface class QuestionnaireService {
  /// Loads questionnaire questions.
  Future<List<QuestionnaireQuestion>> getQuestions({bool forceRefresh = false});

  /// Checks whether the grape questionnaire is already complete.
  Future<GrapeQuestionnaireCompletionStatus> checkCompletionStatus({
    bool forceRefresh = false,
  });

  /// Persists all grape questionnaire answers in one request.
  Future<void> completeQuestionnaire({
    required List<GrapeQuestionAnswerSubmission> questions,
  });

  /// Persists the calculated grape questionnaire score.
  Future<QuestionnaireRes> saveTotalScore(int totalScore);
}
