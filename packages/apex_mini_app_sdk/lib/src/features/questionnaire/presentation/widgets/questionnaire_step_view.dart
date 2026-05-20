import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:apex_mini_app_sdk/apex_mini_app_sdk.dart';

/// Renders one questionnaire question and its selectable answer options.
class QuestionnaireStepView extends StatelessWidget {
  /// Current question index.
  final int currentIndex;

  /// Questionnaire state containing questions, answers, and errors.
  final IpsQuestionnaireState state;

  /// Total number of questionnaire steps.
  final int totalSteps;

  /// Creates a questionnaire step view.
  const QuestionnaireStepView({
    super.key,
    required this.currentIndex,
    required this.state,
    required this.totalSteps,
  });

  @override
  Widget build(BuildContext context) {
    final responsive = context.responsive;
    final l10n = context.l10n;
    final QuestionnaireQuestion question = state.questions[currentIndex];
    final bool isGoalQuestion = question.isGoal;
    final List<_QuestionnaireChoice> options = question.options
        .asMap()
        .entries
        .map(
          (MapEntry<int, QuestionnaireOption> entry) => _QuestionnaireChoice(
            id: entry.value.id,
            label: _resolveOptionLabel(
              question,
              entry.value,
              entry.key + 1,
              l10n,
            ),
            number: entry.key + 1,
          ),
        )
        .toList(growable: false);
    final String? selectedOptionId = state.answers[question.id];
    final String questionTitle = question.title.trim().isEmpty
        ? l10n.ipsQuestionnaireQuestionPrefix(currentIndex + 1)
        : question.title;
    final String? subtitle = question.subtitle?.trim().isEmpty ?? true
        ? null
        : question.subtitle?.trim();
    final String? visibleErrorMessage = state.errorMessage;

    return SingleChildScrollView(
      padding: EdgeInsets.all(responsive.dp(AppSpacing.xl)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          ProgressSegments(total: totalSteps, activeIndex: currentIndex),
          SizedBox(height: responsive.spacing.sectionSpacing),

          /// Question
          CustomText(questionTitle, variant: MiniAppTextVariant.title1),

          /// Sub question
          if (subtitle != null) ...<Widget>[
            SizedBox(height: responsive.spacing.inlineSpacing),
            CustomText(
              subtitle,
              variant: MiniAppTextVariant.body3,
              color: DesignTokens.muted,
              height: 1.45,
            ),
          ],

          /// Answers
          SizedBox(height: responsive.spacing.sectionSpacing),
          if (options.isEmpty && isGoalQuestion)
            MiniAppEmptyState(
              title: questionTitle,
              message: visibleErrorMessage ?? l10n.commonNoData,
            )
          else
            ...options.map(
              (_QuestionnaireChoice option) => Padding(
                padding: EdgeInsets.only(
                  bottom: responsive.spacing.inlineSpacing,
                ),
                child: _QuestionnaireOptionTile(
                  label: option.label,
                  number: option.number,
                  selected: selectedOptionId == option.id,
                  onTap: () {
                    context.read<IpsQuestionnaireCubit>().selectAnswer(
                      questionId: question.id,
                      optionId: option.id,
                    );
                  },
                ),
              ),
            ),
          if (options.isNotEmpty &&
              visibleErrorMessage != null &&
              visibleErrorMessage.trim().isNotEmpty) ...<Widget>[
            SizedBox(height: responsive.spacing.sectionSpacing),
            NoticeBanner(
              title: l10n.errorsActionFailed,
              message: visibleErrorMessage,
              icon: Icons.error_outline_rounded,
            ),
          ],
        ],
      ),
    );
  }
}

/// View model for one rendered questionnaire option.
class _QuestionnaireChoice {
  /// Backend option identifier.
  final String id;

  /// Display label resolved from backend text, amount, or fallback copy.
  final String label;

  /// One-based visual option number.
  final int number;

  /// Creates a questionnaire choice view model.
  const _QuestionnaireChoice({
    required this.id,
    required this.label,
    required this.number,
  });
}

/// Resolves the text shown for an option tile.
String _resolveOptionLabel(
  QuestionnaireQuestion question,
  QuestionnaireOption option,
  int index,
  SdkLocalizations l10n,
) {
  if (question.isGoal && option.amount != null) {
    return formatIpsPaymentAmount(option.amount!, IpsDefaults.defaultCurrency);
  }

  if (option.label.trim().isNotEmpty) {
    return option.label;
  }

  return l10n.ipsQuestionnaireOptionPrefix(index);
}

/// Selectable answer row for one questionnaire option.
class _QuestionnaireOptionTile extends StatelessWidget {
  /// Display label for the option.
  final String label;

  /// One-based option number.
  final int number;

  /// Whether this option is currently selected.
  final bool selected;

  /// Called when the user taps the option.
  final VoidCallback onTap;

  /// Creates a questionnaire option tile.
  const _QuestionnaireOptionTile({
    required this.label,
    required this.number,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final responsive = context.responsive;
    final BorderRadius radius = BorderRadius.circular(responsive.radius(18));

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: radius,
        child: Ink(
          decoration: BoxDecoration(
            gradient: selected ? DesignTokens.primaryGradient : null,
            color: selected ? null : Colors.white,
            borderRadius: radius,
          ),
          child: Padding(
            padding: EdgeInsets.all(selected ? 1.3 : 0),
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: selected ? const Color(0xFFFFF5F8) : Colors.white,
                borderRadius: radius,
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: responsive.spacing.financialCardSpacing,
                  vertical: responsive.spacing.inlineSpacing * 1.05,
                ),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: CustomText(
                        '$number. $label',
                        variant: MiniAppTextVariant.subtitle3,
                        color: selected ? DesignTokens.rose : DesignTokens.ink,
                      ),
                    ),
                    SizedBox(width: responsive.spacing.inlineSpacing),
                    _QuestionnaireRadioIndicator(selected: selected),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Circular radio indicator used by [_QuestionnaireOptionTile].
class _QuestionnaireRadioIndicator extends StatelessWidget {
  /// Whether the indicator should show selected styling.
  final bool selected;

  /// Creates a questionnaire radio indicator.
  const _QuestionnaireRadioIndicator({required this.selected});

  @override
  Widget build(BuildContext context) {
    final responsive = context.responsive;
    final double size = responsive.dp(20);

    return Container(
      width: size,
      height: size,
      padding: EdgeInsets.all(responsive.dp(4)),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: selected
              ? DesignTokens.coral
              : DesignTokens.selectionBlueMuted.withValues(alpha: 0.55),
          width: responsive.dp(selected ? 1.6 : 1.3),
        ),
        color: Colors.white,
      ),
      child: DecoratedBox(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          // color: selected ? DesignTokens.coral : Colors.transparent,
          gradient: selected ? DesignTokens.primaryGradient : null,
        ),
      ),
    );
  }
}
