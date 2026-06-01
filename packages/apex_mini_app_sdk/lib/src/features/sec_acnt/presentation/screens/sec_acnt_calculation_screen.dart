import 'package:flutter/material.dart';
import 'package:apex_mini_app_sdk/apex_mini_app_sdk.dart';

/// Final pending/calculation screen after securities account submission.
class SecAcntCalculationScreen extends StatelessWidget {
  /// Creates the calculation screen.
  const SecAcntCalculationScreen({super.key, required this.bootstrapState});

  /// Bootstrap state passed through to overview after this step.
  final AcntBootstrapState? bootstrapState;

  Future<void> _goToOverview(BuildContext context) {
    return replaceIpsRoute(
      context,
      route: MiniAppRoutes.overview,
      arguments: bootstrapState,
    );
  }

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
          onPressed: () => _goToOverview(context),
          enabled: true,
        ),
      ),
    );
  }
}
