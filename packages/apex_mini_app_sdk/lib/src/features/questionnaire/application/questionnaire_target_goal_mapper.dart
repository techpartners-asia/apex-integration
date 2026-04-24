num? resolveQuestionnaireTargetGoal(String? staticAnswerId) {
  switch (staticAnswerId?.trim()) {
    case 'ui_static_100000':
      return 100000;
    case 'ui_static_200000':
      return 200000;
    case 'ui_static_500000':
      return 500000;
    case 'ui_static_1000000_plus':
      return 1000000;
    default:
      return null;
  }
}
