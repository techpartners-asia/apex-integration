import 'package:flutter/material.dart';
import 'package:mini_app_sdk/mini_app_sdk.dart';

class OverviewVerificationStep {
  final String title;
  final String subtitle;
  final StepStatus status;
  final VoidCallback? onTap;
  final bool isLast;

  const OverviewVerificationStep({
    required this.title,
    required this.subtitle,
    required this.status,
    this.onTap,
    this.isLast = false,
  });
}

class OverviewVerificationViewModel {
  final String title;
  final String subtitle;
  final int progressCurrent;
  final int progressTotal;
  final List<OverviewVerificationStep> steps;
  final String promoEyebrow;
  final String promoTitle;
  final String promoButtonLabel;
  final VoidCallback? onPromoTap;

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

OverviewVerificationViewModel buildOverviewVerificationViewModel(BuildContext context, AcntBootstrapState state) {
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
      onPromoTap: () => launchIpsRoute(context, route: MiniAppRoutes.secAcnt, arguments: state),
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
