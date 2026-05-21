import 'package:flutter/material.dart';
import 'package:apex_mini_app_sdk/apex_mini_app_sdk.dart';

/// Consent step that starts the securities account onboarding flow.
class SecAcntConsentScreen extends StatelessWidget {
  /// Bootstrap data used to resolve the next step.
  final AcntBootstrapState? bootstrapState;

  /// Repository used if the flow proceeds to personal information.
  final SecAcntBankOptionsRepository bankOptionsRepository;

  /// Repository used if the flow proceeds to personal information.
  final SecAcntBankAccountLookupRepository bankAccountLookupRepository;

  /// Profile repository passed to mutation screens.
  final MiniAppProfileRepository appApi;

  /// Current profile used by skip logic.
  final UserEntityDto? currentUser;

  /// Initial draft built from bootstrap/profile data.
  final SecAcntFlowDraft initialDraft;

  /// Creates the consent screen.
  const SecAcntConsentScreen({
    super.key,
    required this.bootstrapState,
    required this.bankOptionsRepository,
    required this.bankAccountLookupRepository,
    required this.appApi,
    required this.currentUser,
    required this.initialDraft,
  });

  /// Resolves and opens the first actionable step after consent acceptance.
  Future<void> _openNextStep(BuildContext context) async {
    final SecAcntFlowStep? nextStep = resolveNextSecAcntFlowStep(
      SecAcntFlowStep.consent,
      bootstrapState,
      currentUser: currentUser,
    );

    if (nextStep == SecAcntFlowStep.personalInformation) {
      await Navigator.of(context).push(
        MaterialPageRoute<void>(
          builder: (_) => SecAcntPersonalInfoScreen(
            bootstrapState: bootstrapState,
            bankOptionsRepository: bankOptionsRepository,
            bankAccountLookupRepository: bankAccountLookupRepository,
            appApi: appApi,
            currentUser: currentUser,
            initialDraft: initialDraft,
          ),
        ),
      );
      return;
    }

    if (nextStep == null) {
      if (hasPendingSecAcntOpeningRequest(bootstrapState)) {
        await showPendingSecAcntOpeningRequestDialog(context);
      }
      return;
    }

    await pushSecAcntFlowStep(
      context,
      step: nextStep,
      bootstrapState: bootstrapState,
      draft: initialDraft,
      appApi: appApi,
      currentUser: currentUser,
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final responsive = context.responsive;

    final SecAcntWizardHeaderData header = buildSecAcntHeader(
      context,
      SecAcntFlowStep.consent,
    );

    return CustomScaffold(
      appBarTitle: header.title,
      appBarCenterTitle: header.centerTitle,
      appBarReserveLeadingSpace: header.reserveLeadingSpace,
      appBarTitleSpacing: header.centerTitle ? null : context.responsive.dp(20),
      showBackButton: header.showBack,
      showCloseButton: header.showClose,
      onBack: () => Navigator.of(context).maybePop(),
      onClose: () => closeSecAcntFlow(context),
      hasSafeArea: false,
      backgroundColor: DesignTokens.softSurface,
      appBarBackgroundColor: DesignTokens.softSurface,
      appBarShowBottomBorder: false,
      appBarTitleStyle: buildSecAcntHeaderTitleStyle(context, header),
      body: Padding(
        padding: EdgeInsets.all(responsive.dp(AppSpacing.xl)),
        child: Column(
          children: <Widget>[
            // SecAcntStepIndicator(
            //   currentStep: SecAcntFlowStep.consent,
            //   bootstrapState: bootstrapState,
            // ),
            Expanded(
              child: Center(
                child: ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: responsive.dp(290)),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      CustomImage(
                        path: Img.insurance,
                        width: responsive.dp(120),
                        height: responsive.dp(120),
                      ),
                      SizedBox(height: responsive.dp(20)),
                      CustomText(
                        l10n.tinoConsent,
                        textAlign: TextAlign.center,
                        variant: MiniAppTextVariant.subtitle2,
                        color: DesignTokens.ink,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Row(
              children: <Widget>[
                Expanded(
                  child: SecondaryButton(
                    label: l10n.reject,
                    onPressed: () => closeSecAcntFlow(context),
                    backgroundColor: Colors.white.withValues(alpha: 0.72),
                    boxShadow: DesignTokens.cardShadow,
                  ),
                ),
                SizedBox(width: responsive.dp(16)),
                Expanded(
                  child: PrimaryButton(
                    label: l10n.accept,
                    onPressed: () => _openNextStep(context),
                  ),
                ),
              ],
            ),

            SizedBox(height: responsive.dp(20)),
          ],
        ),
      ),
    );
  }
}
