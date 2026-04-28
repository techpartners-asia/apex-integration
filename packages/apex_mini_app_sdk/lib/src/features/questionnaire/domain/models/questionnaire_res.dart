class QuestionnaireRes {
  final int score;
  final String? srcFiCode;
  final String? summary;
  final String? customerCode;

  const QuestionnaireRes({
    required this.score,
    this.srcFiCode,
    this.summary,
    this.customerCode,
  });
}
