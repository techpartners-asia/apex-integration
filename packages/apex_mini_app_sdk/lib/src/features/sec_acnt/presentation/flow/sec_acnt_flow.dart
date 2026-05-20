import 'package:apex_mini_app_sdk/apex_mini_app_sdk.dart';

/// Ordered onboarding steps for securities account opening.
enum SecAcntFlowStep {
  /// Consent/intro step.
  consent,

  /// User personal and bank information form.
  personalInformation,

  /// Short-flow success confirmation.
  success,

  /// Existing service agreement step for users with securities accounts.
  serviceAgreement,

  /// Securities account agreement step.
  secAgreement,

  /// Terms step kept for route compatibility.
  terms,

  /// Signature capture step.
  signature,

  /// Contract/payment step.
  payment,

  /// Final calculation/summary step before completion.
  calculation,
}

/// Whether bootstrap confirms an actual securities account exists.
bool hasSecAcnt(AcntBootstrapState? state) => state?.hasAcnt ?? false;

/// Whether account-opening payment is still required for onboarding.
bool requiresSecAcntOpeningPayment(
  AcntBootstrapState? state, {
  UserEntityDto? currentUser,
}) =>
    (state?.requiresSecAcntPayment ?? false) &&
    !hasPaidSecAcntContract(currentUser);

/// Whether the user has a securities account but has not enabled IPS.
bool isShortSecAcntFlow(AcntBootstrapState? state) =>
    state?.hasAcnt == true && state?.hasIpsAcnt == false;

/// Whether the current profile says the contract/payment fee is already paid.
bool hasPaidSecAcntContract(UserEntityDto? user) =>
    user?.account?.hasPaidContract ?? false;

/// Whether the current profile already has a stored signature.
bool hasSavedSecAcntSignature(UserEntityDto? user) =>
    user?.account?.hasSavedSignature ?? false;

/// Whether profile/bootstrap data is enough to skip personal info entry.
bool hasCompleteSecAcntPersonalInfo(
  AcntBootstrapState? state, {
  UserEntityDto? user,
}) => SecAcntFlowDraft.fromBootstrap(state, user: user).hasCompletePersonalInfo;

/// Resolves the required onboarding steps from account and profile state.
List<SecAcntFlowStep> resolveSecAcntFlowSteps(
  AcntBootstrapState? state, {
  UserEntityDto? currentUser,
}) {
  final bool hasCompletePersonalInfo = hasCompleteSecAcntPersonalInfo(
    state,
    user: currentUser,
  );
  final bool hasSignature = hasSavedSecAcntSignature(currentUser);
  final bool hasPaidContract = hasPaidSecAcntContract(currentUser);

  if (isShortSecAcntFlow(state)) {
    return <SecAcntFlowStep>[
      SecAcntFlowStep.consent,
      if (!hasCompletePersonalInfo) SecAcntFlowStep.personalInformation,
      SecAcntFlowStep.success,
      SecAcntFlowStep.serviceAgreement,
    ];
  }

  if (state?.requiresSecAcntPayment ?? false) {
    return <SecAcntFlowStep>[
      if (!hasPaidContract) SecAcntFlowStep.payment,
      SecAcntFlowStep.calculation,
    ];
  }

  return <SecAcntFlowStep>[
    SecAcntFlowStep.consent,
    if (!hasCompletePersonalInfo) SecAcntFlowStep.personalInformation,
    if (!hasSignature) SecAcntFlowStep.secAgreement,
    if (!hasSignature) SecAcntFlowStep.signature,
    if (!hasPaidContract) SecAcntFlowStep.payment,
    SecAcntFlowStep.calculation,
  ];
}

/// Returns the first step the user should see for the current state.
SecAcntFlowStep resolveInitialSecAcntFlowStep(
  AcntBootstrapState? state, {
  UserEntityDto? currentUser,
}) => resolveSecAcntFlowSteps(state, currentUser: currentUser).first;

/// Returns the next step after [currentStep], or null when the flow is done.
SecAcntFlowStep? resolveNextSecAcntFlowStep(
  SecAcntFlowStep currentStep,
  AcntBootstrapState? state, {
  UserEntityDto? currentUser,
}) {
  final List<SecAcntFlowStep> steps = resolveSecAcntFlowSteps(
    state,
    currentUser: currentUser,
  );
  final int index = steps.indexOf(currentStep);
  if (index == -1 || index >= steps.length - 1) {
    return null;
  }
  return steps[index + 1];
}

/// Bank option selected in the securities account personal-info flow.
class SecAcntBankOption {
  /// Bank identifier/code sent to profile/account APIs.
  final String id;

  /// Full display label.
  final String label;

  /// Compact label used in dense selectors.
  final String shortLabel;

  /// Optional bank logo URL.
  final String logoUrl;

  /// Creates a bank option.
  const SecAcntBankOption(this.id, this.label, this.shortLabel, this.logoUrl);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SecAcntBankOption &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;
}

/// Editable draft of data collected during securities account onboarding.
class SecAcntFlowDraft {
  /// Primary mobile phone.
  final String mobile;

  /// Secondary mobile phone.
  final String secondaryMobile;

  /// Email address.
  final String email;

  /// Settlement bank IBAN/account number.
  final String iban;

  /// Settlement account holder name.
  final String acntName;

  /// Selected settlement bank.
  final SecAcntBankOption? selectedBank;

