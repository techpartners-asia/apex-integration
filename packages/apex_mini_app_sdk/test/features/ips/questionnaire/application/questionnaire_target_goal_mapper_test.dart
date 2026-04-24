import 'package:flutter_test/flutter_test.dart';
import 'package:mini_app_sdk/src/features/questionnaire/application/questionnaire_target_goal_mapper.dart';

void main() {
  test('maps static questionnaire answers to target goal values', () {
    expect(resolveQuestionnaireTargetGoal('ui_static_100000'), 100000);
    expect(resolveQuestionnaireTargetGoal('ui_static_200000'), 200000);
    expect(resolveQuestionnaireTargetGoal('ui_static_500000'), 500000);
    expect(resolveQuestionnaireTargetGoal('ui_static_1000000_plus'), 1000000);
    expect(resolveQuestionnaireTargetGoal('unknown'), isNull);
  });
}
