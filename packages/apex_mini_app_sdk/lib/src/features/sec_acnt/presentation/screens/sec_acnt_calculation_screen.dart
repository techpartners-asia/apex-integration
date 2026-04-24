import 'package:flutter/material.dart';
import 'package:mini_app_ui/mini_app_ui.dart';
import 'package:mini_app_sdk/mini_app_sdk.dart';

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
      child: CustomScaffold(
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
          buttonLabel: context.l10n.commonGoHome,
          onPressed: () => routeAfterSecAcntFlow(context, bootstrapState),
          enabled: true,
        ),
      ),
    );
  }
}
