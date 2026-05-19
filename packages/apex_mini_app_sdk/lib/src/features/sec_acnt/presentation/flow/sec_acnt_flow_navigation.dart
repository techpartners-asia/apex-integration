import 'package:flutter/material.dart';
import 'package:apex_mini_app_sdk/apex_mini_app_sdk_internal.dart';

Future<void> closeSecAcntFlow(BuildContext context) async {
  await Navigator.of(context, rootNavigator: true).maybePop();
}

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
