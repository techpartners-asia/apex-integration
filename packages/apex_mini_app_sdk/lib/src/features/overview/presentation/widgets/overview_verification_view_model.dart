import 'package:apex_mini_app_sdk/apex_mini_app_sdk.dart';
import 'package:flutter/material.dart';

/// One row in the overview onboarding/verification checklist.
class OverviewVerificationStep {
  /// Step title.
  final String title;

  /// Step subtitle.
  final String? subtitle;

  /// Current visual status.
  final StepStatus status;

  /// Optional action when the step is tapped.
  final VoidCallback? onTap;

  /// Whether this is the final step in the checklist.
  final bool isLast;

  /// Creates a verification step.
  const OverviewVerificationStep({
    required this.title,
    this.subtitle,
    required this.status,
    this.onTap,
    this.isLast = false,
  });
}

/// View model consumed by [OverviewVerificationCard].
class OverviewVerificationViewModel {
  /// Card title.
  final String title;

  /// Card subtitle.
  final String subtitle;

  /// Current progress numerator.
  final int progressCurrent;

  /// Total progress denominator.
  final int progressTotal;

  /// Timeline/checklist rows.
  final List<OverviewVerificationStep> steps;

  /// Eyebrow text for the promo card.
  final String promoEyebrow;

  /// Title text for the promo card.
  final String promoTitle;

  /// Button label for the promo card.
  final String promoButtonLabel;

  /// Optional promo action.
  final VoidCallback? onPromoTap;

  /// Creates a verification card view model.
  const OverviewVerificationViewModel({
    required this.title,
    required this.subtitle,
    required this.progressCurrent,
    required this.progressTotal,
    required this.steps,
    required this.promoEyebrow,
    required this.promoTitle,
    required this.promoButtonLabel,
    this.onPromoTap,
  });
}

void _launchSecAcntFlow(
  BuildContext context,
  AcntBootstrapState state,
) {
  launchIpsRoute(
    context,
    route: MiniAppRoutes.secAcnt,
    arguments: state,
  );
}

void _launchQuestionnaire(
  BuildContext context, {
  AcntBootstrapState? state,
}) {
  launchIpsRoute(
    context,
    route: MiniAppRoutes.questionnaire,
    arguments: state,
  );
}

/// Opens securities onboarding or questionnaire depending on account state.
void _launchSecAcntOrQuestionnaire(
  BuildContext context,
  AcntBootstrapState state,
) {
  if (state.canContinueToQuestionnaireFromOverview && !state.hasIpsAcnt) {
    _launchQuestionnaire(context, state: state);
    return;
  }

  _launchSecAcntFlow(context, state);
}

