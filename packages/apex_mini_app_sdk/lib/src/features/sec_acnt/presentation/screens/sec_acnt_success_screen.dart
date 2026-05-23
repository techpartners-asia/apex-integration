import 'package:flutter/material.dart';
import 'package:apex_mini_app_sdk/apex_mini_app_sdk.dart';

/// Short-flow success screen shown before the service agreement.
class SecAcntSuccessScreen extends StatelessWidget {
  /// Creates the success screen.
  const SecAcntSuccessScreen({
    super.key,
    required this.bootstrapState,
    required this.draft,
    this.currentUser,
  });

  /// Bootstrap data carried through the flow.
  final AcntBootstrapState? bootstrapState;

  /// Draft personal/bank data carried to later steps.
  final SecAcntFlowDraft draft;

  /// Current profile used by skip logic.
  final UserEntityDto? currentUser;

  /// Opens the next required short-flow step.
  Future<void> _openNextStep(BuildContext context) async {
    final SecAcntFlowStep? nextStep = resolveNextSecAcntFlowStep(
      SecAcntFlowStep.success,
      bootstrapState,
      currentUser: currentUser,
    );
    if (nextStep == null) {
      await routeAfterSecAcntFlow(context, bootstrapState);
      return;
    }
    if (nextStep != SecAcntFlowStep.serviceAgreement) {
      await routeAfterSecAcntFlow(context, bootstrapState);
      return;
    }

    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => SecAcntAgreementScreen(
          step: SecAcntFlowStep.serviceAgreement,
          bootstrapState: bootstrapState,
          draft: draft,
          currentUser: currentUser,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final SecAcntWizardHeaderData header = buildSecAcntHeader(
      context,
      SecAcntFlowStep.success,
    );

    return CustomScaffold(
      appBarTitle: header.title,
      appBarCenterTitle: header.centerTitle,
      appBarReserveLeadingSpace: header.reserveLeadingSpace,
      appBarTitleSpacing: header.centerTitle ? null : context.responsive.dp(20),
      showBackButton: header.showBack,
      showCloseButton: header.showClose,
      onBack: () => Navigator.of(context).maybePop(),
      onDismiss: () => closeSecAcntFlow(context),
      hasSafeArea: false,
      backgroundColor: DesignTokens.softSurface,
      appBarBackgroundColor: DesignTokens.softSurface,
      appBarShowBottomBorder: false,
      appBarTitleStyle: buildSecAcntHeaderTitleStyle(context, header),
      body: SecAcntStatusContent(
        title: l10n.secAcntCalculationTitle,
        cardTitle: l10n.secAcntCalculationMessageTitle,
        message: context.l10n.secAcntCalculationPendingMessage,
      ),
      bottomNavigationBar: SecAcntWizardFooter(
        buttonLabel: context.l10n.commonContinue,
        onPressed: () => _openNextStep(context),
        enabled: true,
      ),
    );
  }
}
