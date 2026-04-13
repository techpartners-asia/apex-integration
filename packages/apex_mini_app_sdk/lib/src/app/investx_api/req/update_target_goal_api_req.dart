class UpdateTargetGoalApiReq {
  final num targetGoal;

  const UpdateTargetGoalApiReq({required this.targetGoal});

  Map<String, Object?> toJson() {
    return <String, Object?>{'target_goal': targetGoal};
  }
}
