import 'package:mini_app_sdk/mini_app_sdk.dart';

class QuestionnaireOptionDto {
  final String id;
  final String label;
  final String? secondaryLabel;
  final int? scoreValue;
  final String? answerType;
  final int? orderNo;
  final double? amount;
  final String? createdAt;
  final String? updatedAt;

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

  factory QuestionnaireOptionDto.fromQuestionApiJson(Map<String, Object?> json) {
    final String id = ApiParser.asNullableString(json['id']) ?? ApiParser.asNullableString(json['answerId']) ?? '';
    final double? amount = ApiParser.asNullableDouble(json['amount']);
    final String label = ApiParser.asNullableString(json['title']) ?? ApiParser.asNullableString(json['name']) ?? ApiParser.asNullableString(json['answer']) ?? (amount?.toString() ?? '');

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

class QuestionnaireQuestionDto {
  final String id;
  final String title;
  final String? secondaryTitle;
  final String? questionType;
  final String? answerType;
  final int? orderNo;
  final bool isGoal;
  final String? createdAt;
  final String? updatedAt;
  final List<QuestionnaireOptionDto> options;

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

  factory QuestionnaireQuestionDto.fromQuestionApiJson(Map<String, Object?> json) {
    final String id = ApiParser.asNullableString(json['id']) ?? ApiParser.asNullableString(json['questionId']) ?? '';

    return QuestionnaireQuestionDto(
      id: id,
      title: ApiParser.asNullableString(json['title']) ?? '',
      questionType: ApiParser.asNullableString(json['questionType']),
      answerType: ApiParser.asNullableString(json['answerType']),
      isGoal: ApiParser.asFlag(json['is_goal']),
      createdAt: ApiParser.asNullableString(json['created_at']),
      updatedAt: ApiParser.asNullableString(json['updated_at']),
      options: ApiParser.asObjectMapList(json['answers']).map(QuestionnaireOptionDto.fromQuestionApiJson).where((QuestionnaireOptionDto option) => option.id.trim().isNotEmpty).toList(growable: false),
    );
  }

  static List<QuestionnaireQuestionDto> listFromRaw(Object? raw) {
    return ApiParser.asObjectMapList(
      raw,
    ).map(QuestionnaireQuestionDto.fromJson).toList(growable: false);
  }

  static List<QuestionnaireQuestionDto> listFromQuestionApiRaw(Object? raw) {
    return ApiParser.asObjectMapList(raw)
        .map(QuestionnaireQuestionDto.fromQuestionApiJson)
        .where(
          (QuestionnaireQuestionDto question) => question.id.trim().isNotEmpty,
        )
        .toList(growable: false);
  }

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
      options: options.map((QuestionnaireOptionDto option) => option.toDomain()).toList(growable: false),
    );
  }
}

class QuestionnaireResDto {
  const QuestionnaireResDto({
    required this.score,
    this.customerCode,
    this.summary,
  });

  factory QuestionnaireResDto.fromJson(Map<String, Object?> json) {
    final int responseCode = ApiParser.asNullableInt(json['responseCode']) ?? 1;
    if (responseCode != 0) {
      throw ApiBusinessException(
        responseCode: responseCode,
        message: ApiParser.asNullableString(json['responseDesc']) ?? 'Score calculation failed.',
      );
    }

    return QuestionnaireResDto(
      score: ApiParser.asNullableInt(json['totalScore']) ?? 0,
      customerCode: ApiParser.asNullableString(json['custCode']),
      summary: ApiParser.asNullableString(json['responseDesc']),
    );
  }

  final int score;
  final String? customerCode;
  final String? summary;

  QuestionnaireRes toDomain(bool showRecomended) {
    return QuestionnaireRes(
      score: score,
      customerCode: customerCode,
      summary: summary,
      showRecomended: showRecomended,
    );
  }
}
