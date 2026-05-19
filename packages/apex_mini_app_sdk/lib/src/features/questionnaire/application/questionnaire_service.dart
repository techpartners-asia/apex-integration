import 'package:apex_mini_app_sdk/apex_mini_app_sdk_internal.dart';

abstract interface class QuestionnaireService {
  Future<List<QuestionnaireQuestion>> getQuestions({bool forceRefresh = false});

  Future<QuestionnaireRes> calculateScore(List<QuestionnaireAnswer> answers);
}
