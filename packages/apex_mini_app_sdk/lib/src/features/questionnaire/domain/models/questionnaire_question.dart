import 'package:mini_app_sdk/mini_app_sdk.dart';

class QuestionnaireQuestion {
  final String id;
  final String title;
  final String? subtitle;
  final String? secondaryTitle;
  final String? questionType;
  final String? answerType;
  final int? orderNo;
  final bool isGoal;
  final String? createdAt;
  final String? updatedAt;
  final List<QuestionnaireOption> options;

  const QuestionnaireQuestion({
    required this.id,
    required this.title,
    this.subtitle,
    this.secondaryTitle,
    this.questionType,
    this.answerType,
    this.orderNo,
    this.isGoal = false,
    this.createdAt,
    this.updatedAt,
    required this.options,
  });
}
