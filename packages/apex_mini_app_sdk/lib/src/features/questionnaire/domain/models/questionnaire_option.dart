class QuestionnaireOption {
  final String id;
  final String label;
  final String? secondaryLabel;
  final int? scoreValue;
  final String? answerType;
  final int? orderNo;
  final double? amount;
  final String? createdAt;
  final String? updatedAt;

  const QuestionnaireOption({
    required this.id,
    required this.label,
    this.secondaryLabel,
    this.scoreValue,
    this.answerType,
    this.orderNo,
    this.amount,
    this.createdAt,
    this.updatedAt,
  });
}
