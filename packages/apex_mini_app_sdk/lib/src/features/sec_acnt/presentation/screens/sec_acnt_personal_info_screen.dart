import 'dart:async';

import 'package:flutter/material.dart';
import 'package:apex_mini_app_sdk/apex_mini_app_sdk.dart';

/// Personal and bank information step for securities account onboarding.
class SecAcntPersonalInfoScreen extends StatefulWidget {
  /// Bootstrap data used for short-flow decisions.
  final AcntBootstrapState? bootstrapState;

  /// Repository used to load bank options.
  final SecAcntBankOptionsRepository bankOptionsRepository;

  /// Repository used to resolve account holder names.
  final SecAcntBankAccountLookupRepository bankAccountLookupRepository;

  /// Profile repository used to submit entered personal information.
  final MiniAppProfileRepository appApi;

  /// Current profile used by skip and submission logic.
  final UserEntityDto? currentUser;

  /// Initial form values built from bootstrap/profile data.
  final SecAcntFlowDraft initialDraft;

  /// Creates the personal information screen.
  const SecAcntPersonalInfoScreen({
    super.key,
    required this.bootstrapState,
    required this.bankOptionsRepository,
    required this.bankAccountLookupRepository,
    required this.appApi,
    required this.currentUser,
    required this.initialDraft,
  });

  @override
  State<SecAcntPersonalInfoScreen> createState() =>
      _SecAcntPersonalInfoScreenState();
}

/// Owns form state, validation, bank lookup, and profile submission.
class _SecAcntPersonalInfoScreenState extends State<SecAcntPersonalInfoScreen> {
  /// Form key used to validate personal and bank fields together.
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  /// Primary mobile phone controller.
  late final TextEditingController _mobileController;

  /// Secondary mobile phone controller.
  late final TextEditingController _secondaryMobileController;

  /// Email controller.
  late final TextEditingController _emailController;

  /// IBAN account number controller.
  late final TextEditingController _ibanController;

  /// Service responsible for profile update and account-name lookup.
  late final SecAcntProfileSubmissionService _profileSubmissionService;

  /// Currently selected settlement bank.
  SecAcntBankOption? _selectedBank;

  /// Whether bank options have been warmed once for matching existing data.
  bool _didWarmBankOptions = false;

  /// Whether the bank selector has been touched.
  bool _didTouchBankSelector = false;

  /// Whether a submit attempt should surface validation on every field.
  bool _showAllValidationErrors = false;

  /// Whether initial bank option warming is in progress.
  bool _isWarmingBankOptions = false;

  /// Whether profile submission is in progress.
  bool _isSubmittingProfile = false;

  /// Last profile submission error shown in the form.
  String? _submitErrorMessage;

  /// Whether the current bootstrap state uses the shorter bank-only flow.
  bool get _isShortFlow => isShortSecAcntFlow(widget.bootstrapState);

  /// Whether contact fields can be skipped because profile data is complete.
  bool get _usesBankOnlyShortForm =>
      _isShortFlow && widget.initialDraft.hasCompleteContactInfo;

