import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mini_app_ui/mini_app_ui.dart';

import '../../../../../shared/l10n/sdk_localizations_x.dart';
import '../../../shared/images/images.dart';
import '../../../shared/presentation/widgets/widgets.dart';
import '../../application/ips_questionnaire_cubit.dart';
import '../../application/ips_questionnaire_state.dart';
import 'questionnaire_question_screen.dart';

class QuestionnaireRecommendationScreen extends StatelessWidget {
  const QuestionnaireRecommendationScreen({super.key});

  void _openFirstQuestion(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => const QuestionnaireQuestionScreen(stepIndex: 0),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return BlocBuilder<IpsQuestionnaireCubit, IpsQuestionnaireState>(
      builder: (BuildContext context, IpsQuestionnaireState state) {
        final bool canContinue = !state.isLoading && state.questions.isNotEmpty;

        return InvestXPageScaffold(
          appBarTitle: l10n.ipsQuestionnaireTitle,
          showCloseButton: false,
          showBackButton: true,
          onBack: () => Navigator.of(context).maybePop(),
          backgroundColor: InvestXDesignTokens.softSurface,
          appBarBackgroundColor: InvestXDesignTokens.softSurface,
          appBarShowBottomBorder: false,
          body: Stack(
            children: <Widget>[
              _QuestionnaireRecommendationView(
                isLoading: state.isLoading,
                errorMessage: state.questions.isEmpty
                    ? state.errorMessage
                    : null,
                onRetry: context.read<IpsQuestionnaireCubit>().load,
              ),
              if (state.isLoading)
                InvestXBlockingLoadingOverlay(
                  title: l10n.commonLoading,
                  message: l10n.ipsQuestionnaireLoading,
                ),
            ],
          ),
          bottomNavigationBar: InvestXBottomActionBar(
            child: InvestXPrimaryButton(
              label: l10n.commonContinue,
              onPressed: canContinue ? () => _openFirstQuestion(context) : null,
            ),
          ),
        );
      },
    );
  }
}

class _QuestionnaireRecommendationView extends StatelessWidget {
  const _QuestionnaireRecommendationView({
    required this.isLoading,
    required this.errorMessage,
    required this.onRetry,
  });

  final bool isLoading;
  final String? errorMessage;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final responsive = context.responsive;
    final l10n = context.l10n;

    return MiniAppSurfaceCard(
      margin: EdgeInsets.all(responsive.dp(AppSpacing.xl)),
      padding: EdgeInsets.zero,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Stack(
            children: <Widget>[
              CustomImage(
                path: Img.card,
                fit: BoxFit.fill,
                height: responsive.dp(250),
                width: responsive.width,
              ),
              Positioned(
                bottom: responsive.dp(45),
                left: responsive.dp(20),
                child: CustomText(
                  l10n.commonBrandInvestx.toUpperCase(),
                  variant: MiniAppTextVariant.titleSmall,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              Positioned(
                bottom: responsive.dp(20),
                left: responsive.dp(20),
                child: CustomText(
                  l10n.investmentFund,
                  variant: MiniAppTextVariant.titleSmall,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.all(responsive.dp(20)),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(
                  l10n.ipsQuestionnaireRecommendationTitle,
                  variant: MiniAppTextVariant.title,
                ),
                SizedBox(height: responsive.dp(8)),
                CustomText(
                  l10n.ipsQuestionnaireRecommendationBody,
                  variant: MiniAppTextVariant.body,
                ),
              ],
            ),
          ),

          if (errorMessage != null &&
              errorMessage!.trim().isNotEmpty) ...<Widget>[
            SizedBox(height: responsive.spacing.sectionSpacing),
            InvestXNoticeBanner(
              title: l10n.errorsActionFailed,
              message: errorMessage!,
              icon: Icons.error_outline_rounded,
            ),
            if (!isLoading) ...<Widget>[
              SizedBox(height: responsive.spacing.inlineSpacing),
              InvestXSecondaryButton(
                label: l10n.commonRetry,
                onPressed: onRetry,
              ),
            ],
          ],
        ],
      ),
    );
  }
}
