import 'package:flutter/material.dart';
import 'package:mini_app_ui/mini_app_ui.dart';
import 'package:mini_app_sdk/mini_app_sdk.dart';

class SecAcntConsentScreen extends StatelessWidget {
  final AcntBootstrapState? bootstrapState;
  final SecAcntBankOptionsRepository bankOptionsRepository;
  final SecAcntBankAccountLookupRepository bankAccountLookupRepository;
  final MiniAppApiRepository appApi;
  final UserEntityDto? currentUser;
  final SecAcntFlowDraft initialDraft;

  const SecAcntConsentScreen({
    super.key,
    required this.bootstrapState,
    required this.bankOptionsRepository,
    required this.bankAccountLookupRepository,
    required this.appApi,
    required this.currentUser,
    required this.initialDraft,
  });

  void _openPersonalInfo(BuildContext context) {
    Navigator.of(context).push(
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
                      Text(
                        l10n.tinoConsent,
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(
                              color: DesignTokens.ink,
                              fontWeight: MiniAppTypography.bold,
                              height: 1.3,
                            ),
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
                    onPressed: () => _openPersonalInfo(context),
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
