import 'package:apex_mini_app_sdk/apex_mini_app_sdk.dart';
import 'package:flutter/material.dart';

/// Closes the securities account flow through the SDK safe-close path.
Future<void> closeSecAcntFlow(BuildContext context) async {
  await closeMiniAppSafely(context);
}

/// Routes to the next mini-app destination after account onboarding ends.
Future<void> routeAfterSecAcntFlow(
  BuildContext context,
  AcntBootstrapState? state,
) async {
  final bool shouldOpenQuestionnaire =
      state != null && state.hasAcnt && !state.hasIpsAcnt;
  final String nextRoute = shouldOpenQuestionnaire
      ? MiniAppRoutes.questionnaire
      : MiniAppRoutes.overview;

  await replaceIpsRoute(context, route: nextRoute, arguments: state);
}

/// Builds a screen for post-consent/post-personal-info onboarding steps.
Widget buildSecAcntFlowStepScreen({
  required SecAcntFlowStep step,
  required AcntBootstrapState? bootstrapState,
  required SecAcntFlowDraft draft,
  required MiniAppProfileRepository? appApi,
  UserEntityDto? currentUser,
}) {
  return switch (step) {
    SecAcntFlowStep.success => SecAcntSuccessScreen(
      bootstrapState: bootstrapState,
      draft: draft,
      currentUser: currentUser,
    ),
    SecAcntFlowStep.serviceAgreement => SecAcntAgreementScreen(
      step: SecAcntFlowStep.serviceAgreement,
      bootstrapState: bootstrapState,
      draft: draft,
      appApi: appApi,
      currentUser: currentUser,
    ),
    SecAcntFlowStep.secAgreement => SecAcntAgreementScreen(
      step: SecAcntFlowStep.secAgreement,
      bootstrapState: bootstrapState,
      draft: draft,
      appApi: appApi,
      currentUser: currentUser,
    ),
    SecAcntFlowStep.signature => SecAcntSignatureScreen(
      bootstrapState: bootstrapState,
      draft: draft,
      appApi: appApi!,
      currentUser: currentUser,
    ),
    SecAcntFlowStep.payment => SecAcntPaymentScreen(
      bootstrapState: bootstrapState,
      draft: draft,
      currentUser: currentUser,
    ),
    SecAcntFlowStep.calculation => SecAcntCalculationScreen(
      bootstrapState: bootstrapState,
    ),
    SecAcntFlowStep.consent ||
    SecAcntFlowStep.personalInformation ||
    SecAcntFlowStep.terms => throw ArgumentError.value(
      step,
      'step',
      'Only post-consent/post-personal-information steps can be built here.',
    ),
  };
}

/// Pushes the next securities account step on the nested onboarding navigator.
Future<void> pushSecAcntFlowStep(
  BuildContext context, {
  required SecAcntFlowStep step,
  required AcntBootstrapState? bootstrapState,
  required SecAcntFlowDraft draft,
  required MiniAppProfileRepository? appApi,
  UserEntityDto? currentUser,
}) async {
  await Navigator.of(context).push(
    MaterialPageRoute<void>(
      builder: (_) => buildSecAcntFlowStepScreen(
        step: step,
        bootstrapState: bootstrapState,
        draft: draft,
        appApi: appApi,
        currentUser: currentUser,
      ),
    ),
  );
}
