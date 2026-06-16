import 'package:apex_mini_app_sdk/apex_mini_app_sdk.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Entry screen for the securities account onboarding nested navigator.
class SecAcntScreen extends StatefulWidget {
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

  @override
  State<SecAcntScreen> createState() => _SecAcntScreenState();
}

class _SecAcntScreenState extends State<SecAcntScreen> {
  bool _prefsLoaded = false;

  @override
  void initState() {
    super.initState();
    _loadPrefs();
  }

  Future<void> _loadPrefs() async {
    await SecAcntLocalPrefs.init();
    if (mounted) setState(() => _prefsLoaded = true);
  }

  /// Chooses the first screen based on bootstrap and profile skip logic.
  Widget _buildInitialScreen() {
    final SecAcntFlowDraft initialDraft = SecAcntFlowDraft.fromBootstrap(
      widget.initialBootstrapState,
      user: widget.currentUser,
    );

    final SecAcntFlowStep? initialStep = resolveInitialSecAcntFlowStep(
      widget.initialBootstrapState,
      currentUser: widget.currentUser,
    );

    if (initialStep == null) {
      return _SecAcntFlowDoneRedirect(bootstrapState: widget.initialBootstrapState);
    }

    return switch (initialStep) {
      SecAcntFlowStep.payment => SecAcntPaymentScreen(
        bootstrapState: widget.initialBootstrapState,
        draft: initialDraft,
        currentUser: widget.currentUser,
        isInitialStep: true,
      ),
      SecAcntFlowStep.calculation => SecAcntCalculationScreen(
        bootstrapState: widget.initialBootstrapState,
      ),
      SecAcntFlowStep.consent => SecAcntConsentScreen(
        bootstrapState: widget.initialBootstrapState,
        bankOptionsRepository: widget.bankOptionsRepository,
        bankAccountLookupRepository: widget.bankAccountLookupRepository,
        appApi: widget.appApi,
        currentUser: widget.currentUser,
        initialDraft: initialDraft,
      ),
      SecAcntFlowStep.personalInformation => SecAcntPersonalInfoScreen(
        bootstrapState: widget.initialBootstrapState,
        bankOptionsRepository: widget.bankOptionsRepository,
        bankAccountLookupRepository: widget.bankAccountLookupRepository,
        appApi: widget.appApi,
        currentUser: widget.currentUser,
        initialDraft: initialDraft,
      ),
      SecAcntFlowStep.secAgreement ||
      SecAcntFlowStep.serviceAgreement => SecAcntAgreementScreen(
        step: initialStep,
        bootstrapState: widget.initialBootstrapState,
        draft: initialDraft,
        appApi: widget.appApi,
        currentUser: widget.currentUser,
      ),
      SecAcntFlowStep.signature => SecAcntSignatureScreen(
        bootstrapState: widget.initialBootstrapState,
        draft: initialDraft,
        appApi: widget.appApi,
        currentUser: widget.currentUser,
      ),
      SecAcntFlowStep.success => SecAcntSuccessScreen(
        bootstrapState: widget.initialBootstrapState,
        draft: initialDraft,
        currentUser: widget.currentUser,
      ),
      _ => SecAcntConsentScreen(
        bootstrapState: widget.initialBootstrapState,
        bankOptionsRepository: widget.bankOptionsRepository,
        bankAccountLookupRepository: widget.bankAccountLookupRepository,
        appApi: widget.appApi,
        currentUser: widget.currentUser,
        initialDraft: initialDraft,
      ),
    };
  }

  @override
  Widget build(BuildContext context) {
    if (!_prefsLoaded) return const SizedBox.shrink();

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: Navigator(
        onGenerateRoute: (_) =>
            MaterialPageRoute<void>(builder: (_) => _buildInitialScreen()),
      ),
    );
  }
}

/// Shown when all sec acnt flow steps are already complete.
///
/// Redirects to overview on the first frame so the user never sees a blank screen.
class _SecAcntFlowDoneRedirect extends StatefulWidget {
  final AcntBootstrapState? bootstrapState;

  const _SecAcntFlowDoneRedirect({required this.bootstrapState});

  @override
  State<_SecAcntFlowDoneRedirect> createState() => _SecAcntFlowDoneRedirectState();
}

class _SecAcntFlowDoneRedirectState extends State<_SecAcntFlowDoneRedirect> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      routeAfterSecAcntFlow(
        context,
        bootstrapState: widget.bootstrapState,
        currentUser: null,
      );
    });
  }

  @override
  Widget build(BuildContext context) => const SizedBox.shrink();
}