  @override
  void initState() {
    super.initState();
    _mobileController = TextEditingController(text: widget.initialDraft.mobile);
    _secondaryMobileController = TextEditingController(
      text: widget.initialDraft.secondaryMobile,
    );
    _emailController = TextEditingController(text: widget.initialDraft.email);
    _ibanController = TextEditingController();
    _profileSubmissionService = SecAcntProfileSubmissionService(
      appApi: widget.appApi,
      bankAccountLookupRepository: widget.bankAccountLookupRepository,
      currentUser: widget.currentUser,
    );

    _mobileController.addListener(_refresh);
    _secondaryMobileController.addListener(_refresh);
    _emailController.addListener(_refresh);
    _ibanController.addListener(_refresh);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_didWarmBankOptions) {
      _didWarmBankOptions = true;
      unawaited(_warmBankOptions());
    }
  }

  /// Refreshes validation/error state after form input changes.
  void _refresh() {
    if (!mounted) {
      return;
    }
    setState(() => _submitErrorMessage = null);
  }

  /// Loads bank options once so the selector cache is warm before user interaction.
  Future<void> _warmBankOptions() async {
    if (mounted) {
      setState(() => _isWarmingBankOptions = true);
    }

    try {
      await widget.bankOptionsRepository.getBankOptions();
    } catch (_) {
      // The selector sheet exposes retry states, so the form can stay usable.
    }

    if (!mounted) {
      return;
    }

    setState(() {
      _isWarmingBankOptions = false;
    });
  }

  /// Validates the primary mobile field when contact info is required.
  String? _validateMobile(BuildContext context, String? value) {
    if (_usesBankOnlyShortForm) {
      return null;
    }
    return Validators.combine(<StringValidator>[
      Validators.required(context.l10n),
      Validators.phone(context.l10n),
    ])(value);
  }

  /// Validates the optional secondary mobile field.
  String? _validateSecondaryMobile(BuildContext context, String? value) {
    if (_usesBankOnlyShortForm) {
      return null;
    }
    return Validators.phone(context.l10n, required: false)(value);
  }

  /// Validates the email field when contact info is required.
  String? _validateEmail(BuildContext context, String? value) {
    if (_usesBankOnlyShortForm) {
      return null;
    }
    return Validators.email(context.l10n)(value);
  }

  /// Validates the IBAN field.
  String? _validateIban(BuildContext context, String? value) {
    return Validators.iban(context.l10n)(value);
  }

  /// Validates that a settlement bank has been selected.
  String? _validateSelectedBank(BuildContext context) {
    return Validators.requiredSelection<SecAcntBankOption>(context.l10n)(
      _selectedBank,
    );
  }

  /// Validates only touched fields until the user attempts to continue.
  AutovalidateMode get _autovalidateMode => _showAllValidationErrors
      ? AutovalidateMode.always
      : AutovalidateMode.onUserInteraction;

  /// Returns bank selector error text only after bank interaction or submit.
  String? _bankErrorText(BuildContext context) {
    if (!_didTouchBankSelector && !_showAllValidationErrors) {
      return null;
    }
    return _validateSelectedBank(context);
  }

  /// Returns whether all fields required by the active flow are valid.
  bool _canContinue(BuildContext context) {
    if (_usesBankOnlyShortForm) {
      return _validateIban(context, _ibanController.text) == null &&
          _validateSelectedBank(context) == null;
    }

    return _validateMobile(context, _mobileController.text) == null &&
        _validateSecondaryMobile(context, _secondaryMobileController.text) ==
            null &&
        _validateEmail(context, _emailController.text) == null &&
        _validateIban(context, _ibanController.text) == null &&
        _validateSelectedBank(context) == null;
  }

  /// Opens the bank selector sheet and stores the selected bank.
  Future<void> _selectBank(BuildContext context) async {
    if (mounted) {
      setState(() => _didTouchBankSelector = true);
    }

    final SecAcntBankOption? selected =
        await showModalBottomSheet<SecAcntBankOption>(
          context: context,
          useSafeArea: false,
          backgroundColor: MiniAppStateColors.bottomSheetBackground,
          isScrollControlled: true,
          showDragHandle: false,
          builder: (BuildContext context) {
            return SecAcntBankSelectionSheet(
              selectedBank: _selectedBank,
              bankOptionsRepository: widget.bankOptionsRepository,
            );
          },
        );

    if (selected == null || !mounted) {
      return;
    }

    setState(() {
      _selectedBank = selected;
      _submitErrorMessage = null;
    });
  }

  /// Builds an updated flow draft from current form values.
  SecAcntFlowDraft _buildDraft() {
    return widget.initialDraft.copyWith(
      mobile: _mobileController.text,
      secondaryMobile: _secondaryMobileController.text,
      email: _emailController.text,
      iban: _ibanController.text,
      selectedBank: _selectedBank,
    );
  }

  /// Submits profile data and opens the next onboarding step when successful.
  Future<void> _submitAndOpenNextStep() async {
    setState(() {
      _showAllValidationErrors = true;
      _didTouchBankSelector = true;
    });

    final bool formValid = _formKey.currentState?.validate() ?? false;
    if (!formValid || !_canContinue(context) || _isSubmittingProfile) {
      return;
    }

    final SecAcntFlowDraft draft = _buildDraft();

    setState(() {
      _isSubmittingProfile = true;
      _submitErrorMessage = null;
    });

    try {
      final UserEntityDto updatedUser = await _profileSubmissionService.submit(
        UpdateProfileActionType.updateProfile,
        draft.toPersonalInfoData(),
      );
      if (!mounted) {
        return;
      }
      setState(() => _isSubmittingProfile = false);
      MiniAppToast.showSuccess(
        context,
        message: context.l10n.internalProfileUpdateSuccess,
      );
      await _openNextStep(draft, updatedUser: updatedUser);
    } catch (error) {
      if (!mounted) {
        return;
      }
      setState(() {
        _isSubmittingProfile = false;
        _submitErrorMessage = formatIpsError(error, context.l10n);
      });
      return;
    }
  }

  /// Resolves and opens the next step after personal information is complete.
  Future<void> _openNextStep(
    SecAcntFlowDraft draft, {
    UserEntityDto? updatedUser,
  }) async {
    final UserEntityDto? currentUser = updatedUser ?? widget.currentUser;

    if (widget.bootstrapState?.hasIpsAcnt == true) {
      final bool hasPaidContract = hasPaidSecAcntContract(currentUser);
      if (!hasPaidContract) {
        await Navigator.of(context).push(
          MaterialPageRoute<void>(
            builder: (_) => buildSecAcntFlowStepScreen(
              step: SecAcntFlowStep.payment,
              bootstrapState: widget.bootstrapState,
              draft: draft,
              appApi: widget.appApi,
              currentUser: currentUser,
            ),
          ),
        );
      } else {
        await routeAfterSecAcntFlow(
          context,
          bootstrapState: widget.bootstrapState,
          currentUser: currentUser,
        );
      }
      return;
    }

    // Personal info was just successfully submitted — skip re-checking
    // hasCompletePersonalInfo and resolve only the post-personal-info steps.
    final SecAcntFlowStep? nextStep;
    if (_isShortFlow) {
      nextStep = hasPaidSecAcntContract(currentUser)
          ? null
          : SecAcntFlowStep.payment;
    } else {
      if (!SecAcntLocalPrefs.hasAcceptedSecAgreement) {
        nextStep = SecAcntFlowStep.secAgreement;
      } else if (!hasSavedSecAcntSignature(currentUser)) {
        nextStep = SecAcntFlowStep.signature;
      } else if (!hasPaidSecAcntContract(currentUser)) {
        nextStep = SecAcntFlowStep.payment;
      } else {
        nextStep = null;
      }
    }

    if (nextStep == null) {
      await routeAfterSecAcntFlow(
        context,
        bootstrapState: widget.bootstrapState,
        currentUser: currentUser,
      );
      return;
    }

    await Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => buildSecAcntFlowStepScreen(
          step: nextStep!,
          bootstrapState: widget.bootstrapState,
          draft: draft,
          appApi: widget.appApi,
          currentUser: currentUser,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final responsive = context.responsive;
    final double footerClearance =
        responsive.dp(24) +
        responsive.spacing.buttonHeight +
        4 +
        responsive.safeBottom;
    final SecAcntWizardHeaderData header = buildSecAcntHeader(
      context,
      SecAcntFlowStep.personalInformation,
    );

    final bool canContinue = _canContinue(context);

    return CustomScaffold(
      appBarTitle: header.title,
      appBarCenterTitle: header.centerTitle,
      appBarReserveLeadingSpace: header.reserveLeadingSpace,
      appBarTitleSpacing: header.centerTitle ? null : responsive.dp(20),
      showBackButton: header.showBack,
      showCloseButton: header.showClose,
      onBack: () => Navigator.of(context).maybePop(),
      onDismiss: () => closeMiniAppSafely(context),
      hasSafeArea: false,
      backgroundColor: DesignTokens.softSurface,
      appBarBackgroundColor: DesignTokens.softSurface,
      appBarShowBottomBorder: false,
      appBarTitleStyle: buildSecAcntHeaderTitleStyle(context, header),
      body: _buildBody(context, footerClearance),
      bottomNavigationBar: SecAcntWizardFooter(
        buttonLabel: context.l10n.commonContinue,
        onPressed: _submitAndOpenNextStep,
        enabled: canContinue && !_isSubmittingProfile,
      ),
    );
  }

  /// Builds the form body with loading overlays.
  Widget _buildBody(BuildContext context, double footerClearance) {
    return Stack(
      children: <Widget>[
        _buildScrollableForm(context, footerClearance),
        if (_isWarmingBankOptions)
          BlockingLoadingOverlay(
            title: context.l10n.commonLoading,
            message: context.l10n.secAcntBankSelectionTitle,
          ),
        if (_isSubmittingProfile)
          BlockingLoadingOverlay(
            title: context.l10n.commonLoading,
            message: context.l10n.secAcntProfileUpdating,
          ),
      ],
    );
  }

  /// Builds the scrollable form content above the fixed footer.
  Widget _buildScrollableForm(BuildContext context, double footerClearance) {
    final responsive = context.responsive;

    return SingleChildScrollView(
      padding: EdgeInsets.fromLTRB(
        responsive.dp(20),
        responsive.dp(8),
        responsive.dp(20),
        responsive.dp(20) + footerClearance,
      ),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            SecAcntPersonalInfoStep(
              mobileController: _mobileController,
              secondaryMobileController: _secondaryMobileController,
              emailController: _emailController,
              ibanController: _ibanController,
              selectedBank: _selectedBank,
              onSelectBank: () => _selectBank(context),
              isShortFlow: _usesBankOnlyShortForm,
              autovalidateMode: _autovalidateMode,
              mobileValidator: (String? value) =>
                  _validateMobile(context, value),
              secondaryMobileValidator: (String? value) =>
                  _validateSecondaryMobile(context, value),
              emailValidator: (String? value) => _validateEmail(context, value),
              ibanValidator: (String? value) => _validateIban(context, value),
              bankErrorText: _bankErrorText(context),
            ),
            if (_hasSubmitError)
              _SubmitErrorBanner(message: _submitErrorMessage!),
          ],
        ),
      ),
    );
  }

  /// Whether a non-empty submission error should be shown.
  bool get _hasSubmitError =>
      _submitErrorMessage != null && _submitErrorMessage!.trim().isNotEmpty;

  @override
  void dispose() {
    _mobileController
      ..removeListener(_refresh)
      ..dispose();
    _secondaryMobileController
      ..removeListener(_refresh)
      ..dispose();
    _emailController
      ..removeListener(_refresh)
      ..dispose();
    _ibanController
      ..removeListener(_refresh)
      ..dispose();
    super.dispose();
  }
}

/// Error banner shown after profile submission fails.
class _SubmitErrorBanner extends StatelessWidget {
  /// Error message to display.
  final String message;

  /// Creates a submit error banner.
  const _SubmitErrorBanner({required this.message});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: context.responsive.dp(20)),
      child: NoticeBanner(
        title: context.l10n.errorsActionFailed,
        message: message,
        icon: Icons.error_outline_rounded,
      ),
    );
  }
}
