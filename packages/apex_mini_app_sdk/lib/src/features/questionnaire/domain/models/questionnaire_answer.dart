/// Selected answer for one questionnaire question.
class QuestionnaireAnswer {
  /// Question id returned by the questionnaire API.
  final String questionId;

  /// Selected answer option id.
  final String optionId;

  /// Creates a selected questionnaire answer.
  const QuestionnaireAnswer({required this.questionId, required this.optionId});
}
