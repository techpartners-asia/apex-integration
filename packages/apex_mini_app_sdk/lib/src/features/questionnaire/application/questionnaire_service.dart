import 'package:apex_mini_app_sdk/apex_mini_app_sdk.dart';

/// Questionnaire service contract.
abstract interface class QuestionnaireService {
  /// Loads questionnaire questions.
  Future<List<QuestionnaireQuestion>> getQuestions({bool forceRefresh = false});

  /// Calculates questionnaire score from selected answers.
  Future<QuestionnaireRes> calculateScore(List<QuestionnaireAnswer> answers);
}
