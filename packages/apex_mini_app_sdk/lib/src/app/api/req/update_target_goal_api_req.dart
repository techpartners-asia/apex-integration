/// Request body for updating the user's target investment goal.
class UpdateTargetGoalApiReq {
  /// Selected goal id.
  final int goalId;

  /// Creates a target-goal update request.
  const UpdateTargetGoalApiReq({required this.goalId});

  /// Converts this request to backend JSON.
  Map<String, Object?> toJson() {
    return <String, Object?>{'goal_id': goalId};
  }
}
