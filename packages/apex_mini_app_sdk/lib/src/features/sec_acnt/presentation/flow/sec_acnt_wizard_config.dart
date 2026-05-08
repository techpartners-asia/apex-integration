import 'package:flutter/material.dart';
import 'package:mini_app_sdk/mini_app_sdk.dart';

SecAcntWizardHeaderData buildSecAcntHeader(
  BuildContext context,
  SecAcntFlowStep currentStep,
) {
  final l10n = context.l10n;

  return switch (currentStep) {
    SecAcntFlowStep.consent => const SecAcntWizardHeaderData(
      title: null,
      showClose: true,
      showBack: false,
      highlightBrand: true,
      bodyTopPadding: 8,
    ),
    SecAcntFlowStep.personalInformation => const SecAcntWizardHeaderData(
      title: null,
      showClose: true,
      highlightBrand: true,
      bodyTopPadding: 8,
    ),
    SecAcntFlowStep.success => const SecAcntWizardHeaderData(
      title: null,
      showClose: true,
      highlightBrand: true,
      centerTitle: false,
      reserveLeadingSpace: false,
      bodyTopPadding: 8,
    ),
    SecAcntFlowStep.serviceAgreement => SecAcntWizardHeaderData(
      title: l10n.ipsContractTitle,
      showBack: true,
      bodyTopPadding: 6,
    ),
    SecAcntFlowStep.secAgreement => const SecAcntWizardHeaderData(
      title: null,
      showClose: true,
      highlightBrand: true,
      bodyTopPadding: 4,
    ),
    SecAcntFlowStep.terms => SecAcntWizardHeaderData(
      title: l10n.ipsContractTermsTitle,
      showBack: true,
      bodyTopPadding: 8,
    ),
    SecAcntFlowStep.signature => SecAcntWizardHeaderData(
      title: l10n.ipsContractTitle,
      showBack: true,
      bodyTopPadding: 4,
    ),
    SecAcntFlowStep.payment => const SecAcntWizardHeaderData(
      title: null,
      showBack: true,
      showClose: true,
      highlightBrand: true,
      bodyTopPadding: 6,
    ),
    SecAcntFlowStep.calculation => const SecAcntWizardHeaderData(
      title: null,
      showClose: true,
      showBack: false,
      highlightBrand: true,
      centerTitle: false,
      reserveLeadingSpace: false,
      bodyTopPadding: 18,
    ),
  };
}

SecAcntWizardFooterData buildSecAcntFooter(
  BuildContext context, {
  required SecAcntFlowStep currentStep,
  required IpsSecAcntState state,
  required bool canContinuePersonalInformation,
  required bool serviceAgreementAccepted,
  required bool secAgreementAccepted,
  required bool hasSignature,
  required double? payableCommission,
  required VoidCallback onPrimaryAction,
}) {
  final l10n = context.l10n;
  final String loadingLabel = l10n.commonLoading;

  return switch (currentStep) {
    SecAcntFlowStep.consent => const SecAcntWizardFooterData.hidden(),
    SecAcntFlowStep.personalInformation => SecAcntWizardFooterData(
      buttonLabel: l10n.commonContinue,
      onPressed: onPrimaryAction,
      enabled: canContinuePersonalInformation,
    ),
    SecAcntFlowStep.success => SecAcntWizardFooterData(
      buttonLabel: l10n.commonContinue,
      onPressed: onPrimaryAction,
    ),
    SecAcntFlowStep.serviceAgreement => SecAcntWizardFooterData(
      buttonLabel: l10n.commonContinue,
      onPressed: onPrimaryAction,
      enabled: serviceAgreementAccepted,
    ),
    SecAcntFlowStep.secAgreement => SecAcntWizardFooterData(
      buttonLabel: l10n.commonContinue,
      onPressed: onPrimaryAction,
      enabled: secAgreementAccepted,
    ),
    SecAcntFlowStep.terms => SecAcntWizardFooterData(
      buttonLabel: l10n.commonContinue,
      onPressed: onPrimaryAction,
    ),
    SecAcntFlowStep.signature => SecAcntWizardFooterData(
      buttonLabel: l10n.commonContinue,
      onPressed: onPrimaryAction,
      enabled: hasSignature,
    ),
    SecAcntFlowStep.payment => SecAcntWizardFooterData(
      buttonLabel: state.isSubmitting ? loadingLabel : l10n.commonPay,
      onPressed: onPrimaryAction,
      enabled:
          !state.isSubmitting &&
          payableCommission != null &&
          payableCommission.isFinite &&
          payableCommission > 0,
    ),
    SecAcntFlowStep.calculation => SecAcntWizardFooterData(
      buttonLabel: l10n.commonGoHome,
      onPressed: onPrimaryAction,
    ),
  };
}

TextStyle? buildSecAcntHeaderTitleStyle(
  BuildContext context,
  SecAcntWizardHeaderData header,
) {
  final Color titleColor = header.highlightBrand
      ? DesignTokens.rose
      : DesignTokens.ink;
  final TextStyle baseStyle = header.highlightBrand
      ? MiniAppTypography.title1
      : MiniAppTypography.subtitle2;

  return baseStyle.copyWith(color: titleColor);
}
