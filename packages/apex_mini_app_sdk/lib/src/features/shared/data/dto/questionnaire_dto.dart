import 'package:mini_app_sdk/mini_app_sdk.dart';

class QuestionnaireOptionDto {
  final String id;
  final String label;
  final String? secondaryLabel;
  final int? scoreValue;
  final String? answerType;
  final int? orderNo;

  const QuestionnaireOptionDto({
    required this.id,
    required this.label,
    this.secondaryLabel,
    this.scoreValue,
    this.answerType,
    this.orderNo,
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

  QuestionnaireOption toDomain() {
    return QuestionnaireOption(
      id: id,
      label: label,
      secondaryLabel: secondaryLabel,
      scoreValue: scoreValue,
      answerType: answerType,
      orderNo: orderNo,
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
  final List<QuestionnaireOptionDto> options;

  const QuestionnaireQuestionDto({
    required this.id,
    required this.title,
    required this.options,
    this.secondaryTitle,
    this.questionType,
    this.answerType,
    this.orderNo,
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

  static List<QuestionnaireQuestionDto> listFromRaw(Object? raw) {
    return ApiParser.asObjectMapList(
      raw,
    ).map(QuestionnaireQuestionDto.fromJson).toList(growable: false);
  }

  QuestionnaireQuestion toDomain() {
    return QuestionnaireQuestion(
      id: id,
      title: title,
      secondaryTitle: secondaryTitle,
      questionType: questionType,
      answerType: answerType,
      orderNo: orderNo,
      options: options
          .map((QuestionnaireOptionDto option) => option.toDomain())
          .toList(growable: false),
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

  final int score;
  final String? customerCode;
  final String? summary;

  QuestionnaireRes toDomain() {
    return QuestionnaireRes(
      score: score,
      customerCode: customerCode,
      summary: summary,
    );
  }
}
