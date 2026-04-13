import '../models/ips_models.dart';

class QuestionnaireService {
  const QuestionnaireService();

  Future<List<QuestionnaireQuestion>> getQuestions({
    bool forceRefresh = false,
  }) {
    throw UnimplementedError();
  }

  Future<QuestionnaireRes> calculateScore(List<QuestionnaireAnswer> answers) {
    throw UnimplementedError();
  }
}
