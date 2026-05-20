import 'package:apex_mini_app_sdk/apex_mini_app_sdk.dart';

/// Questionnaire question with selectable answer options.
class QuestionnaireQuestion {
  /// Backend question id.
  final String id;

  /// Primary question title.
  final String title;

  /// Optional subtitle displayed under the title.
  final String? subtitle;

  /// Secondary/localized question title.
  final String? secondaryTitle;

  /// Backend question type.
  final String? questionType;

  /// Backend answer type.
  final String? answerType;

  /// Sort order.
  final int? orderNo;

  /// Whether this question captures an investment goal amount.
  final bool isGoal;

  /// Raw creation timestamp.
  final String? createdAt;

  /// Raw update timestamp.
  final String? updatedAt;

  /// Available answer options.
  final List<QuestionnaireOption> options;

  /// Creates a questionnaire question domain model.
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
