import 'package:apex_mini_app_sdk/apex_mini_app_sdk.dart';
import 'package:flutter/material.dart';

/// One row in the overview onboarding/verification checklist.
class OverviewVerificationStep {
  /// Step title.
  final String title;

  /// Step subtitle.
  final String subtitle;

  /// Current visual status.
  final StepStatus status;

  /// Optional action when the step is tapped.
  final VoidCallback? onTap;

  /// Whether this is the final step in the checklist.
  final bool isLast;

  /// Creates a verification step.
  const OverviewVerificationStep({
    required this.title,
    required this.subtitle,
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

/// Builds the onboarding checklist model from account bootstrap state.
OverviewVerificationViewModel buildOverviewVerificationViewModel(
  BuildContext context,
  AcntBootstrapState state,
) {
  final l10n = context.l10n;

  if (!state.hasAcnt) {
    return OverviewVerificationViewModel(
      title: l10n.ipsOverviewVerificationTitle,
      subtitle: l10n.ipsOverviewVerificationSubtitle,
      progressCurrent: 0,
      progressTotal: 3,
      steps: <OverviewVerificationStep>[
        OverviewVerificationStep(
          title: l10n.ipsOverviewProfileMenuPersonalInfo,
          subtitle: l10n.ipsOverviewProfilePersonalInfoMissing,
          status: StepStatus.active,
          onTap: () => launchIpsRoute(context, route: MiniAppRoutes.personalInfo),
        ),
        OverviewVerificationStep(
          title: l10n.ipsAcntOpenAcnt,
          subtitle: l10n.ipsAcntFlowBody,
          status: StepStatus.upcoming,
        ),
        OverviewVerificationStep(
          title: l10n.ipsOverviewFinalStepLabel,
          subtitle: l10n.ipsQuestionnaireViewPacks,
          status: StepStatus.upcoming,
          isLast: true,
        ),
      ],
      promoEyebrow: l10n.ipsOverviewProfileMenuPackInfo,
      promoTitle: l10n.ipsOverviewFirstPackTitle,
      promoButtonLabel: l10n.commonContinue,
      onPromoTap: () => launchIpsRoute(context, route: MiniAppRoutes.personalInfo),
    );
  }

  if (!state.hasOpenSecAcnt) {
    return OverviewVerificationViewModel(
      title: l10n.ipsOverviewVerificationTitle,
      subtitle: l10n.ipsOverviewVerificationSubtitle,
      progressCurrent: 1,
      progressTotal: 3,
      steps: <OverviewVerificationStep>[
        OverviewVerificationStep(
          title: l10n.ipsOverviewProfileMenuPersonalInfo,
          subtitle: l10n.ipsOverviewProfileVerified,
          status: StepStatus.completed,
        ),
        OverviewVerificationStep(
          title: l10n.ipsAcntVerifyAcnt,
          subtitle: l10n.ipsAcntFlowBody,
          status: StepStatus.active,
          onTap: () => launchIpsRoute(context, route: MiniAppRoutes.secAcnt),
        ),
        OverviewVerificationStep(
          title: l10n.ipsOverviewFinalStepLabel,
          subtitle: l10n.ipsQuestionnaireViewPacks,
          status: StepStatus.upcoming,
          isLast: true,
        ),
      ],
      promoEyebrow: l10n.ipsOverviewActionTitle,
      promoTitle: l10n.ipsAcntOpenAcnt,
      promoButtonLabel: l10n.commonContinue,
      onPromoTap: () => launchIpsRoute(
        context,
        route: MiniAppRoutes.secAcnt,
        arguments: state,
      ),
    );
  }

  return OverviewVerificationViewModel(
    title: l10n.ipsOverviewVerificationTitle,
    subtitle: l10n.ipsOverviewVerificationSubtitle,
    progressCurrent: 2,
    progressTotal: 3,
    steps: <OverviewVerificationStep>[
      OverviewVerificationStep(
        title: l10n.ipsOverviewProfileMenuPersonalInfo,
        subtitle: l10n.ipsOverviewProfileVerified,
        status: StepStatus.completed,
      ),
      OverviewVerificationStep(
        title: l10n.ipsAcntVerifyAcnt,
        subtitle: l10n.ipsAcntHasAcnt,
        status: StepStatus.completed,
      ),
      OverviewVerificationStep(
        title: l10n.ipsQuestionnaireTitle,
        subtitle: l10n.ipsQuestionnaireSubtitle,
        status: StepStatus.active,
        onTap: () => launchIpsRoute(context, route: MiniAppRoutes.questionnaire),
        isLast: true,
      ),
    ],
    promoEyebrow: l10n.ipsOverviewProfileMenuPackInfo,
    promoTitle: l10n.ipsHomeRecommendedPackCta,
    promoButtonLabel: l10n.commonContinue,
    onPromoTap: () => launchIpsRoute(context, route: MiniAppRoutes.questionnaire),
  );
}
