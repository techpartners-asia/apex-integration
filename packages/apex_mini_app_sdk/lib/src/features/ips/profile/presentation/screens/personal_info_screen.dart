import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mini_app_ui/mini_app_ui.dart';

import '../../../../../app/investx_api/backend/mini_app_api_repository.dart';
import '../../../../../app/investx_api/dto/user_entity_dto.dart';
import '../../../../../app/investx_api/req/update_profile_api_req.dart';
import '../../../../../shared/l10n/sdk_localizations_x.dart';
import '../../../sec_acnt/application/sec_acnt_bank_account_lookup_repository.dart';
import '../../../sec_acnt/application/sec_acnt_bank_options_repository.dart';
import '../../../sec_acnt/presentation/flow/sec_acnt_flow.dart';
import '../../../sec_acnt/presentation/widgets/sec_acnt_sheets.dart';
import '../../../shared/presentation/helpers/investx_validators.dart';
import '../../../shared/presentation/helpers/ips_error_formatter.dart';
import '../../../shared/presentation/widgets/widgets.dart';

class PersonalInfoScreen extends StatefulWidget {
  final UserEntityDto? currentUser;
  final MiniAppApiRepository appApi;
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
    final responsive = context.responsive;
    final l10n = context.l10n;

    return InvestXPageScaffold(
      appBarTitle: l10n.ipsOverviewProfileMenuPersonalInfo,
      showCloseButton: false,
      hasSafeArea: false,
      backgroundColor: InvestXDesignTokens.softSurface,
      appBarBackgroundColor: InvestXDesignTokens.softSurface,
      appBarShowBottomBorder: false,
      body: Stack(
        children: <Widget>[
          Column(
            children: <Widget>[
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(
                    horizontal: responsive.dp(20),
                    vertical: responsive.dp(16),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      _buildTextField(
                        label: 'Овог',
                        controller: _lastNameController,
                      ),
                      SizedBox(height: responsive.dp(14)),
                      _buildTextField(
                        label: 'Нэр',
                        controller: _firstNameController,
                      ),
                      SizedBox(height: responsive.dp(14)),
                      _buildTextField(
                        label: 'Цахим шуудан',
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                      ),
                      SizedBox(height: responsive.dp(14)),
                      _buildTextField(
                        label: 'Утасны дугаар',
                        controller: _phoneController,
                        keyboardType: TextInputType.phone,
                      ),
                      SizedBox(height: responsive.spacing.sectionSpacing),
                      _SectionTitle(title: 'Оршин суугаа хаяг'),
                      SizedBox(height: responsive.dp(14)),
                      _DropdownField(
                        label: 'Иргэншил',
                        value: _citizenship,
                      ),
                      SizedBox(height: responsive.dp(14)),
                      _DropdownField(
                        label: 'Оршин суугаа улс',
                        value: _country,
                      ),
                      SizedBox(height: responsive.dp(14)),
                      _buildTextField(
                        label: 'Оршин суугаа хаяг',
                        controller: _addressController,
                      ),
                      SizedBox(height: responsive.spacing.sectionSpacing),
                      _SectionTitle(title: 'Ажил эрхлэлт'),
                      SizedBox(height: responsive.dp(14)),
                      _buildTextField(
                        label: 'Ажиллаж буй салбар',
                        controller: _industryController,
                      ),
                      SizedBox(height: responsive.dp(14)),
                      _buildTextField(
                        label: 'Эрхэлж буй ажил',
                        controller: _positionController,
                      ),
                      SizedBox(height: responsive.spacing.sectionSpacing),
                      _SectionTitle(title: 'Банкны мэдээлэл'),
                      SizedBox(height: responsive.dp(14)),
                      _DropdownField(
                        label: l10n.commonBank,
                        value: _selectedBank?.label ?? 'Хаанбанк',
                        icon: Icons.account_balance,
                        onTap: _isSaving
                            ? null
                            : () => _openBankSelectionSheet(context),
                      ),
                      SizedBox(height: responsive.dp(14)),
                      _buildTextField(
                        label: l10n.commonIban,
                        controller: _ibanController,
                        keyboardType: TextInputType.number,
                      ),
                      SizedBox(height: responsive.dp(14)),
                      _buildTextField(
                        label: 'Данс эзэмшигчийн нэр',
                        controller: _accountHolderController,
                        enabled: false,
                      ),
                      if (_isResolvingAccountHolder)
                        Padding(
                          padding: EdgeInsets.only(top: responsive.dp(8)),
                          child: Row(
                            children: <Widget>[
                              SizedBox(
                                width: responsive.dp(14),
                                height: responsive.dp(14),
                                child: const CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              ),
                              SizedBox(width: responsive.dp(8)),
                              Expanded(
                                child: CustomText(
                                  l10n.commonLoading,
                                  style: Theme.of(context).textTheme.bodySmall
                                      ?.copyWith(
                                        color: InvestXDesignTokens.muted,
                                      ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      if (_lookupErrorMessage != null)
                        Padding(
                          padding: EdgeInsets.only(top: responsive.dp(8)),
                          child: InvestXNoticeBanner(
                            title: context.l10n.errorsGenericTitle,
                            message: _lookupErrorMessage!,
                          ),
                        ),
                    ],
                  ),
                ),
              ),
              InvestXBottomActionBar(
                child: InvestXPrimaryButton(
                  label: l10n.commonSave,
                  onPressed: _isSaving || !_canSave() ? null : _save,
                ),
              ),
            ],
          ),
          if (_isSaving)
            InvestXBlockingLoadingOverlay(
              title: context.l10n.commonLoading,
              message: context.l10n.commonSave,
            ),
        ],
      ),
    );
  }

  Future<void> _save() async {
    if (!_canSave()) {
      if (mounted) {
        MiniAppToast.showError(
          context,
          message:
              _lookupErrorMessage ?? context.l10n.validationSelectionRequired,
        );
      }
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
    final String bankCode = _selectedBank?.id.trim() ?? '';
    final String bankLabel = _selectedBank?.label.trim().isNotEmpty == true
        ? _selectedBank!.label.trim()
        : bankCode;
    final String accountNumber = _ibanController.text.trim();
    final String? accountName = _trimToNull(_resolvedAccountHolderName);

    final bool hasBankPayload = accountNumber.isNotEmpty || bankCode.isNotEmpty;
    final bool canSendBankPayload =
        hasBankPayload &&
        bankCode.isNotEmpty &&
        _isValidAccountNumber(accountNumber) &&
        accountName != null;

    return UpdateProfileApiReq(
      actionType: UpdateProfileActionType.updateInformation,
      lastName: _lastNameController.text,
      firstName: _firstNameController.text,
      email: _emailController.text,
      phone: _phoneController.text,
      residenceAddress: _addressController.text,
      residenceCountry: _country,
      currentDepartment: _industryController.text,
      gender: 'M',
      currentPosition: _positionController.text,
      bank: canSendBankPayload
          ? UpdateProfileBankApiReq(
              accountNumber: accountNumber,
              bankCode: bankCode,
              bankName: bankLabel,
              accountName: accountName,
            )
          : null,
    );
  }

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    TextInputType? keyboardType,
    bool enabled = true,
  }) {
    return InvestXTextField(
      label: label,
      controller: controller,
      keyboardType: keyboardType,
      enabled: enabled,
    );
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
    final String bankCode = _selectedBank?.id.trim() ?? '';
    final String accountNumber = _ibanController.text.trim();
    if (bankCode.isEmpty || !_isValidAccountNumber(accountNumber)) {
      return;
    }

    final String lookupKey = '$bankCode|$accountNumber';
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
      final String lookupKey = '$bankCode|$accountNumber';

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
      InvestXValidators.iban(context.l10n)(value) == null;

  bool _canSave() {
    if (_isResolvingAccountHolder) {
      return false;
    }

    final String bankCode = _selectedBank?.id.trim() ?? '';
    final String accountNumber = _ibanController.text.trim();
    final bool hasBankInput = bankCode.isNotEmpty || accountNumber.isNotEmpty;
    if (!hasBankInput) {
      return true;
    }

    if (bankCode.isEmpty || !_isValidAccountNumber(accountNumber)) {
      return false;
    }

    final String lookupKey = '$bankCode|$accountNumber';
    return _resolvedLookupKey == lookupKey &&
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
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return CustomText(
      title,
      style: Theme.of(context).textTheme.titleSmall?.copyWith(
        fontWeight: MiniAppTypography.bold,
      ),
    );
  }
}

class _DropdownField extends StatelessWidget {
  final String label;
  final String value;
  final VoidCallback? onTap;
  final IconData? icon;

  const _DropdownField({
    required this.label,
    required this.value,
    this.onTap,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final responsive = context.responsive;

    return GestureDetector(
      onTap: onTap,
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: label,
          floatingLabelBehavior: FloatingLabelBehavior.auto,
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(responsive.radiusMd),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(responsive.radiusMd),
            borderSide: BorderSide.none,
          ),
          contentPadding: EdgeInsets.symmetric(
            horizontal: responsive.dp(16),
            vertical: responsive.dp(16),
          ),
          prefixIcon: icon != null
              ? Padding(
                  padding: EdgeInsets.only(left: responsive.dp(12)),
                  child: Icon(
                    icon,
                    size: responsive.dp(20),
                    color: InvestXDesignTokens.teal,
                  ),
                )
              : null,
          prefixIconConstraints: icon != null
              ? BoxConstraints(
                  minWidth: responsive.dp(40),
                  minHeight: responsive.dp(20),
                )
              : null,
        ),
        child: Row(
          children: <Widget>[
            Expanded(
              child: CustomText(
                value,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: MiniAppTypography.semiBold,
                ),
              ),
            ),
            Icon(
              Icons.keyboard_arrow_down_rounded,
              size: responsive.dp(22),
              color: InvestXDesignTokens.muted,
            ),
          ],
        ),
      ),
    );
  }
}
