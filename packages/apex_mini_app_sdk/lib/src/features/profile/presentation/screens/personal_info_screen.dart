import 'dart:async';

import 'package:flutter/material.dart';
import 'package:apex_mini_app_sdk/apex_mini_app_sdk.dart';

/// Full profile editing screen opened from the overview profile tab.
class PersonalInfoScreen extends StatefulWidget {
  /// Current user data used to seed the form.
  final UserEntityDto? currentUser;

  /// Profile repository used to save changes.
  final MiniAppProfileRepository appApi;

  /// Repository used to load selectable banks.
  final SecAcntBankOptionsRepository bankOptionsRepository;

  /// Repository used to resolve bank account holder names.
  final SecAcntBankAccountLookupRepository bankAccountLookupRepository;

  /// Creates the personal info editing screen.
  const PersonalInfoScreen({
    super.key,
    required this.appApi,
    required this.bankOptionsRepository,
    required this.bankAccountLookupRepository,
    this.currentUser,
  });

  @override
  State<PersonalInfoScreen> createState() => _PersonalInfoScreenState();
}

/// Owns profile edit controllers, bank selection, and account-name lookup.
class _PersonalInfoScreenState extends State<PersonalInfoScreen> {
  /// Last name controller.
  late final TextEditingController _lastNameController;

  /// First name controller.
  late final TextEditingController _firstNameController;

  /// Email controller.
  late final TextEditingController _emailController;

  /// Phone controller.
  late final TextEditingController _phoneController;

  /// Residence address controller.
  late final TextEditingController _addressController;

  /// Industry/current department controller.
  late final TextEditingController _industryController;

  /// Current position controller.
  late final TextEditingController _positionController;

  /// Bank account number controller.
  late final TextEditingController _ibanController;

  /// Read-only resolved account holder controller.
  late final TextEditingController _accountHolderController;

  /// Selected settlement bank.
  SecAcntBankOption? _selectedBank;

  /// Current citizenship label.
  String _citizenship = 'Монгол';

  /// Current residence country label.
  String _country = 'Монгол';

  /// Last successfully resolved account holder name.
  String? _resolvedAccountHolderName;

  /// Current account lookup error message.
  String? _lookupErrorMessage;

  /// Whether account holder lookup is running.
  bool _isResolvingAccountHolder = false;

  /// Whether profile save is running.
  bool _isSaving = false;

  /// Whether the user has pressed save at least once; triggers required-field errors.
  bool _hasAttemptedSave = false;

  /// Monotonic token used to ignore stale async lookup results.
  int _lookupToken = 0;

  /// Debounce timer for account holder lookup.
  Timer? _lookupDebounce;

  /// Bank/account key for the last successful lookup.
  String? _resolvedLookupKey;

  /// Whether the IBAN-length warning toast has been shown for the current input.
  bool _hasShownIbanWarning = false;

  /// Delay before running account holder lookup after input changes.
  static const Duration _lookupDebounceDuration = Duration(milliseconds: 450);

  /// Current selected bank code.
  String get _bankCode => _selectedBank?.id.trim() ?? '';

  /// Current bank account number.
  String get _accountNumber => _ibanController.text.trim();

  /// Lookup key for the current bank/account pair.
  String get _currentLookupKey => _buildLookupKey(
    bankCode: _bankCode,
    accountNumber: _accountNumber,
  );

