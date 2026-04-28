import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mini_app_ui/mini_app_ui.dart';
import 'package:mini_app_sdk/mini_app_sdk.dart';

class PersonalInfoScreen extends StatefulWidget {
  final UserEntityDto? currentUser;
  final MiniAppProfileRepository appApi;
  final SecAcntBankOptionsRepository bankOptionsRepository;
  final SecAcntBankAccountLookupRepository bankAccountLookupRepository;

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

class _PersonalInfoScreenState extends State<PersonalInfoScreen> {
  late final TextEditingController _lastNameController;
  late final TextEditingController _firstNameController;
  late final TextEditingController _emailController;
  late final TextEditingController _phoneController;
  late final TextEditingController _addressController;
  late final TextEditingController _industryController;
  late final TextEditingController _positionController;
  late final TextEditingController _ibanController;
  late final TextEditingController _accountHolderController;

  SecAcntBankOption? _selectedBank;
  String _citizenship = 'Монгол';
  String _country = 'Монгол';
  String? _resolvedAccountHolderName;
  String? _lookupErrorMessage;
  bool _isResolvingAccountHolder = false;
  bool _isSaving = false;
  int _lookupToken = 0;
  Timer? _lookupDebounce;
  String? _resolvedLookupKey;

  static const Duration _lookupDebounceDuration = Duration(milliseconds: 450);

  String get _bankCode => _selectedBank?.id.trim() ?? '';

  String get _accountNumber => _ibanController.text.trim();

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
    _addressController = TextEditingController(
      text: user?.residenceAddress ?? '',
    );
    _industryController = TextEditingController(
      text: user?.currentDepartment ?? '',
    );
    _positionController = TextEditingController(
      text: user?.currentPosition ?? '',
    );
    _ibanController = TextEditingController(
      text: user?.bank?.accountNumber ?? '',
    );
    _accountHolderController = TextEditingController(
      text: user?.bank?.accountName ?? '',
    );
    _selectedBank = _resolveInitialBank(user);
    _citizenship = user?.region?.name ?? _citizenship;
    _country = user?.residenceCountry ?? _country;
    _resolvedAccountHolderName = _trimToNull(user?.bank?.accountName);

    _ibanController.addListener(_onAccountInputChanged);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _scheduleLookup();
      }
    });
  }

  @override
  void dispose() {
    _lastNameController.dispose();
    _firstNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _industryController.dispose();
    _positionController.dispose();
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
              onSelectBank: () => _openBankSelectionSheet(context),
            ),
          ),
        ),
        BottomActionBar(
          child: PrimaryButton(
            label: context.l10n.commonSave,
            onPressed: _isSaving || !_canSave() ? null : _save,
          ),
        ),
      ],
    );
  }

  Future<void> _save() async {
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

  UpdateProfileBankApiReq? _buildBankRequest() {
    final String bankCode = _bankCode;
    final String accountNumber = _accountNumber;
    final String? accountName = _trimToNull(_resolvedAccountHolderName);
    final bool hasBankPayload = accountNumber.isNotEmpty || bankCode.isNotEmpty;
    final bool canSendBankPayload =
        hasBankPayload &&
        bankCode.isNotEmpty &&
        _isValidAccountNumber(accountNumber) &&
        accountName != null;

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

  String get _selectedBankLabelOrCode {
    final String bankCode = _bankCode;
    final String bankLabel = _selectedBank?.label.trim() ?? '';
    return bankLabel.isNotEmpty ? bankLabel : bankCode;
  }

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

  Future<void> _openBankSelectionSheet(BuildContext context) async {
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

  void _onAccountInputChanged() {
    if (!mounted) {
      return;
    }
    setState(() => _invalidateLookupState());
    _scheduleLookup();
  }

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
      final SecAcntBankAccountLookupResult result = await widget
          .bankAccountLookupRepository
          .lookupAccountHolder(
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
          _lookupErrorMessage =
              result.responseDesc ?? context.l10n.errorsActionFailed;
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

  bool _isValidAccountNumber(String value) =>
      Validators.iban(context.l10n)(value) == null;

  bool _canSave() {
    if (_isResolvingAccountHolder) {
      return false;
    }

    final String bankCode = _bankCode;
    final String accountNumber = _accountNumber;
    final bool hasBankInput = bankCode.isNotEmpty || accountNumber.isNotEmpty;
    if (!hasBankInput) {
      return true;
    }

    if (bankCode.isEmpty || !_isValidAccountNumber(accountNumber)) {
      return false;
    }

    return _resolvedLookupKey == _currentLookupKey &&
        _trimToNull(_resolvedAccountHolderName) != null;
  }

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

  String? _trimToNull(String? value) {
    final String trimmed = value?.trim() ?? '';
    return trimmed.isEmpty ? null : trimmed;
  }

  String _buildLookupKey({
    required String bankCode,
    required String accountNumber,
  }) => '$bankCode|$accountNumber';

  void _showSaveBlockedToast() {
    if (!mounted) {
      return;
    }
    MiniAppToast.showError(
      context,
      message: _lookupErrorMessage ?? context.l10n.validationSelectionRequired,
    );
  }
}
