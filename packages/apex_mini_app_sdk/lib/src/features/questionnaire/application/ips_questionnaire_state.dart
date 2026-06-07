import 'package:apex_mini_app_sdk/apex_mini_app_sdk.dart';

/// UI state for the questionnaire flow.
class IpsQuestionnaireState {
  /// Whether questions/bootstrap state are loading.
  final bool isLoading;

  /// Whether score calculation is running.
  final bool isSubmitting;

  /// Whether selected target goal is being saved.
  final bool isSavingTargetGoal;

  /// Whether questionnaire answers are being persisted to the backend.
  final bool isPersistingAnswers;

  /// Account bootstrap state associated with the questionnaire.
  final AcntBootstrapState? bootstrapState;

  /// Loaded questions.
  final List<QuestionnaireQuestion> questions;

  /// Selected answer map keyed by question id.
  final Map<String, String> answers;

  /// Score calculation result.
  final QuestionnaireRes? res;

  /// Whether contract and question steps should be skipped.
  final bool skipContractAndQuestions;

  /// Whether the calculation step should be skipped.
  final bool skipCalculation;

  /// User-facing error message.
  final String? errorMessage;

  /// Creates questionnaire flow state.
  const IpsQuestionnaireState({
    this.isLoading = false,
    this.isSubmitting = false,
    this.isSavingTargetGoal = false,
    this.isPersistingAnswers = false,
    this.bootstrapState,
    this.questions = const <QuestionnaireQuestion>[],
    this.answers = const <String, String>{},
    this.res,
    this.skipContractAndQuestions = false,
    this.skipCalculation = false,
    this.errorMessage,
  });

  /// Sentinel used to distinguish omitted nullable fields from explicit null.
  static const Object sentinel = Object();

  /// Copies state while allowing explicit null assignment for nullable fields.
  IpsQuestionnaireState copyWith({
    bool? isLoading,
    bool? isSubmitting,
    bool? isSavingTargetGoal,
    bool? isPersistingAnswers,
    Object? bootstrapState = sentinel,
    List<QuestionnaireQuestion>? questions,
    Map<String, String>? answers,
    Object? res = sentinel,
    bool? skipContractAndQuestions,
    bool? skipCalculation,
    Object? errorMessage = sentinel,
  }) {
    return IpsQuestionnaireState(
      isLoading: isLoading ?? this.isLoading,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      isSavingTargetGoal: isSavingTargetGoal ?? this.isSavingTargetGoal,
      isPersistingAnswers: isPersistingAnswers ?? this.isPersistingAnswers,
      bootstrapState: bootstrapState == sentinel
          ? this.bootstrapState
          : bootstrapState as AcntBootstrapState?,
      questions: questions ?? this.questions,
      answers: answers ?? this.answers,
      res: res == sentinel ? this.res : res as QuestionnaireRes?,
      skipContractAndQuestions:
          skipContractAndQuestions ?? this.skipContractAndQuestions,
      skipCalculation: skipCalculation ?? this.skipCalculation,
      errorMessage: errorMessage == sentinel
          ? this.errorMessage
          : errorMessage as String?,
    );
  }
}
