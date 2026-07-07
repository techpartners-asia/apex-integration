import 'package:apex_mini_app_sdk/apex_mini_app_sdk.dart';
import 'package:flutter/material.dart';

/// Message shown when the securities account opening request is already sent.
const String secAcntPendingOpeningRequestMessage = 'Таны үнэт цаасны данс нээх хүсэлт илгээгдсэн байгаа тул та түр хүлээнэ үү';

/// Closes the securities account flow through the SDK safe-close path.
Future<void> closeSecAcntFlow(BuildContext context) async {
  await closeMiniAppSafely(context);
}

/// Routes to overview after the securities account flow completes.
///
/// Questionnaire is only reachable from the overview page, not automatically
/// after the secAcnt flow.
Future<void> routeAfterSecAcntFlow(
  BuildContext context, {
  required AcntBootstrapState? bootstrapState,
  UserEntityDto? currentUser,
}) async {
  await replaceIpsRoute(
    context,
    route: MiniAppRoutes.overview,
    arguments: bootstrapState,
  );
}

/// Shows the pending-request dialog and closes the mini app from the OK action.
Future<void> showPendingSecAcntOpeningRequestDialog(BuildContext context) async {
  if (!context.mounted) {
    return;
  }

  await showMiniAppDialog<void>(
    context: context,
    barrierDismissible: false,
    title: context.l10n.commonWarning,
    body: const CustomText(
      secAcntPendingOpeningRequestMessage,
      variant: MiniAppTextVariant.body2,
    ),
    actions: <Widget>[
      FilledButton(
        onPressed: () async {
          Navigator.of(context).pop();
          await closeSecAcntFlow(context);
        },
        child: CustomText(
          'OK',
          variant: MiniAppTextVariant.buttonMedium,
          color: Theme.of(context).colorScheme.onPrimary,
        ),
      ),
    ],
  );
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
    SecAcntFlowStep.consent || SecAcntFlowStep.personalInformation || SecAcntFlowStep.terms => throw ArgumentError.value(
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
