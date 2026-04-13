import 'package:flutter/material.dart';
import '../../../../../app/investx_api/backend/mini_app_api_repository.dart';
import 'package:mini_app_ui/mini_app_ui.dart';

import '../../../../../shared/l10n/sdk_localizations_x.dart';
import '../../../shared/domain/models/ips_models.dart';
import '../../../shared/presentation/screens/investx_agreement_screen.dart';
import '../flow/sec_acnt_flow.dart';
import '../flow/sec_acnt_wizard_config.dart';
import '../widgets/sec_acnt_step_indicator.dart';
import '../widgets/sec_acnt_wizard_widgets.dart';
import '../flow/sec_acnt_flow_navigation.dart';
import 'sec_acnt_signature_screen.dart';

class SecAcntAgreementScreen extends StatefulWidget {
  const SecAcntAgreementScreen({
    super.key,
    required this.step,
    required this.bootstrapState,
    required this.draft,
    this.appApi,
  }) : assert(
         step == SecAcntFlowStep.serviceAgreement ||
             step == SecAcntFlowStep.secAgreement,
       );

  final SecAcntFlowStep step;
  final AcntBootstrapState? bootstrapState;
  final SecAcntFlowDraft draft;
  final MiniAppApiRepository? appApi;

  @override
  State<SecAcntAgreementScreen> createState() => _SecAcntAgreementScreenState();
}

class _SecAcntAgreementScreenState extends State<SecAcntAgreementScreen> {
  bool _accepted = false;

  Future<void> _openNextStep() async {
    if (widget.step == SecAcntFlowStep.serviceAgreement) {
      await routeAfterSecAcntFlow(context, widget.bootstrapState);
      return;
    }

    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => SecAcntSignatureScreen(
          bootstrapState: widget.bootstrapState,
          draft: widget.draft,
          appApi: widget.appApi!,
        ),
      ),
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

    return InvestXAgreementScreen(
      appBarTitle: header.title,
      appBarCenterTitle: header.centerTitle,
      appBarReserveLeadingSpace: header.reserveLeadingSpace,
      appBarTitleSpacing: header.centerTitle ? null : context.responsive.dp(20),
      appBarTitleStyle: buildSecAcntHeaderTitleStyle(context, header),
      showBackButton: header.showBack,
      showCloseButton: header.showClose,
      onBack: () => Navigator.of(context).maybePop(),
      onClose: () => closeSecAcntFlow(context),
      hasSafeArea: false,
      headerWidget: Padding(
        padding: EdgeInsets.symmetric(horizontal: context.responsive.dp(16)),
        child: SecAcntStepIndicator(
          currentStep: widget.step,
          bootstrapState: widget.bootstrapState,
        ),
      ),
      title: title,
      body: InvestXAgreementHtmlBody(agreementText: agreementText),
      consentLabel: context.l10n.secAcntAgreementConsent,
      accepted: _accepted,
      onAcceptedChanged: (bool value) => setState(() => _accepted = value),
      continueLabel: context.l10n.commonContinue,
      onContinue: _openNextStep,
    );
  }
}
