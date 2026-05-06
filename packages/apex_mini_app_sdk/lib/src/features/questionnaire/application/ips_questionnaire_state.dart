import 'package:mini_app_sdk/mini_app_sdk.dart';

class IpsQuestionnaireState {
  final bool isLoading;
  final bool isSubmitting;
  final bool isSavingTargetGoal;
  final AcntBootstrapState? bootstrapState;
  final List<QuestionnaireQuestion> questions;
  final Map<String, String> answers;
  final QuestionnaireRes? res;
  final String? errorMessage;

  const IpsQuestionnaireState({
    this.isLoading = false,
    this.isSubmitting = false,
    this.isSavingTargetGoal = false,
    this.bootstrapState,
    this.questions = const <QuestionnaireQuestion>[],
    this.answers = const <String, String>{},
    this.res,
    this.errorMessage,
  });

  static const Object sentinel = Object();

  IpsQuestionnaireState copyWith({
    bool? isLoading,
    bool? isSubmitting,
    bool? isSavingTargetGoal,
    Object? bootstrapState = sentinel,
    List<QuestionnaireQuestion>? questions,
    Map<String, String>? answers,
    Object? res = sentinel,
    Object? errorMessage = sentinel,
  }) {
    return IpsQuestionnaireState(
      isLoading: isLoading ?? this.isLoading,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      isSavingTargetGoal: isSavingTargetGoal ?? this.isSavingTargetGoal,
      bootstrapState: bootstrapState == sentinel ? this.bootstrapState : bootstrapState as AcntBootstrapState?,
      questions: questions ?? this.questions,
      answers: answers ?? this.answers,
      res: res == sentinel ? this.res : res as QuestionnaireRes?,
      errorMessage: errorMessage == sentinel ? this.errorMessage : errorMessage as String?,
    );
  }
}
