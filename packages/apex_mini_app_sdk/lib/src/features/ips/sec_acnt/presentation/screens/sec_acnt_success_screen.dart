import 'package:flutter/material.dart';
import '../widgets/sec_acnt_status_content.dart';
import 'package:mini_app_ui/mini_app_ui.dart';

import '../../../../../shared/l10n/sdk_localizations_x.dart';
import '../../../shared/domain/models/ips_models.dart';
import '../../../shared/presentation/widgets/widgets.dart';
import '../flow/sec_acnt_flow.dart';
import '../flow/sec_acnt_wizard_config.dart';
import '../widgets/sec_acnt_wizard_widgets.dart';
import 'sec_acnt_agreement_screen.dart';
import '../flow/sec_acnt_flow_navigation.dart';

class SecAcntSuccessScreen extends StatelessWidget {
  const SecAcntSuccessScreen({
    super.key,
    required this.bootstrapState,
    required this.draft,
  });

  final AcntBootstrapState? bootstrapState;
  final SecAcntFlowDraft draft;

  void _openNextStep(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => SecAcntAgreementScreen(
          step: SecAcntFlowStep.serviceAgreement,
          bootstrapState: bootstrapState,
          draft: draft,
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

    return InvestXPageScaffold(
      appBarTitle: header.title,
      appBarCenterTitle: header.centerTitle,
      appBarReserveLeadingSpace: header.reserveLeadingSpace,
      appBarTitleSpacing: header.centerTitle ? null : context.responsive.dp(20),
      showBackButton: header.showBack,
      showCloseButton: header.showClose,
      onBack: () => Navigator.of(context).maybePop(),
      onClose: () => closeSecAcntFlow(context),
      hasSafeArea: false,
      backgroundColor: InvestXDesignTokens.softSurface,
      appBarBackgroundColor: InvestXDesignTokens.softSurface,
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
