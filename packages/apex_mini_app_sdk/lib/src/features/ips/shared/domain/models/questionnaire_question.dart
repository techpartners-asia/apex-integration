import 'questionnaire_option.dart';

class QuestionnaireQuestion {
  final String id;
  final String title;
  final String? subtitle;
  final String? secondaryTitle;
  final String? questionType;
  final String? answerType;
  final int? orderNo;
  final List<QuestionnaireOption> options;

  const QuestionnaireQuestion({
    required this.id,
    required this.title,
    this.subtitle,
    this.secondaryTitle,
    this.questionType,
    this.answerType,
    this.orderNo,
    required this.options,
  });
}
