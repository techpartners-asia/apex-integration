/// Calculated questionnaire result used to recommend an investment package.
class QuestionnaireRes {
  /// Total score returned by the backend.
  final int score;

  /// Source financial institution code associated with the result.
  final String? srcFiCode;

  /// Backend summary/description for the result.
  final String? summary;

  /// Customer code returned with the score calculation.
  final String? customerCode;

  /// Whether the recommendation screen should be shown after scoring.
  bool showRecomended;

  /// Creates a calculated questionnaire result.
  QuestionnaireRes({
    required this.score,
    this.srcFiCode,
    this.summary,
    this.customerCode,
    required this.showRecomended,
  });
}
