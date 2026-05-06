import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mini_app_ui/mini_app_ui.dart';
import 'package:mini_app_sdk/mini_app_sdk.dart';

class SecAcntPersonalInfoScreen extends StatefulWidget {
  final AcntBootstrapState? bootstrapState;
  final SecAcntBankOptionsRepository bankOptionsRepository;
  final SecAcntBankAccountLookupRepository bankAccountLookupRepository;
  final MiniAppProfileRepository appApi;
  final UserEntityDto? currentUser;
  final SecAcntFlowDraft initialDraft;

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
  State<SecAcntPersonalInfoScreen> createState() => _SecAcntPersonalInfoScreenState();
}

class _SecAcntPersonalInfoScreenState extends State<SecAcntPersonalInfoScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  late final TextEditingController _mobileController;
  late final TextEditingController _secondaryMobileController;
  late final TextEditingController _emailController;
  late final TextEditingController _ibanController;
  late final SecAcntProfileSubmissionService _profileSubmissionService;

  SecAcntBankOption? _selectedBank;
  bool _didWarmBankOptions = false;
  bool _didInteractWithPersonalInfo = false;
  bool _didTouchBankSelector = false;
  bool _isWarmingBankOptions = false;
  bool _isSubmittingProfile = false;
  String? _submitErrorMessage;

  bool get _isShortFlow => isShortSecAcntFlow(widget.bootstrapState);

  @override
  void initState() {
    super.initState();
    _mobileController = TextEditingController(text: widget.initialDraft.mobile);
    _secondaryMobileController = TextEditingController(
      text: widget.initialDraft.secondaryMobile,
    );
    _emailController = TextEditingController(text: widget.initialDraft.email);
    _ibanController = TextEditingController(text: widget.initialDraft.iban);
    _selectedBank = widget.initialDraft.selectedBank;
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

  void _refresh() {
    if (!mounted) {
      return;
    }
    setState(() {
      _didInteractWithPersonalInfo = true;
      _submitErrorMessage = null;
    });
  }

  Future<void> _warmBankOptions() async {
    if (mounted) {
      setState(() => _isWarmingBankOptions = true);
    }

    List<SecAcntBankOption> bankOptions = const <SecAcntBankOption>[];
    try {
      bankOptions = await widget.bankOptionsRepository.getBankOptions();
    } catch (_) {
      // The selector sheet exposes retry states, so the form can stay usable.
    }

    if (!mounted) {
      return;
    }

    final SecAcntBankOption? matchedBank = _matchBankOption(
      bankOptions: bankOptions,
      bankCode: _selectedBank?.id,
      bankName: _selectedBank?.label,
    );

    setState(() {
      if (matchedBank != null) {
        _selectedBank = matchedBank;
      }
      _isWarmingBankOptions = false;
    });
  }

  SecAcntBankOption? _matchBankOption({
    required List<SecAcntBankOption> bankOptions,
    String? bankCode,
    String? bankName,
  }) {
    for (final SecAcntBankOption option in bankOptions) {
      if (bankCode != null && option.id.trim() == bankCode.trim()) {
        return option;
      }
      if (bankName != null && option.label.trim().toLowerCase() == bankName.trim().toLowerCase()) {
        return option;
      }
    }
    return null;
  }

  String? _validateMobile(BuildContext context, String? value) {
    if (_isShortFlow) {
      return null;
    }
    return Validators.combine(<StringValidator>[
      Validators.required(context.l10n),
      Validators.phone(context.l10n),
    ])(value);
  }

  String? _validateSecondaryMobile(BuildContext context, String? value) {
    return Validators.phone(context.l10n, required: false)(value);
  }

  String? _validateEmail(BuildContext context, String? value) {
    if (_isShortFlow) {
      return null;
    }
    return Validators.email(context.l10n)(value);
  }

  String? _validateIban(BuildContext context, String? value) {
    return Validators.iban(context.l10n)(value);
  }

  String? _validateSelectedBank(BuildContext context) {
    return Validators.requiredSelection<SecAcntBankOption>(context.l10n)(
      _selectedBank,
    );
  }

  AutovalidateMode get _autovalidateMode => _didInteractWithPersonalInfo ? AutovalidateMode.always : AutovalidateMode.disabled;

  String? _bankErrorText(BuildContext context) {
    if (!_didInteractWithPersonalInfo && !_didTouchBankSelector) {
      return null;
    }
    return _validateSelectedBank(context);
  }

  bool _canContinue(BuildContext context) {
    return _validateMobile(context, _mobileController.text) == null &&
        _validateSecondaryMobile(context, _secondaryMobileController.text) == null &&
        _validateEmail(context, _emailController.text) == null &&
        _validateIban(context, _ibanController.text) == null &&
        _validateSelectedBank(context) == null;
  }

  Future<void> _selectBank(BuildContext context) async {
    if (mounted) {
      setState(() => _didTouchBankSelector = true);
    }

    final SecAcntBankOption? selected = await showModalBottomSheet<SecAcntBankOption>(
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

  SecAcntFlowDraft _buildDraft() {
    return widget.initialDraft.copyWith(
      mobile: _mobileController.text,
      secondaryMobile: _secondaryMobileController.text,
      email: _emailController.text,
      iban: _ibanController.text,
      selectedBank: _selectedBank,
    );
  }

  Future<void> _submitAndOpenNextStep() async {
    setState(() {
      _didInteractWithPersonalInfo = true;
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
      await _profileSubmissionService.submit(
        UpdateProfileActionType.updateProfile,
        draft.toPersonalInfoData(),
      );
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

    if (!mounted) {
      return;
    }

    setState(() => _isSubmittingProfile = false);
    _openNextStep(draft);
  }

  Future<void> _openNextStep(SecAcntFlowDraft draft) async {
    final SecAcntFlowStep? nextStep = resolveNextSecAcntFlowStep(
      SecAcntFlowStep.personalInformation,
      widget.bootstrapState,
    );

    if (nextStep == SecAcntFlowStep.success && _isShortFlow) {
      await replaceIpsRoute(
        context,
        route: MiniAppRoutes.questionnaire,
        arguments: widget.bootstrapState,
      );
      return;
    }

    final Widget nextScreen = switch (nextStep) {
      SecAcntFlowStep.success => SecAcntSuccessScreen(
        bootstrapState: widget.bootstrapState,
        draft: draft,
      ),
      SecAcntFlowStep.secAgreement => SecAcntAgreementScreen(
        step: SecAcntFlowStep.secAgreement,
        bootstrapState: widget.bootstrapState,
        draft: draft,
        appApi: widget.appApi,
      ),
      _ => SecAcntSuccessScreen(
        bootstrapState: widget.bootstrapState,
        draft: draft,
      ),
    };

    await Navigator.of(
      context,
    ).push(MaterialPageRoute<void>(builder: (_) => nextScreen));
  }

  @override
  Widget build(BuildContext context) {
    final responsive = context.responsive;
    final double footerClearance = responsive.dp(24) + responsive.spacing.buttonHeight + 4 + responsive.safeBottom;
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
      onClose: () => Navigator.of(context, rootNavigator: true).maybePop(),
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
            SecAcntStepIndicator(
              currentStep: SecAcntFlowStep.personalInformation,
              bootstrapState: widget.bootstrapState,
            ),
            SecAcntPersonalInfoStep(
              mobileController: _mobileController,
              secondaryMobileController: _secondaryMobileController,
              emailController: _emailController,
              ibanController: _ibanController,
              selectedBank: _selectedBank,
              onSelectBank: () => _selectBank(context),
              isShortFlow: _isShortFlow,
              autovalidateMode: _autovalidateMode,
              mobileValidator: (String? value) => _validateMobile(context, value),
              secondaryMobileValidator: (String? value) => _validateSecondaryMobile(context, value),
              emailValidator: (String? value) => _validateEmail(context, value),
              ibanValidator: (String? value) => _validateIban(context, value),
              bankErrorText: _bankErrorText(context),
            ),
            if (_hasSubmitError) _SubmitErrorBanner(message: _submitErrorMessage!),
          ],
        ),
      ),
    );
  }

  bool get _hasSubmitError => _submitErrorMessage != null && _submitErrorMessage!.trim().isNotEmpty;

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

class _SubmitErrorBanner extends StatelessWidget {
  final String message;

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
