import 'package:mini_app_sdk/mini_app_sdk.dart';

abstract interface class QuestionnaireService {
  Future<List<QuestionnaireQuestion>> getQuestions({
    bool forceRefresh = false,
  });

  Future<QuestionnaireRes> calculateScore(List<QuestionnaireAnswer> answers);
}
