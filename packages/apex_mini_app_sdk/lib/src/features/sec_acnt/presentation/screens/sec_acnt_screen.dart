import 'package:apex_mini_app_sdk/apex_mini_app_sdk.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Entry screen for the securities account onboarding nested navigator.
class SecAcntScreen extends StatelessWidget {
  /// Bootstrap data fetched before opening the flow.
  final AcntBootstrapState? initialBootstrapState;

  /// Repository used by personal info screens to list banks.
  final SecAcntBankOptionsRepository bankOptionsRepository;

  /// Repository used to resolve account holder names.
  final SecAcntBankAccountLookupRepository bankAccountLookupRepository;

  /// Profile repository used for profile/signature mutations.
  final MiniAppProfileRepository appApi;

  /// Current profile used by skip logic.
  final UserEntityDto? currentUser;

  /// Creates the securities account flow entry.
  const SecAcntScreen({
    super.key,
    this.initialBootstrapState,
    required this.bankOptionsRepository,
    required this.bankAccountLookupRepository,
    required this.appApi,
    required this.currentUser,
  });

  /// Chooses the first screen based on bootstrap and profile skip logic.
  Widget _buildInitialScreen() {
    final SecAcntFlowDraft initialDraft = SecAcntFlowDraft.fromBootstrap(
      initialBootstrapState,
      user: currentUser,
    );

    final SecAcntFlowStep? initialStep = resolveInitialSecAcntFlowStep(
      initialBootstrapState,
      currentUser: currentUser,
    );

    if (initialStep == null) {
      return SecAcntCalculationScreen(bootstrapState: initialBootstrapState);
    }

    return switch (initialStep) {
      SecAcntFlowStep.payment => SecAcntPaymentScreen(
        bootstrapState: initialBootstrapState,
        draft: initialDraft,
        currentUser: currentUser,
        isInitialStep: true,
      ),
      SecAcntFlowStep.calculation => SecAcntCalculationScreen(
        bootstrapState: initialBootstrapState,
      ),
      SecAcntFlowStep.consent => SecAcntConsentScreen(
        bootstrapState: initialBootstrapState,
        bankOptionsRepository: bankOptionsRepository,
        bankAccountLookupRepository: bankAccountLookupRepository,
        appApi: appApi,
        currentUser: currentUser,
        initialDraft: initialDraft,
      ),
      SecAcntFlowStep.personalInformation => SecAcntPersonalInfoScreen(
        bootstrapState: initialBootstrapState,
        bankOptionsRepository: bankOptionsRepository,
        bankAccountLookupRepository: bankAccountLookupRepository,
        appApi: appApi,
        currentUser: currentUser,
        initialDraft: initialDraft,
      ),
      SecAcntFlowStep.secAgreement ||
      SecAcntFlowStep.serviceAgreement => SecAcntAgreementScreen(
        step: initialStep,
        bootstrapState: initialBootstrapState,
        draft: initialDraft,
        appApi: appApi,
        currentUser: currentUser,
      ),
      SecAcntFlowStep.signature => SecAcntSignatureScreen(
        bootstrapState: initialBootstrapState,
        draft: initialDraft,
        appApi: appApi,
        currentUser: currentUser,
      ),
      SecAcntFlowStep.success => SecAcntSuccessScreen(
        bootstrapState: initialBootstrapState,
        draft: initialDraft,
        currentUser: currentUser,
      ),
      _ => SecAcntConsentScreen(
        bootstrapState: initialBootstrapState,
        bankOptionsRepository: bankOptionsRepository,
        bankAccountLookupRepository: bankAccountLookupRepository,
        appApi: appApi,
        currentUser: currentUser,
        initialDraft: initialDraft,
      ),
    };
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: Navigator(
        onGenerateRoute: (_) =>
            MaterialPageRoute<void>(builder: (_) => _buildInitialScreen()),
      ),
    );
  }
}
