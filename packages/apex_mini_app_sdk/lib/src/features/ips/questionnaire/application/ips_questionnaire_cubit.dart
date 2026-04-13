import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../app/investx_api/backend/mini_app_api_repository.dart';
import '../../../../app/investx_api/req/update_target_goal_api_req.dart';
import 'package:mini_app_sdk/l10n/sdk_localizations.dart';

import '../../shared/application/bootstrap_state_resolver.dart';
import '../../shared/domain/services/investment_services.dart';
import '../../shared/presentation/helpers/ips_error_formatter.dart';
import 'questionnaire_target_goal_mapper.dart';
import 'ips_questionnaire_state.dart';

class IpsQuestionnaireCubit extends Cubit<IpsQuestionnaireState> {
  final QuestionnaireService service;
  final MiniAppApiRepository appApi;
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
      final AcntBootstrapState bootstrapState =
          state.bootstrapState ??
          initialBootstrapState ??
          await BootstrapStateResolver(service: bootstrapService!).load();
      final List<QuestionnaireQuestion> questions = await service
          .getQuestions();

      emit(
        state.copyWith(
          isLoading: false,
          bootstrapState: bootstrapState,
          questions: questions,
          answers: const <String, String>{},
          staticQuestionAnswerId: null,
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
    final Map<String, String> nextAnswers = Map<String, String>.from(
      state.answers,
    )..[questionId] = optionId;
    emit(state.copyWith(answers: nextAnswers, errorMessage: null));
  }

  void selectStaticQuestionAnswer(String optionId) {
    emit(state.copyWith(staticQuestionAnswerId: optionId, errorMessage: null));
  }

  Future<void> submit() async {
    if (state.isSubmitting) return;

    emit(state.copyWith(isSubmitting: true, errorMessage: null));

    try {
      final List<QuestionnaireAnswer> answers = state.questions
          .map(
            (QuestionnaireQuestion question) => QuestionnaireAnswer(
              questionId: question.id,
              optionId: state.answers[question.id] ?? '',
            ),
          )
          .where((QuestionnaireAnswer answer) => answer.optionId.isNotEmpty)
          .toList(growable: false);
      final QuestionnaireRes res = await service.calculateScore(answers);
      final num? targetGoal = resolveQuestionnaireTargetGoal(
        state.staticQuestionAnswerId,
      );
      if (targetGoal == null) {
        throw StateError(l10n.ipsQuestionnaireTargetGoalMissing);
      }
      await appApi.updateTargetGoal(
        UpdateTargetGoalApiReq(targetGoal: targetGoal),
      );

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