/// Builds the onboarding checklist model from account bootstrap state.
OverviewVerificationViewModel buildOverviewVerificationViewModel(
  BuildContext context,
  AcntBootstrapState state, {
  bool hasPaidSecAcntContract = false,
  bool isQuestionnaireCompleted = false,
}) {
  final l10n = context.l10n;

  if (!state.hasAcnt || state.secAcntStatusCode == AcntBootstrapState.secAcntStatusUnpaid) {
    final bool contractPaid = hasPaidSecAcntContract;

    return OverviewVerificationViewModel(
      title: l10n.ipsOverviewVerificationTitle,
      subtitle: l10n.ipsOverviewVerificationSubtitle,
      progressCurrent: contractPaid ? 1 : 0,
      progressTotal: 4,
      steps: <OverviewVerificationStep>[
        OverviewVerificationStep(
          title: l10n.ipsAcntOpenAcnt,
          subtitle: contractPaid
              ? l10n.ipsOverviewProfileVerified
              : l10n.ipsOverviewProfilePersonalInfoMissing,
          status: contractPaid ? StepStatus.completed : StepStatus.active,
          onTap: contractPaid
              ? null
              : () => _launchSecAcntFlow(context, state),
        ),
        OverviewVerificationStep(
          title: l10n.secAcntInvestxAgreementTitle,
          status: StepStatus.upcoming,
        ),
        OverviewVerificationStep(
        title: l10n.ipsQuestionnaireProfileTitle,
        status: StepStatus.upcoming,
        ),
        OverviewVerificationStep(
          title: l10n.ipsOverviewFinalStepLabel,
          subtitle: l10n.ipsQuestionnaireViewPacks,
          status: StepStatus.upcoming,
          isLast: true,
        ),
      ],
      promoEyebrow: contractPaid
          ? l10n.ipsOverviewActionTitle
          : l10n.ipsOverviewProfileMenuPackInfo,
      promoTitle: contractPaid
          ? l10n.ipsAcntOpenAcnt
          : l10n.ipsOverviewFirstPackTitle,
      promoButtonLabel: l10n.commonContinue,
      onPromoTap: () => contractPaid
          ? _launchSecAcntFlow(context, state)
          : null,
    );
  }

  if (!state.hasIpsAcnt) {
    final bool isAwaitingActivation = hasPaidSecAcntContract;

    return OverviewVerificationViewModel(
      title: l10n.ipsOverviewVerificationTitle,
      subtitle: l10n.ipsOverviewVerificationSubtitle,
      progressCurrent: isQuestionnaireCompleted ? 3 : QuestionnaireLocalPrefs.hasCompletedAgreementAndSignature ? 2 : 1,
      progressTotal: 4,
      steps: <OverviewVerificationStep>[
        OverviewVerificationStep(
          title: l10n.ipsAcntOpenAcnt,
          subtitle: l10n.ipsOverviewProfileVerified,
          status: StepStatus.completed,
        ),
        OverviewVerificationStep(
          title: l10n.secAcntInvestxAgreementTitle,
          status: QuestionnaireLocalPrefs.hasCompletedAgreementAndSignature
              ? StepStatus.completed
              : StepStatus.active,
          onTap: QuestionnaireLocalPrefs.hasCompletedAgreementAndSignature
              ? null
              : () => _launchQuestionnaire(context, state: state),
        ),
        OverviewVerificationStep(
          title: l10n.ipsQuestionnaireProfileTitle,
          status: isQuestionnaireCompleted
                  ? StepStatus.completed
                  : StepStatus.active,
          onTap: !isQuestionnaireCompleted
              ? () => _launchQuestionnaire(context, state: state)
              : null,
        ),
        OverviewVerificationStep(
          title: l10n.ipsQuestionnaireTitle,
          subtitle: l10n.ipsQuestionnaireSubtitle,
          status: isQuestionnaireCompleted
              ? StepStatus.active
              : StepStatus.upcoming,
          onTap: isQuestionnaireCompleted
              ? () => _launchQuestionnaire(context, state: state)
              : null,
          isLast: true,
        ),
      ],
      promoEyebrow: l10n.ipsOverviewActionTitle,
      promoTitle: isQuestionnaireCompleted
          ? l10n.ipsHomeRecommendedPackCta
          : l10n.ipsAcntOpenAcnt,
      promoButtonLabel: l10n.commonContinue,
      onPromoTap: (isAwaitingActivation && !isQuestionnaireCompleted) ? null : () => _launchSecAcntOrQuestionnaire(context, state),
    );
  }

  return OverviewVerificationViewModel(
    title: l10n.ipsOverviewVerificationTitle,
    subtitle: l10n.ipsOverviewVerificationSubtitle,
    progressCurrent: 3,
    progressTotal: 4,
    steps: <OverviewVerificationStep>[
      OverviewVerificationStep(
        title: l10n.ipsAcntOpenAcnt,
        subtitle: l10n.ipsAcntHasAcnt,
        status: StepStatus.completed,
      ),
      OverviewVerificationStep(
        title: l10n.secAcntInvestxAgreementTitle,
        status: StepStatus.completed,
      ),
       OverviewVerificationStep(
        title: l10n.ipsQuestionnaireProfileTitle,
        status: StepStatus.completed,
      ),
      OverviewVerificationStep(
        title: l10n.ipsQuestionnaireTitle,
        subtitle: l10n.ipsQuestionnaireSubtitle,
        status: StepStatus.active,
        onTap: () => _launchQuestionnaire(context, state: state),
        isLast: true,
      ),
    ],
    promoEyebrow: l10n.ipsOverviewProfileMenuPackInfo,
    promoTitle: l10n.ipsHomeRecommendedPackCta,
    promoButtonLabel: l10n.commonContinue,
    onPromoTap: () => _launchQuestionnaire(context, state: state),
  );
}