  /// Creates an editable onboarding draft.
  const SecAcntFlowDraft({
    this.mobile = '',
    this.secondaryMobile = '',
    this.email = '',
    this.iban = '',
    this.acntName = '',
    this.selectedBank,
  });

  /// Builds a draft from bootstrap/profile values.
  factory SecAcntFlowDraft.fromBootstrap(
    AcntBootstrapState? state, {
    UserEntityDto? user,
  }) {
    final String? bankCode = _resolveBootstrapBankCode(state, user: user);
    final String? bankName = _resolveBootstrapBankName(state, user: user);
    final String? iban = _sanitizeIbanDigits(
      _resolveBootstrapIban(state, user: user),
    );
    final String? acntName = _trimToNull(
      _resolveBootstrapAcntName(state, user: user),
    );

    return SecAcntFlowDraft(
      mobile: _trimToNull(user?.phone) ?? '',
      secondaryMobile: _trimToNull(user?.phoneAddition) ?? '',
      email: _trimToNull(user?.email) ?? '',
      acntName: acntName ?? '',
      iban: iban ?? '',
      selectedBank: bankCode == null && bankName == null
          ? null
          : SecAcntBankOption(
              bankCode ?? bankName!,
              bankName ?? bankCode!,
              bankName ?? bankCode!,
              '',
            ),
    );
  }

  /// Returns a copy with updated values.
  SecAcntFlowDraft copyWith({
    String? mobile,
    String? secondaryMobile,
    String? email,
    String? iban,
    String? acntName,
    Object? selectedBank = _sentinel,
  }) {
    return SecAcntFlowDraft(
      mobile: mobile ?? this.mobile,
      secondaryMobile: secondaryMobile ?? this.secondaryMobile,
      email: email ?? this.email,
      iban: iban ?? this.iban,
      acntName: acntName ?? this.acntName,
      selectedBank: selectedBank == _sentinel
          ? this.selectedBank
          : selectedBank as SecAcntBankOption?,
    );
  }

  /// Converts this draft into the domain payload used for profile submission.
  SecAcntPersonalInfoData toPersonalInfoData() => SecAcntPersonalInfoData(
    mobile: _trimToNull(mobile),
    secondaryMobile: _trimToNull(secondaryMobile),
    email: _trimToNull(email),
    iban: _trimToNull(iban),
    acntName: _trimToNull(acntName),
    bankCode: _trimToNull(selectedBank?.id),
    bankLabel: _trimToNull(selectedBank?.label),
  );

  /// Whether all required contact, bank, and holder fields are valid.
  bool get hasCompletePersonalInfo {
    return hasCompleteContactInfo &&
        _isValidIban(iban) &&
        _trimToNull(selectedBank?.id) != null &&
        _trimToNull(acntName) != null;
  }

  /// Whether mobile, secondary mobile, and email values are valid.
  bool get hasCompleteContactInfo {
    return _isValidPhone(mobile) &&
        _isValidPhone(secondaryMobile) &&
        _isValidEmail(email);
  }

  static const Object _sentinel = Object();
}

bool _isValidPhone(String? value) {
  final String? normalized = _trimToNull(value);
  return normalized != null && RegExp(r'^\d{8}$').hasMatch(normalized);
}

bool _isValidEmail(String? value) {
  final String? normalized = _trimToNull(value);
  if (normalized == null) {
    return false;
  }
  return RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(normalized);
}

bool _isValidIban(String? value) {
  final String? normalized = _trimToNull(value);
  return normalized != null && RegExp(r'^\d{8,18}$').hasMatch(normalized);
}

String? _resolveBootstrapBankCode(
  AcntBootstrapState? state, {
  UserEntityDto? user,
}) {
  final String? bankCode = _trimToNull(state?.bootstrapBankCode);
  if (bankCode != null) {
    return bankCode;
  }

  return _trimToNull(user?.bank?.bankCode ?? user?.bank?.bankId);
}

String? _resolveBootstrapBankName(
  AcntBootstrapState? state, {
  UserEntityDto? user,
}) {
  final String? bankName = _trimToNull(state?.bootstrapBankName);
  if (bankName != null) {
    return bankName;
  }

  return _trimToNull(
    user?.bank?.bankName ?? user?.bank?.bankId ?? user?.bank?.bankCode,
  );
}

String? _resolveBootstrapAcntName(
  AcntBootstrapState? state, {
  UserEntityDto? user,
}) {
  final String? acntName = _trimToNull(state?.bootstrapAcntName);
  if (acntName != null) {
    return acntName;
  }

  return _trimToNull(user?.bank?.accountName);
}

String? _resolveBootstrapIban(
  AcntBootstrapState? state, {
  UserEntityDto? user,
}) {
  final String? iban = _trimToNull(state?.bootstrapIban);
  if (iban != null) {
    return iban;
  }

  return _trimToNull(user?.bank?.accountNumber);
}

String? _sanitizeIbanDigits(String? value) {
  final String normalized =
      value?.replaceAll(RegExp(r'[^A-Za-z0-9]'), '') ?? '';
  if (normalized.isEmpty) {
    return null;
  }

  final String withoutPrefix = normalized.toUpperCase().startsWith('MN')
      ? normalized.substring(2)
      : normalized;
  final String digitsOnly = withoutPrefix.replaceAll(RegExp(r'\D'), '');
  return digitsOnly.isEmpty ? null : digitsOnly;
}

String? _trimToNull(String? value) {
  final String trimmed = value?.trim() ?? '';
  return trimmed.isEmpty ? null : trimmed;
}
