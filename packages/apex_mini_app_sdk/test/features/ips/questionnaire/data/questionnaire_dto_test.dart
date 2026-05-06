import 'package:flutter_test/flutter_test.dart';
import 'package:mini_app_sdk/mini_app_sdk.dart';

void main() {
  test('question API DTO parses goal question into questionnaire model', () {
    final List<QuestionnaireQuestionDto> questions =
        QuestionnaireQuestionDto.listFromQuestionApiRaw(<Object?>[
          <String, Object?>{
            'id': 12,
            'title': 'Investment amount',
            'is_goal': true,
            'created_at': '2026-05-05T00:00:00.000Z',
            'updated_at': '2026-05-06T00:00:00.000Z',
            'answers': <Object?>[
              <String, Object?>{
                'id': 1,
                'amount': 100000,
                'created_at': '2026-05-05T00:00:00.000Z',
                'updated_at': '2026-05-06T00:00:00.000Z',
              },
              <String, Object?>{
                'id': '2',
                'amount': '200000',
              },
            ],
          },
          <String, Object?>{
            'title': 'Missing id should be skipped',
          },
        ]);

    expect(questions, hasLength(1));
    expect(questions.first.id, '12');
    expect(questions.first.isGoal, isTrue);
    expect(questions.first.options, hasLength(2));

    final QuestionnaireQuestion question = questions.first.toDomain();
    expect(question.id, '12');
    expect(question.isGoal, isTrue);
    expect(question.options.first.id, '1');
    expect(question.options.first.amount, 100000);
    expect(question.options.last.id, '2');
    expect(question.options.last.amount, 200000);
  });

  test('question API DTO uses empty answers when answers is null', () {
    final QuestionnaireQuestionDto question =
        QuestionnaireQuestionDto.fromQuestionApiJson(<String, Object?>{
          'id': 4,
          'title': 'Question',
          'answers': null,
        });

    expect(question.options, isEmpty);
  });
}
