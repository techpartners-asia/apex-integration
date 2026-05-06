import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mini_app_sdk/mini_app_sdk.dart';

class IpsQuestionnaireCubit extends Cubit<IpsQuestionnaireState> {
  final QuestionnaireService service;
  final MiniAppProfileRepository appApi;
  final InvestmentBootstrapService? bootstrapService;
  final AcntBootstrapState? initialBootstrapState;
  final SdkLocalizations l10n;

  IpsQuestionnaireCubit({
    required this.service,
    required this.appApi,
    required this.l10n,
    this.bootstrapService,
    this.initialBootstrapState,
  }) : super(IpsQuestionnaireState(bootstrapState: initialBootstrapState));

  Future<void> load() async {
    emit(
      state.copyWith(
        isLoading: true,
        errorMessage: null,
        bootstrapState: state.bootstrapState ?? initialBootstrapState,
      ),
    );

    try {
      final AcntBootstrapState bootstrapState = state.bootstrapState ?? initialBootstrapState ?? await BootstrapStateResolver(service: bootstrapService!).load();
      final List<QuestionnaireQuestion> questions = await service.getQuestions();

      emit(
        state.copyWith(
          isLoading: false,
          bootstrapState: bootstrapState,
          questions: questions,
          answers: const <String, String>{},
          res: null,
          errorMessage: null,
        ),
      );
    } catch (error) {
      emit(
        state.copyWith(
          isLoading: false,
          errorMessage: formatIpsError(error, l10n),
        ),
      );
    }
  }

  void selectAnswer({required String questionId, required String optionId}) {
    final Map<String, String> nextAnswers = Map<String, String>.from(state.answers)..[questionId] = optionId;
    emit(state.copyWith(answers: nextAnswers, errorMessage: null));
  }

  Future<bool> saveSelectedTargetGoal({required String questionId}) async {
    if (state.isSavingTargetGoal) {
      return false;
    }

    final int? selectedGoalId = int.tryParse(state.answers[questionId] ?? '');
    if (selectedGoalId == null) {
      emit(
        state.copyWith(
          errorMessage: l10n.ipsQuestionnaireTargetGoalMissing,
        ),
      );
      return false;
    }

    emit(
      state.copyWith(
        isSavingTargetGoal: true,
        errorMessage: null,
      ),
    );

    try {
      await appApi.updateTargetGoal(UpdateTargetGoalApiReq(goalId: selectedGoalId));
      emit(
        state.copyWith(
          isSavingTargetGoal: false,
          errorMessage: null,
        ),
      );
      return true;
    } catch (error) {
      emit(
        state.copyWith(
          isSavingTargetGoal: false,
          errorMessage: formatIpsError(error, l10n),
        ),
      );
      return false;
    }
  }

  Future<void> submit() async {
    if (state.isSubmitting) return;

    emit(state.copyWith(isSubmitting: true, errorMessage: null));

    try {
      final List<QuestionnaireAnswer> answers = state.questions
          .where((el) => !el.isGoal)
          .map(
            (QuestionnaireQuestion question) => QuestionnaireAnswer(
              questionId: question.id,
              optionId: state.answers[question.id] ?? '',
            ),
          )
          .where((QuestionnaireAnswer answer) => answer.optionId.isNotEmpty)
          .toList(growable: false);
      final QuestionnaireRes res = await service.calculateScore(answers);

      emit(state.copyWith(isSubmitting: false, res: res, errorMessage: null));
    } catch (error) {
      emit(
        state.copyWith(
          isSubmitting: false,
          errorMessage: formatIpsError(error, l10n),
        ),
      );
    }
  }
}
