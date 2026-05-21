import 'dart:async';

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
    if (hasPendingSecAcntOpeningRequest(initialBootstrapState)) {
      return const _SecAcntPendingRequestGate();
    }

    final SecAcntFlowDraft initialDraft = SecAcntFlowDraft.fromBootstrap(
      initialBootstrapState,
      user: currentUser,
    );

    final SecAcntFlowStep? initialStep = resolveInitialSecAcntFlowStep(
      initialBootstrapState,
      currentUser: currentUser,
    );

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
      null => const _SecAcntPendingRequestGate(),
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

class _SecAcntPendingRequestGate extends StatefulWidget {
  const _SecAcntPendingRequestGate();

  @override
  State<_SecAcntPendingRequestGate> createState() =>
      _SecAcntPendingRequestGateState();
}

class _SecAcntPendingRequestGateState
    extends State<_SecAcntPendingRequestGate> {
  bool _didShowDialog = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || _didShowDialog) {
        return;
      }
      _didShowDialog = true;
      unawaited(showPendingSecAcntOpeningRequestDialog(context));
    });
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      hasAppBar: false,
      backgroundColor: DesignTokens.softSurface,
      body: Center(
        child: MiniAppLoadingState(
          title: context.l10n.commonLoading,
          message: secAcntPendingOpeningRequestMessage,
        ),
      ),
    );
  }
}
