import 'package:apex_mini_app_sdk/apex_mini_app_sdk.dart';

/// Completion state returned by the grape check-completed endpoint.
class GrapeQuestionnaireCompletionStatus {
  /// Creates grape questionnaire completion status.
  const GrapeQuestionnaireCompletionStatus({
    this.completed = false,
    this.score,
    this.questions = const <QuestionnaireAnswer>[],
  });

  /// Whether the backend considers the questionnaire complete.
  final bool completed;

  /// Persisted score, when available.
  final int? score;

  /// Previously submitted question-answer pairs from the backend.
  final List<QuestionnaireAnswer> questions;

  /// Whether a persisted score should skip the calculate step.
  bool get hasPersistedScore => score != null && score! > 0;

  /// Whether completed answers exist to auto-calculate score from.
  bool get hasCompletedAnswers => completed && questions.isNotEmpty;

  /// Converts the persisted score into the pack-selection result model.
  QuestionnaireRes? toQuestionnaireRes() {
    final int? persistedScore = score;
    if (!hasPersistedScore || persistedScore == null) {
      return null;
    }

    return QuestionnaireRes(
      score: persistedScore,
      showRecomended: true,
    );
  }
}

/// One answer row sent to the grape complete endpoint.
class GrapeQuestionAnswerSubmission {
  /// Creates one grape questionnaire answer submission row.
  const GrapeQuestionAnswerSubmission({
    required this.questionId,
    required this.answerId,
    required this.scoreValue,
  });

  /// Backend question id.
  final int questionId;

  /// Selected answer id.
  final int answerId;

  /// Score value associated with the selected answer.
  final int scoreValue;

  /// Serializes the row for the grape complete request body.
  Map<String, Object?> toJson() {
    return <String, Object?>{
      'question_id': questionId,
      'answer_id': answerId,
      'score_value': scoreValue,
    };
  }
}
