import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mini_app_ui/mini_app_ui.dart';
import 'package:mini_app_sdk/mini_app_sdk.dart';

class QuestionnaireQuestionScreen extends StatefulWidget {
  const QuestionnaireQuestionScreen({super.key, required this.stepIndex});

  final int stepIndex;

  @override
  State<QuestionnaireQuestionScreen> createState() =>
      _QuestionnaireQuestionScreenState();
}

class _QuestionnaireQuestionScreenState
    extends State<QuestionnaireQuestionScreen> {
  late int _currentStepIndex = widget.stepIndex;

  bool _hasCurrentAnswer(IpsQuestionnaireState state) {
    if (_currentStepIndex < 0 || _currentStepIndex >= state.questions.length) {
      return false;
    }

    return state.answers[state.questions[_currentStepIndex].id] != null;
  }

  Future<void> _goNext(IpsQuestionnaireState state) async {
    final QuestionnaireQuestion currentQuestion =
        state.questions[_currentStepIndex];
    final bool shouldSaveGoal = currentQuestion.isGoal;
    if (shouldSaveGoal) {
      final bool saved = await context
          .read<IpsQuestionnaireCubit>()
          .saveSelectedTargetGoal(questionId: currentQuestion.id);
      if (!mounted || !saved) {
        return;
      }
    }

    final int totalSteps = state.questions.length;
    if (_currentStepIndex >= totalSteps - 1) {
      Navigator.of(context).push(
        MaterialPageRoute<void>(
          builder: (_) => const QuestionnaireCalculationScreen(),
        ),
      );
      return;
    }

    setState(() => _currentStepIndex += 1);
  }

  Future<bool> _handleBack() async {
    if (_currentStepIndex > widget.stepIndex) {
      setState(() => _currentStepIndex -= 1);
      return false;
    }

    return true;
  }

  Future<void> _handleBackPressed() async {
    if (await _handleBack() && mounted) {
      Navigator.of(context).maybePop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return PopScope<void>(
      canPop: _currentStepIndex == widget.stepIndex,
      onPopInvokedWithResult: (bool didPop, void _) {
        if (didPop || _currentStepIndex <= widget.stepIndex) {
          return;
        }
        setState(() => _currentStepIndex -= 1);
      },
      child: BlocBuilder<IpsQuestionnaireCubit, IpsQuestionnaireState>(
        builder: (BuildContext context, IpsQuestionnaireState state) {
          if (state.isLoading && state.questions.isEmpty) {
            return CustomScaffold(
              appBarTitle: l10n.ipsQuestionnaireTitle,
              showCloseButton: false,
              showBackButton: true,
              onBack: _handleBackPressed,
              backgroundColor: DesignTokens.softSurface,
              appBarBackgroundColor: DesignTokens.softSurface,
              appBarShowBottomBorder: false,
              body: Center(
                child: Padding(
                  padding: EdgeInsets.all(AppSpacing.xl),
                  child: MiniAppLoadingState(
                    title: l10n.commonLoading,
                    message: l10n.ipsQuestionnaireLoading,
                  ),
                ),
              ),
            );
          }

          if (state.errorMessage != null && state.questions.isEmpty) {
            return CustomScaffold(
              appBarTitle: l10n.ipsQuestionnaireTitle,
              showCloseButton: false,
              showBackButton: true,
              onBack: _handleBackPressed,
              backgroundColor: DesignTokens.softSurface,
              appBarBackgroundColor: DesignTokens.softSurface,
              appBarShowBottomBorder: false,
              body: Center(
                child: Padding(
                  padding: EdgeInsets.all(AppSpacing.xl),
                  child: MiniAppErrorState(
                    title: l10n.errorsActionFailed,
                    message: state.errorMessage!,
                    retryLabel: l10n.commonRetry,
                    onRetry: context.read<IpsQuestionnaireCubit>().load,
                  ),
                ),
              ),
            );
          }

          if (state.questions.isEmpty) {
            return CustomScaffold(
              appBarTitle: l10n.ipsQuestionnaireTitle,
              showCloseButton: false,
              showBackButton: true,
              onBack: _handleBackPressed,
              backgroundColor: DesignTokens.softSurface,
              appBarBackgroundColor: DesignTokens.softSurface,
              appBarShowBottomBorder: false,
              body: Center(
                child: Padding(
                  padding: EdgeInsets.all(AppSpacing.xl),
                  child: MiniAppEmptyState(
                    title: l10n.ipsQuestionnaireTitle,
                    message: l10n.commonNoData,
                  ),
                ),
              ),
            );
          }

          final int totalSteps = state.questions.length;
          final bool isLastStep = _currentStepIndex == totalSteps - 1;

          return CustomScaffold(
            appBarTitle: l10n.ipsQuestionnaireTitle,
            showCloseButton: false,
            showBackButton: true,
            onBack: _handleBackPressed,
            backgroundColor: DesignTokens.softSurface,
            appBarBackgroundColor: DesignTokens.softSurface,
            appBarShowBottomBorder: false,
            body: Stack(
              children: <Widget>[
                KeyedSubtree(
                  key: ValueKey<int>(_currentStepIndex),
                  child: QuestionnaireStepView(
                    currentIndex: _currentStepIndex,
                    state: state,
                    totalSteps: totalSteps,
                  ),
                ),
                if (state.isLoading || state.isSavingTargetGoal)
                  BlockingLoadingOverlay(
                    title: l10n.commonLoading,
                    message: state.isSavingTargetGoal
                        ? l10n.commonLoading
                        : l10n.ipsQuestionnaireLoading,
                  ),
              ],
            ),
            bottomNavigationBar: BottomActionBar(
              child: PrimaryButton(
                label: isLastStep
                    ? l10n.ipsQuestionnaireViewPacks
                    : l10n.commonContinue,
                onPressed: _hasCurrentAnswer(state) && !state.isSavingTargetGoal
                    ? () => _goNext(state)
                    : null,
              ),
            ),
          );
        },
      ),
    );
  }
}
