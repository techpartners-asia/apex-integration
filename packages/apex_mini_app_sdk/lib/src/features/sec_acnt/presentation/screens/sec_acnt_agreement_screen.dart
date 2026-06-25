import 'package:flutter/material.dart';
import 'package:apex_mini_app_sdk/apex_mini_app_sdk.dart';

/// Agreement step for service or securities account terms.
class SecAcntAgreementScreen extends StatefulWidget {
  /// Creates an agreement screen for a supported agreement step.
  const SecAcntAgreementScreen({
    super.key,
    required this.step,
    required this.bootstrapState,
    required this.draft,
    this.appApi,
    this.currentUser,
  }) : assert(
         step == SecAcntFlowStep.serviceAgreement ||
             step == SecAcntFlowStep.secAgreement,
       );

  /// Agreement step being displayed.
  final SecAcntFlowStep step;

  /// Bootstrap data used for agreement copy and next-step resolution.
  final AcntBootstrapState? bootstrapState;

  /// Draft personal/bank data carried through the flow.
  final SecAcntFlowDraft draft;

  /// Profile repository required by later signature/profile steps.
  final MiniAppProfileRepository? appApi;

  /// Current profile used by skip logic.
  final UserEntityDto? currentUser;

  @override
  State<SecAcntAgreementScreen> createState() => _SecAcntAgreementScreenState();
}

/// Tracks agreement consent and routes to the next onboarding step.
class _SecAcntAgreementScreenState extends State<SecAcntAgreementScreen> {
  /// Whether the user has accepted the displayed agreement.
  bool _accepted = false;

  /// Opens the next screen for service or securities agreement completion.
  Future<void> _openNextStep() async {
    final SecAcntFlowStep? nextStep = resolveNextSecAcntFlowStep(
      SecAcntFlowStep.secAgreement,
      widget.bootstrapState,
      currentUser: widget.currentUser,
    );

    if (widget.step == SecAcntFlowStep.secAgreement) {
      await SecAcntLocalPrefs.markSecAgreementAccepted();
    }

    if (nextStep == null) {
      await routeAfterSecAcntFlow(
        context,
        bootstrapState: widget.bootstrapState,
        currentUser: widget.currentUser,
      );
      return;
    }

    await pushSecAcntFlowStep(
      context,
      step: nextStep,
      bootstrapState: widget.bootstrapState,
      draft: widget.draft,
      appApi: widget.appApi,
      currentUser: widget.currentUser,
    );
  }

  @override
  Widget build(BuildContext context) {
    final SecAcntWizardHeaderData header = buildSecAcntHeader(
      context,
      widget.step,
    );
    final String title = widget.step == SecAcntFlowStep.serviceAgreement
        ? context.l10n.secAcntInvestxAgreementTitle
        : context.l10n.secAcntSecuritiesAgreementTitle;
    final String agreementText = widget.step == SecAcntFlowStep.serviceAgreement
        ? widget.bootstrapState?.introIps ??
              context.l10n.secAcntInvestxAgreementText
        : widget.bootstrapState?.intro ??
              context.l10n.secAcntSecuritiesAgreementText;

    return AgreementScreen(
      appBarTitle: header.title,
      appBarCenterTitle: header.centerTitle,
      appBarReserveLeadingSpace: header.reserveLeadingSpace,
      appBarTitleSpacing: header.centerTitle ? null : context.responsive.dp(20),
      appBarTitleStyle: buildSecAcntHeaderTitleStyle(context, header),
      showBackButton: header.showBack,
      showCloseButton: header.showClose,
      onBack: () => Navigator.of(context).maybePop(),
      onDismiss: () => closeSecAcntFlow(context),
      hasSafeArea: false,
      title: title,
      body: AgreementHtmlBody(agreementText: agreementText),
      consentLabel: context.l10n.secAcntAgreementConsent,
      accepted: _accepted,
      onAcceptedChanged: (bool value) => setState(() => _accepted = value),
      continueLabel: context.l10n.commonContinue,
      onContinue: _openNextStep,
    );
  }
}
