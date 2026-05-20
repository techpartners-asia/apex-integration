/// Answer option shown for a questionnaire question.
class QuestionnaireOption {
  /// Backend option id.
  final String id;

  /// Primary display label.
  final String label;

  /// Secondary/localized display label.
  final String? secondaryLabel;

  /// Score contribution for this option.
  final int? scoreValue;

  /// Backend answer type.
  final String? answerType;

  /// Sort order.
  final int? orderNo;

  /// Optional amount value used by goal/investment questions.
  final double? amount;

  /// Raw creation timestamp.
  final String? createdAt;

  /// Raw update timestamp.
  final String? updatedAt;

  /// Creates a questionnaire answer option.
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
