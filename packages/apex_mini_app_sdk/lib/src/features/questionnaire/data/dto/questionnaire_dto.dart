import 'package:apex_mini_app_sdk/apex_mini_app_sdk.dart';

/// Answer option DTO parsed from questionnaire APIs.
class QuestionnaireOptionDto {
  /// Backend option id.
  final String id;

  /// Primary label.
  final String label;

  /// Secondary/localized label.
  final String? secondaryLabel;

  /// Score value used by score calculation.
  final int? scoreValue;

  /// Backend answer type.
  final String? answerType;

  /// Sort order.
  final int? orderNo;

  /// Optional amount for goal-style answers.
  final double? amount;

  /// Raw creation timestamp.
  final String? createdAt;

  /// Raw update timestamp.
  final String? updatedAt;

  /// Creates a questionnaire answer option DTO.
  const QuestionnaireOptionDto({
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

  /// Parses option JSON from the legacy question-list API shape.
  factory QuestionnaireOptionDto.fromJson(Map<String, Object?> json) {
    return QuestionnaireOptionDto(
      id: ApiParser.asNullableString(json['answerId']) ?? '',
      label: ApiParser.asNullableString(json['name']) ?? '',
      secondaryLabel: ApiParser.asNullableString(json['name2']),
      scoreValue: ApiParser.asNullableInt(json['scoreValue']),
      answerType: ApiParser.asNullableString(json['answerType']),
      orderNo: ApiParser.asNullableInt(json['orderNo']),
    );
  }

  /// Parses option JSON from the current question API shape.
  factory QuestionnaireOptionDto.fromQuestionApiJson(
    Map<String, Object?> json,
  ) {
    final String id =
        ApiParser.asNullableString(json['id']) ??
        ApiParser.asNullableString(json['answerId']) ??
        '';
    final double? amount = ApiParser.asNullableDouble(json['amount']);
    final String label =
        ApiParser.asNullableString(json['title']) ??
        ApiParser.asNullableString(json['name']) ??
        ApiParser.asNullableString(json['answer']) ??
        (amount?.toString() ?? '');

    return QuestionnaireOptionDto(
      id: id,
      label: label,
      secondaryLabel: ApiParser.asNullableString(json['name2']),
      answerType: ApiParser.asNullableString(json['answerType']),
      orderNo: ApiParser.asNullableInt(json['orderNo']),
      amount: amount,
      createdAt: ApiParser.asNullableString(json['created_at']),
      updatedAt: ApiParser.asNullableString(json['updated_at']),
    );
  }

  /// Converts the DTO into the domain answer option.
  QuestionnaireOption toDomain() {
    return QuestionnaireOption(
      id: id,
      label: label,
      secondaryLabel: secondaryLabel,
      scoreValue: scoreValue,
      answerType: answerType,
      orderNo: orderNo,
      amount: amount,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}

/// Question DTO parsed from questionnaire APIs.
class QuestionnaireQuestionDto {
  /// Backend question id.
  final String id;

  /// Primary title.
  final String title;

  /// Secondary/localized title.
  final String? secondaryTitle;

  /// Backend question type.
  final String? questionType;

  /// Backend answer type.
  final String? answerType;

  /// Sort order.
  final int? orderNo;

  /// Whether this question is the goal/amount question.
  final bool isGoal;

  /// Raw creation timestamp.
  final String? createdAt;

  /// Raw update timestamp.
  final String? updatedAt;

  /// Answer options for this question.
  final List<QuestionnaireOptionDto> options;

  /// Creates a questionnaire question DTO.
  const QuestionnaireQuestionDto({
    required this.id,
    required this.title,
    required this.options,
    this.secondaryTitle,
    this.questionType,
    this.answerType,
    this.orderNo,
    this.isGoal = false,
    this.createdAt,
    this.updatedAt,
  });

  /// Parses question JSON from the legacy question-list API shape.
  factory QuestionnaireQuestionDto.fromJson(Map<String, Object?> json) {
    return QuestionnaireQuestionDto(
      id: ApiParser.asNullableString(json['questionId']) ?? '',
      title: ApiParser.asNullableString(json['name']) ?? '',
      secondaryTitle: ApiParser.asNullableString(json['name2']),
      questionType: ApiParser.asNullableString(json['questionType']),
      answerType: ApiParser.asNullableString(json['answerType']),
      orderNo: ApiParser.asNullableInt(json['orderNo']),
      options: ApiParser.asObjectMapList(
        json['answerIds'],
      ).map(QuestionnaireOptionDto.fromJson).toList(growable: false),
    );
  }

  /// Parses question JSON from the current question API shape.
  factory QuestionnaireQuestionDto.fromQuestionApiJson(
    Map<String, Object?> json,
  ) {
    final String id =
        ApiParser.asNullableString(json['id']) ??
        ApiParser.asNullableString(json['questionId']) ??
        '';

    return QuestionnaireQuestionDto(
      id: id,
      title: ApiParser.asNullableString(json['title']) ?? '',
      questionType: ApiParser.asNullableString(json['questionType']),
      answerType: ApiParser.asNullableString(json['answerType']),
      isGoal: ApiParser.asFlag(json['is_goal']),
      createdAt: ApiParser.asNullableString(json['created_at']),
      updatedAt: ApiParser.asNullableString(json['updated_at']),
      options: ApiParser.asObjectMapList(json['answers'])
          .map(QuestionnaireOptionDto.fromQuestionApiJson)
          .where((QuestionnaireOptionDto option) => option.id.trim().isNotEmpty)
          .toList(growable: false),
    );
  }

  /// Parses a raw legacy list response into question DTOs.
  static List<QuestionnaireQuestionDto> listFromRaw(Object? raw) {
    return ApiParser.asObjectMapList(
      raw,
    ).map(QuestionnaireQuestionDto.fromJson).toList(growable: false);
  }

  /// Parses a raw current question API list response into question DTOs.
  static List<QuestionnaireQuestionDto> listFromQuestionApiRaw(Object? raw) {
    return ApiParser.asObjectMapList(raw)
        .map(QuestionnaireQuestionDto.fromQuestionApiJson)
        .where(
          (QuestionnaireQuestionDto question) => question.id.trim().isNotEmpty,
        )
        .toList(growable: false);
  }

  /// Converts the DTO into the domain question model.
  QuestionnaireQuestion toDomain() {
    return QuestionnaireQuestion(
      id: id,
      title: title,
      secondaryTitle: secondaryTitle,
      questionType: questionType,
      answerType: answerType,
      orderNo: orderNo,
      isGoal: isGoal,
      createdAt: createdAt,
      updatedAt: updatedAt,
      options: options
          .map((QuestionnaireOptionDto option) => option.toDomain())
          .toList(growable: false),
    );
  }
}

/// Score calculation response DTO.
class QuestionnaireResDto {
  /// Creates a questionnaire score result DTO.
  const QuestionnaireResDto({
    required this.score,
    this.customerCode,
    this.summary,
  });

  /// Parses and validates the score calculation response.
  factory QuestionnaireResDto.fromJson(Map<String, Object?> json) {
    final int responseCode = ApiParser.asNullableInt(json['responseCode']) ?? 1;
    if (responseCode != 0) {
      throw ApiBusinessException(
        responseCode: responseCode,
        message:
            ApiParser.asNullableString(json['responseDesc']) ??
            'Score calculation failed.',
      );
    }

    return QuestionnaireResDto(
      score: ApiParser.asNullableInt(json['totalScore']) ?? 0,
      customerCode: ApiParser.asNullableString(json['custCode']),
      summary: ApiParser.asNullableString(json['responseDesc']),
    );
  }

  /// Parses the grape set-score response.
  factory QuestionnaireResDto.fromGrapeSetScoreJson(
    Map<String, Object?> json, {
    required int fallbackScore,
  }) {
    final Map<String, Object?> payload = _unwrapEnvelopeBody(json);
    final int score =
        ApiParser.asNullableInt(payload['total_score']) ??
        ApiParser.asNullableInt(payload['totalScore']) ??
        ApiParser.asNullableInt(payload['score']) ??
        ApiParser.asNullableInt(json['total_score']) ??
        ApiParser.asNullableInt(json['totalScore']) ??
        ApiParser.asNullableInt(json['score']) ??
        fallbackScore;

    return QuestionnaireResDto(
      score: score,
      customerCode: ApiParser.asNullableString(payload['custCode']),
      summary: ApiParser.asNullableString(payload['responseDesc']),
    );
  }

  /// Calculated total score.
  final int score;

  /// Customer code returned by the backend.
  final String? customerCode;

  /// Backend summary/description.
  final String? summary;

  /// Converts the score response into the domain result.
  QuestionnaireRes toDomain(bool showRecomended) {
    return QuestionnaireRes(
      score: score,
      customerCode: customerCode,
      summary: summary,
      showRecomended: showRecomended,
    );
  }
}

/// Completion payload returned by the grape check-completed endpoint.
class GrapeQuestionnaireCheckCompletedResDto {
  /// Creates the check-completed response DTO.
  const GrapeQuestionnaireCheckCompletedResDto({
    required this.completed,
    this.score,
    this.questions = const <QuestionnaireAnswer>[],
  });

  /// Whether the questionnaire is complete on the backend.
  final bool completed;

  /// Persisted score, when available.
  final int? score;

  /// Previously submitted question-answer pairs.
  final List<QuestionnaireAnswer> questions;

  /// Parses the grape check-completed response envelope.
  factory GrapeQuestionnaireCheckCompletedResDto.fromEnvelope(
    Map<String, Object?> json,
  ) {
    final Map<String, Object?> payload = _unwrapEnvelopeBody(json);

    final List<QuestionnaireAnswer> questions = ApiParser.asObjectMapList(payload['questions'])
        .map(
          (Map<String, Object?> q) => QuestionnaireAnswer(
            questionId: ApiParser.asNullableString(q['question_id']) ?? '',
            optionId: ApiParser.asNullableString(q['answer_id']) ?? '',
          ),
        )
        .where((QuestionnaireAnswer a) => a.questionId.isNotEmpty && a.optionId.isNotEmpty)
        .toList(growable: false);

    return GrapeQuestionnaireCheckCompletedResDto(
      completed: ApiParser.asFlag(payload['completed']),
      score: ApiParser.asNullableInt(payload['score']),
      questions: questions,
    );
  }

  /// Converts the DTO into the domain completion status model.
  GrapeQuestionnaireCompletionStatus toDomain() {
    return GrapeQuestionnaireCompletionStatus(
      completed: completed,
      score: score,
      questions: questions,
    );
  }
}

Map<String, Object?> _unwrapEnvelopeBody(Map<String, Object?> json) {
  final Object? body = json['body'];
  if (body is Map) {
    return body.map(
      (Object? key, Object? value) => MapEntry(key.toString(), value),
    );
  }

  return json;
}
