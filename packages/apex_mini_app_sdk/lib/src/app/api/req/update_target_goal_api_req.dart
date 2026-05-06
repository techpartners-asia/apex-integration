class UpdateTargetGoalApiReq {
  final int goalId;

  const UpdateTargetGoalApiReq({required this.goalId});

  Map<String, Object?> toJson() {
    return <String, Object?>{'goal_id': goalId};
  }
}
