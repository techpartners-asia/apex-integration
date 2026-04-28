import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mini_app_sdk/mini_app_sdk.dart';

class SecAcntScreen extends StatelessWidget {
  final AcntBootstrapState? initialBootstrapState;
  final SecAcntBankOptionsRepository bankOptionsRepository;
  final SecAcntBankAccountLookupRepository bankAccountLookupRepository;
  final MiniAppProfileRepository appApi;
  final UserEntityDto? currentUser;

  const SecAcntScreen({
    super.key,
    this.initialBootstrapState,
    required this.bankOptionsRepository,
    required this.bankAccountLookupRepository,
    required this.appApi,
    required this.currentUser,
  });

  Widget _buildInitialScreen() {
    final SecAcntFlowDraft initialDraft = SecAcntFlowDraft.fromBootstrap(
      initialBootstrapState,
      user: currentUser,
    );

    return switch (resolveInitialSecAcntFlowStep(initialBootstrapState)) {
      SecAcntFlowStep.payment => SecAcntPaymentScreen(
        bootstrapState: initialBootstrapState,
        draft: initialDraft,
        isInitialStep: true,
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
