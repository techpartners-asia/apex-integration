class QuestionnaireOption {
  final String id;
  final String label;
  final String? secondaryLabel;
  final int? scoreValue;
  final String? answerType;
  final int? orderNo;

  const QuestionnaireOption({
    required this.id,
    required this.label,
    this.secondaryLabel,
    this.scoreValue,
    this.answerType,
    this.orderNo,
  });
}
