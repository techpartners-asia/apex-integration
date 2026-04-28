import 'package:mini_app_sdk/mini_app_sdk.dart';

class IpsQuestionnaireState {
  final bool isLoading;
  final bool isSubmitting;
  final AcntBootstrapState? bootstrapState;
  final List<QuestionnaireQuestion> questions;
  final Map<String, String> answers;
  final String? staticQuestionAnswerId;
  final QuestionnaireRes? res;
  final String? errorMessage;

  const IpsQuestionnaireState({
    this.isLoading = false,
    this.isSubmitting = false,
    this.bootstrapState,
    this.questions = const <QuestionnaireQuestion>[],
    this.answers = const <String, String>{},
    this.staticQuestionAnswerId,
    this.res,
    this.errorMessage,
  });

  static const Object sentinel = Object();

  IpsQuestionnaireState copyWith({
    bool? isLoading,
    bool? isSubmitting,
    Object? bootstrapState = sentinel,
    List<QuestionnaireQuestion>? questions,
    Map<String, String>? answers,
    Object? staticQuestionAnswerId = sentinel,
    Object? res = sentinel,
    Object? errorMessage = sentinel,
  }) {
    return IpsQuestionnaireState(
      isLoading: isLoading ?? this.isLoading,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      bootstrapState: bootstrapState == sentinel
          ? this.bootstrapState
          : bootstrapState as AcntBootstrapState?,
      questions: questions ?? this.questions,
      answers: answers ?? this.answers,
      staticQuestionAnswerId: staticQuestionAnswerId == sentinel
          ? this.staticQuestionAnswerId
          : staticQuestionAnswerId as String?,
      res: res == sentinel ? this.res : res as QuestionnaireRes?,
      errorMessage: errorMessage == sentinel
          ? this.errorMessage
          : errorMessage as String?,
    );
  }
}
