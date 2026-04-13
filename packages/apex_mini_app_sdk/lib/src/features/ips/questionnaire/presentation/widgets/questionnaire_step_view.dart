import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mini_app_sdk/l10n/sdk_localizations.dart';
import 'package:mini_app_ui/mini_app_ui.dart';

import '../../../../../shared/l10n/sdk_localizations_x.dart';
import '../../../shared/domain/models/ips_models.dart';
import '../../../shared/presentation/widgets/widgets.dart';
import '../../application/ips_questionnaire_cubit.dart';
import '../../application/ips_questionnaire_state.dart';

class QuestionnaireStepView extends StatelessWidget {
  final int currentIndex;
  final IpsQuestionnaireState state;
  final int totalSteps;

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
    final bool isStaticQuestion = currentIndex == state.questions.length;
    final QuestionnaireQuestion? question = isStaticQuestion ? null : state.questions[currentIndex];
    final List<_QuestionnaireChoice> options = isStaticQuestion
        ? _buildStaticQuestionChoices(l10n)
        : question!.options
              .asMap()
              .entries
              .map(
                (MapEntry<int, QuestionnaireOption> entry) => _QuestionnaireChoice(
                  id: entry.value.id,
                  label: entry.value.label.trim().isEmpty ? l10n.ipsQuestionnaireOptionPrefix(entry.key + 1) : entry.value.label,
                  number: entry.key + 1,
                ),
              )
              .toList(growable: false);
    final String? selectedOptionId = isStaticQuestion ? state.staticQuestionAnswerId : state.answers[question!.id];
    final String questionTitle = isStaticQuestion
        ? l10n.ipsQuestionnaireStaticQuestionTitle
        : question!.title.trim().isEmpty
        ? l10n.ipsQuestionnaireQuestionPrefix(currentIndex + 1)
        : question.title;
    final String? subtitle = isStaticQuestion
        ? null
        : question!.subtitle?.trim().isEmpty ?? true
        ? null
        : question.subtitle?.trim();

    return SingleChildScrollView(
      padding: EdgeInsets.all(responsive.dp(AppSpacing.xl)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          InvestXProgressSegments(total: totalSteps, activeIndex: currentIndex),
          SizedBox(height: responsive.spacing.sectionSpacing),

          /// Question
          CustomText(questionTitle, variant: MiniAppTextVariant.headline),

          /// Sub question
          if (subtitle != null) ...<Widget>[
            SizedBox(height: responsive.spacing.inlineSpacing),
            CustomText(
              subtitle,
              variant: MiniAppTextVariant.body,
              color: InvestXDesignTokens.muted,
              height: 1.45,
            ),
          ],

          /// Answers
          SizedBox(height: responsive.spacing.sectionSpacing),
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
                  if (isStaticQuestion) {
                    context.read<IpsQuestionnaireCubit>().selectStaticQuestionAnswer(option.id);
                    return;
                  }

                  context.read<IpsQuestionnaireCubit>().selectAnswer(
                    questionId: question!.id,
                    optionId: option.id,
                  );
                },
              ),
            ),
          ),
          if (state.errorMessage != null && state.errorMessage!.trim().isNotEmpty) ...<Widget>[
            SizedBox(height: responsive.spacing.sectionSpacing),
            InvestXNoticeBanner(
              title: l10n.errorsActionFailed,
              message: state.errorMessage!,
              icon: Icons.error_outline_rounded,
            ),
          ],
        ],
      ),
    );
  }
}

class _QuestionnaireChoice {
  const _QuestionnaireChoice({
    required this.id,
    required this.label,
    required this.number,
  });

  final String id;
  final String label;
  final int number;
}

List<_QuestionnaireChoice> _buildStaticQuestionChoices(SdkLocalizations l10n) {
  return <_QuestionnaireChoice>[
    _QuestionnaireChoice(
      id: 'ui_static_100000',
      label: l10n.ipsQuestionnaireStaticOption100k,
      number: 1,
    ),
    _QuestionnaireChoice(
      id: 'ui_static_200000',
      label: l10n.ipsQuestionnaireStaticOption200k,
      number: 2,
    ),
    _QuestionnaireChoice(
      id: 'ui_static_500000',
      label: l10n.ipsQuestionnaireStaticOption500k,
      number: 3,
    ),
    _QuestionnaireChoice(
      id: 'ui_static_1000000_plus',
      label: l10n.ipsQuestionnaireStaticOption1000000Plus,
      number: 4,
    ),
  ];
}

class _QuestionnaireOptionTile extends StatelessWidget {
  final String label;
  final int number;
  final bool selected;
  final VoidCallback onTap;

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
            gradient: selected ? InvestXDesignTokens.primaryGradient : null,
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
                        variant: MiniAppTextVariant.body,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: selected ? InvestXDesignTokens.rose : InvestXDesignTokens.ink,
                          fontWeight: MiniAppTypography.semiBold,
                          height: 1.25,
                        ),
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

class _QuestionnaireRadioIndicator extends StatelessWidget {
  final bool selected;

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
          color: selected ? InvestXDesignTokens.coral : InvestXDesignTokens.selectionBlueMuted.withValues(alpha: 0.55),
          width: responsive.dp(selected ? 1.6 : 1.3),
        ),
        color: Colors.white,
      ),
      child: DecoratedBox(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          // color: selected ? InvestXDesignTokens.coral : Colors.transparent,
          gradient: selected ? InvestXDesignTokens.primaryGradient : null,
        ),
      ),
    );
  }
}
