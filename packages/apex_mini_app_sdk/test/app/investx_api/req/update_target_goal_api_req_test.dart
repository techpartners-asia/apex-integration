import 'package:flutter_test/flutter_test.dart';
import 'package:apex_mini_app_sdk/apex_mini_app_sdk_internal.dart';

void main() {
  test('update target goal request sends goal_id', () {
    const UpdateTargetGoalApiReq req = UpdateTargetGoalApiReq(goalId: 1);

    expect(req.toJson(), <String, Object?>{'goal_id': 1});
  });
}
