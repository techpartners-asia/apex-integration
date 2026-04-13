import 'package:flutter/material.dart';
import '../widgets/sec_acnt_status_content.dart';
import 'package:mini_app_ui/mini_app_ui.dart';

import '../../../../../shared/l10n/sdk_localizations_x.dart';
import '../../../shared/domain/models/ips_models.dart';
import '../../../shared/presentation/widgets/widgets.dart';
import '../flow/sec_acnt_flow.dart';
import '../flow/sec_acnt_wizard_config.dart';
import '../widgets/sec_acnt_wizard_widgets.dart';
import '../flow/sec_acnt_flow_navigation.dart';

class SecAcntCalculationScreen extends StatelessWidget {
  const SecAcntCalculationScreen({super.key, required this.bootstrapState});

  final AcntBootstrapState? bootstrapState;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final SecAcntWizardHeaderData header = buildSecAcntHeader(
      context,
      SecAcntFlowStep.calculation,
    );

    return PopScope(
      canPop: false,
      child: InvestXPageScaffold(
        appBarTitle: header.title,
        appBarCenterTitle: header.centerTitle,
        appBarReserveLeadingSpace: header.reserveLeadingSpace,
        appBarTitleSpacing: header.centerTitle
            ? null
            : context.responsive.dp(20),
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
          buttonLabel: context.l10n.commonGoHome,
          onPressed: () => routeAfterSecAcntFlow(context, bootstrapState),
          enabled: true,
        ),
      ),
    );
  }
}