  @override
  void initState() {
    super.initState();
    final UserEntityDto? user = widget.currentUser;
    _lastNameController = TextEditingController(text: user?.lastName ?? '');
    _firstNameController = TextEditingController(text: user?.firstName ?? '');
    _emailController = TextEditingController(text: user?.email ?? '');
    _phoneController = TextEditingController(text: user?.phone ?? '');

    _addressController = TextEditingController(text: user?.residenceAddress ?? '');
    _industryController = TextEditingController(text: user?.currentDepartment ?? '');
    _positionController = TextEditingController(text: user?.currentPosition ?? '');
    _ibanController = TextEditingController(text: user?.bank?.accountNumber ?? '');
    _accountHolderController = TextEditingController(text: user?.bank?.accountName ?? '');
    _selectedBank = _resolveInitialBank(user);
    _citizenship = user?.region?.name ?? _citizenship;
    _country = user?.residenceCountry ?? _country;
    _resolvedAccountHolderName = _trimToNull(user?.bank?.accountName);

    for (final TextEditingController c in <TextEditingController>[
      _lastNameController,
      _firstNameController,
      _emailController,
      _phoneController,
      _industryController,
      _positionController,
    ]) {
      c.addListener(_onRequiredFieldChanged);
    }
    _ibanController.addListener(_onAccountInputChanged);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _scheduleLookup();
      }
    });
  }

  @override
  void dispose() {
    for (final TextEditingController c in <TextEditingController>[
      _lastNameController,
      _firstNameController,
      _emailController,
      _phoneController,
      _industryController,
      _positionController,
    ]) {
      c.removeListener(_onRequiredFieldChanged);
      c.dispose();
    }
    _addressController.dispose();
    _ibanController.dispose();
    _accountHolderController.dispose();
    _lookupDebounce?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return CustomScaffold(
      appBarTitle: l10n.ipsOverviewProfileMenuPersonalInfo,
      showCloseButton: false,
      hasSafeArea: false,
      backgroundColor: DesignTokens.softSurface,
      appBarBackgroundColor: DesignTokens.softSurface,
      appBarShowBottomBorder: false,
      body: Stack(
        children: <Widget>[
          _buildContent(context),
          if (_isSaving)
            BlockingLoadingOverlay(
              title: context.l10n.commonLoading,
              message: context.l10n.commonSave,
            ),
        ],
      ),
    );
  }

  /// Builds the editable form and fixed save action.
  Widget _buildContent(BuildContext context) {
    final responsive = context.responsive;

    return Column(
      children: <Widget>[
        Expanded(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(
              horizontal: responsive.dp(20),
              vertical: responsive.dp(16),
            ),
            child: ProfilePersonalInfoForm(
              lastNameController: _lastNameController,
              firstNameController: _firstNameController,
              emailController: _emailController,
              phoneController: _phoneController,
              addressController: _addressController,
              industryController: _industryController,
              positionController: _positionController,
              ibanController: _ibanController,
              accountHolderController: _accountHolderController,
              selectedBank: _selectedBank,
              citizenship: _citizenship,
              country: _country,
              isSaving: _isSaving,
              isResolvingAccountHolder: _isResolvingAccountHolder,
              lookupErrorMessage: _lookupErrorMessage,
              showRequiredErrors: _hasAttemptedSave,
              onSelectBank: () => _openBankSelectionSheet(context),
            ),
          ),
        ),
        BottomActionBar(
          child: PrimaryButton(
            label: context.l10n.commonSave,
            onPressed: _isSaving ? null : _save,
          ),
        ),
      ],
    );
  }

  /// Saves profile data after validating account lookup requirements.
  Future<void> _save() async {
    if (!_hasAttemptedSave) {
      setState(() => _hasAttemptedSave = true);
    }

    if (!_canSave()) {
      _showSaveBlockedToast();
      return;
    }

    setState(() => _isSaving = true);

    try {
      await widget.appApi.updateProfile(_buildRequest());
      if (!mounted) {
        return;
      }
      MiniAppToast.showSuccess(
        context,
        message: context.l10n.internalProfileUpdateSuccess,
      );
      Navigator.of(context).maybePop();
    } catch (error) {
      if (!mounted) {
        return;
      }
      MiniAppToast.showError(
        context,
        message: formatIpsError(error, context.l10n),
      );
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }

  /// Builds the profile update request from current form values.
  UpdateProfileApiReq _buildRequest() {
    return UpdateProfileApiReq(
      actionType: UpdateProfileActionType.updateInformation,
      lastName: _lastNameController.text,
      firstName: _firstNameController.text,
      email: _emailController.text,
      phone: _phoneController.text,
      residenceAddress: _addressController.text,
      residenceCountry: _country,
      currentDepartment: _industryController.text,
      gender: _trimToNull(widget.currentUser?.gender),
      currentPosition: _positionController.text,
      bank: _buildBankRequest(),
    );
  }

  /// Builds the optional bank payload only when lookup has succeeded.
  UpdateProfileBankApiReq? _buildBankRequest() {
    final String bankCode = _bankCode;
    final String accountNumber = _accountNumber;
    final String? accountName = _trimToNull(_resolvedAccountHolderName);
    final bool hasBankPayload = accountNumber.isNotEmpty || bankCode.isNotEmpty;
    final bool canSendBankPayload = hasBankPayload && bankCode.isNotEmpty && _isValidAccountNumber(accountNumber) && accountName != null;

    if (!canSendBankPayload) {
      return null;
    }

    return UpdateProfileBankApiReq(
      accountNumber: accountNumber,
      bankCode: bankCode,
      bankName: _selectedBankLabelOrCode,
      accountName: accountName,
    );
  }

  /// Selected bank display label, falling back to bank code.
  String get _selectedBankLabelOrCode {
    final String bankCode = _bankCode;
    final String bankLabel = _selectedBank?.label.trim() ?? '';
    return bankLabel.isNotEmpty ? bankLabel : bankCode;
  }

  /// Converts profile bank data into the selector option shape.
  SecAcntBankOption? _resolveInitialBank(UserEntityDto? user) {
    final String bankCode = user?.bank?.bankCode?.trim() ?? '';
    final String bankName = user?.bank?.bankName?.trim() ?? '';
    if (bankCode.isEmpty && bankName.isEmpty) {
      return null;
    }
    final String id = bankCode.isNotEmpty ? bankCode : bankName;
    final String label = bankName.isNotEmpty ? bankName : bankCode;
    return SecAcntBankOption(id, label, label, '');
  }

  /// Opens bank selection and invalidates lookup if the bank changes.
  Future<void> _openBankSelectionSheet(BuildContext context) async {
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

    if (!mounted || selected == null) {
      return;
    }

    if (_selectedBank?.id == selected.id) {
      return;
    }

    setState(() {
      _selectedBank = selected;
      _invalidateLookupState();
    });
    _scheduleLookup();
  }

  /// Triggers rebuild so the save button reflects current required-field state.
  void _onRequiredFieldChanged() {
    if (mounted) setState(() {});
  }

  /// Handles bank account number edits.
  void _onAccountInputChanged() {
    if (!mounted) {
      return;
    }
    setState(() => _invalidateLookupState());
    _scheduleLookup();
  }

  /// Debounces account holder lookup until bank/account inputs are valid.
  void _scheduleLookup() {
    _lookupDebounce?.cancel();
    final String bankCode = _bankCode;
    final String accountNumber = _accountNumber;
    if (bankCode.isEmpty || !_isValidAccountNumber(accountNumber)) {
      return;
    }

    final String lookupKey = _currentLookupKey;
    if (_resolvedLookupKey == lookupKey && _resolvedAccountHolderName != null) {
      return;
    }

    _lookupDebounce = Timer(_lookupDebounceDuration, () {
      _runLookup(
        bankCode: bankCode,
        accountNumber: accountNumber,
      );
    });
  }

  /// Resolves the account holder and ignores results from stale requests.
  Future<void> _runLookup({
    required String bankCode,
    required String accountNumber,
  }) async {
    final int token = ++_lookupToken;
    if (mounted) {
      setState(() {
        _isResolvingAccountHolder = true;
        _lookupErrorMessage = null;
      });
    }

    try {
      final SecAcntBankAccountLookupResult result = await widget.bankAccountLookupRepository.lookupAccountHolder(
        bankCode: bankCode,
        accountNumber: accountNumber,
      );

      if (!mounted || token != _lookupToken) {
        return;
      }

      final String? resolvedName = _trimToNull(result.accountHolderName);
      final String? maskedName = _trimToNull(result.maskedAccountHolderName);
      final String lookupKey = _buildLookupKey(
        bankCode: bankCode,
        accountNumber: accountNumber,
      );

      if (result.isSuccess && resolvedName != null) {
        setState(() {
          _resolvedLookupKey = lookupKey;
          _resolvedAccountHolderName = resolvedName;
          _accountHolderController.text = resolvedName;
          _lookupErrorMessage = null;
        });
      } else {
        setState(() {
          _resolvedLookupKey = null;
          _resolvedAccountHolderName = null;
          _accountHolderController.text = maskedName ?? '';
          _lookupErrorMessage = context.l10n.validationAccountHolderNotFound;
        });
      }
    } catch (error) {
      if (!mounted || token != _lookupToken) {
        return;
      }
      setState(() {
        _resolvedLookupKey = null;
        _resolvedAccountHolderName = null;
        _accountHolderController.clear();
        _lookupErrorMessage = formatIpsError(error, context.l10n);
      });
    } finally {
      if (mounted && token == _lookupToken) {
        setState(() => _isResolvingAccountHolder = false);
      }
    }
  }

  /// Returns whether the account number satisfies the shared IBAN validator.
  bool _isValidAccountNumber(String value) => Validators.iban(context.l10n)(value) == null;

  /// Returns whether the profile can be saved in its current state.
  bool _canSave() {
    if (_isResolvingAccountHolder) {
      return false;
    }

    if (_lastNameController.text.trim().isEmpty ||
        _firstNameController.text.trim().isEmpty ||
        _emailController.text.trim().isEmpty ||
        _phoneController.text.trim().isEmpty ||
        _industryController.text.trim().isEmpty ||
        _positionController.text.trim().isEmpty) {
      return false;
    }

    final String bankCode = _bankCode;
    final String accountNumber = _accountNumber;

    if (bankCode.isEmpty || !_isValidAccountNumber(accountNumber)) {
      return false;
    }

    return _resolvedLookupKey == _currentLookupKey && _trimToNull(_resolvedAccountHolderName) != null;
  }

  /// Clears account holder lookup state when bank/account inputs change.
  void _invalidateLookupState() {
    _lookupToken += 1;
    _lookupDebounce?.cancel();
    _lookupDebounce = null;
    _resolvedLookupKey = null;
    _resolvedAccountHolderName = null;
    _lookupErrorMessage = null;
    _isResolvingAccountHolder = false;
    _accountHolderController.clear();
  }

  /// Trims a string and converts empty text to null.
  String? _trimToNull(String? value) {
    final String trimmed = value?.trim() ?? '';
    return trimmed.isEmpty ? null : trimmed;
  }

  /// Builds a stable key for matching lookup results to current inputs.
  String _buildLookupKey({
    required String bankCode,
    required String accountNumber,
  }) => '$bankCode|$accountNumber';

  /// Explains why save is blocked when the user presses a disabled path.
  void _showSaveBlockedToast() {
    if (!mounted) {
      return;
    }
    if (_accountNumber.length > 12) {
      MiniAppToast.showError(
        context,
        message: context.l10n.validationIbanNotAllowed,
      );
      return;
    }
    MiniAppToast.showError(
      context,
      message: _lookupErrorMessage ?? context.l10n.validationFillRequired,
    );
  }
}
