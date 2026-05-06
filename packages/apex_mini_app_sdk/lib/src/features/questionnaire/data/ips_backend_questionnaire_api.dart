import 'package:mini_app_sdk/mini_app_sdk.dart';

extension IpsBackendQuestionnaireApi on IpsBackendApi {
  Future<List<QuestionnaireQuestionDto>> getQuestionList({String? srcFiCode}) async {
    final String resolvedSrcFiCode = resolveSrcFiCode(srcFiCode);
    final ApiEnvelope<List<QuestionnaireQuestionDto>> envelope = await protectedExecutor.postEnvelope<List<QuestionnaireQuestionDto>>(
      ApiEndpoints.getQuestionList,
      body: <String, Object?>{'srcFiCode': resolvedSrcFiCode},
      mapper: QuestionnaireQuestionDto.listFromRaw,
      context: const ReqContext(operName: 'getQuestionList'),
    );

    return envelope.responseData;
  }

  Future<QuestionnaireResDto> calculateScore(List<QuestionnaireAnswer> answers, {String? srcFiCode}) async {
    final Map<String, Object?> json = await protectedExecutor.postJson(
      ApiEndpoints.calculateScore,
      body: <String, Object?>{
        'srcFiCode': resolveSrcFiCode(srcFiCode),
        'selectedAnswer': answers
            .map(
              (QuestionnaireAnswer answer) => <String, Object?>{
                'questionId': int.tryParse(answer.questionId) ?? answer.questionId,
                'answerId': int.tryParse(answer.optionId) ?? answer.optionId,
              },
            )
            .toList(growable: false),
      },
      context: const ReqContext(operName: 'calculateScore'),
    );

    return QuestionnaireResDto.fromJson(json);
  }
}
