import 'package:apex_mini_app_sdk/apex_mini_app_sdk.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('GrapeQuestionnaireCheckCompletedResDto', () {
    test('parses completed and score from body envelope', () {
      final GrapeQuestionnaireCheckCompletedResDto dto =
          GrapeQuestionnaireCheckCompletedResDto.fromEnvelope(<String, Object?>{
            'message': 'OK',
            'body': <String, Object?>{
              'completed': true,
              'score': 12,
            },
          });

      final GrapeQuestionnaireCompletionStatus status = dto.toDomain();

      expect(status.completed, isTrue);
      expect(status.score, 12);
      expect(status.hasPersistedScore, isTrue);
      expect(status.toQuestionnaireRes()?.score, 12);
    });

    test('treats zero score as not persisted', () {
      final GrapeQuestionnaireCompletionStatus status =
          GrapeQuestionnaireCheckCompletedResDto.fromEnvelope(<String, Object?>{
            'body': <String, Object?>{
              'completed': true,
              'score': 0,
            },
          }).toDomain();

      expect(status.completed, isTrue);
      expect(status.hasPersistedScore, isFalse);
      expect(status.toQuestionnaireRes(), isNull);
    });
  });

  group('GrapeQuestionAnswerSubmission', () {
    test('serializes complete request row', () {
      const submission = GrapeQuestionAnswerSubmission(
        questionId: 1,
        answerId: 2,
        scoreValue: 3,
      );

      expect(
        submission.toJson(),
        <String, Object?>{
          'question_id': 1,
          'answer_id': 2,
          'score_value': 3,
        },
      );
    });
  });
}
