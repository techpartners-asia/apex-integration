import 'package:mini_app_sdk/mini_app_sdk.dart';

enum SecAcntFlowStep {
  consent,
  personalInformation,
  success,
  serviceAgreement,
  secAgreement,
  terms,
  signature,
  payment,
  calculation,
}

bool hasSecAcnt(AcntBootstrapState? state) => state?.hasAcnt ?? false;

bool requiresSecAcntOpeningPayment(AcntBootstrapState? state) =>
    state?.requiresSecAcntPayment ?? false;

bool isShortSecAcntFlow(AcntBootstrapState? state) =>
    hasSecAcnt(state) && !requiresSecAcntOpeningPayment(state);

List<SecAcntFlowStep> resolveSecAcntFlowSteps(AcntBootstrapState? state) {
  if (isShortSecAcntFlow(state)) {
    return const <SecAcntFlowStep>[
      SecAcntFlowStep.consent,
      SecAcntFlowStep.personalInformation,
      SecAcntFlowStep.success,
      SecAcntFlowStep.serviceAgreement,
    ];
  }

  if (requiresSecAcntOpeningPayment(state)) {
    return const <SecAcntFlowStep>[
      SecAcntFlowStep.payment,
      SecAcntFlowStep.calculation,
    ];
  }

  return const <SecAcntFlowStep>[
    SecAcntFlowStep.consent,
    SecAcntFlowStep.personalInformation,
    SecAcntFlowStep.secAgreement,
    SecAcntFlowStep.signature,
    SecAcntFlowStep.payment,
    SecAcntFlowStep.calculation,
  ];
}

SecAcntFlowStep resolveInitialSecAcntFlowStep(AcntBootstrapState? state) =>
    resolveSecAcntFlowSteps(state).first;

SecAcntFlowStep? resolveNextSecAcntFlowStep(
  SecAcntFlowStep currentStep,
  AcntBootstrapState? state,
) {
  final List<SecAcntFlowStep> steps = resolveSecAcntFlowSteps(state);
  final int index = steps.indexOf(currentStep);
  if (index == -1 || index >= steps.length - 1) {
    return null;
  }
  return steps[index + 1];
}

class SecAcntBankOption {
  final String id;
  final String label;
  final String shortLabel;
  final String logoUrl;

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

class SecAcntFlowDraft {
  final String mobile;
  final String secondaryMobile;
  final String email;
  final String iban;
  final String acntName;
  final SecAcntBankOption? selectedBank;

  const SecAcntFlowDraft({
    this.mobile = '',
    this.secondaryMobile = '',
    this.email = '',
    this.iban = '',
    this.acntName = '',
    this.selectedBank,
  });

  factory SecAcntFlowDraft.fromBootstrap(
    AcntBootstrapState? state, {
    UserEntityDto? user,
  }) {
    final String? bankCode = _resolveBootstrapBankCode(state, user: user);
    final String? bankName = _resolveBootstrapBankName(state, user: user);
    final String? iban = _sanitizeIbanDigits(
      _resolveBootstrapIban(state, user: user),
    );
    final String? acntName = _sanitizeIbanDigits(
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

  SecAcntPersonalInfoData toPersonalInfoData() => SecAcntPersonalInfoData(
    mobile: _trimToNull(mobile),
    secondaryMobile: _trimToNull(secondaryMobile),
    email: _trimToNull(email),
    iban: _trimToNull(iban),
    acntName: _trimToNull(acntName),
    bankCode: _trimToNull(selectedBank?.id),
    bankLabel: _trimToNull(selectedBank?.label),
  );

  static const Object _sentinel = Object();
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

  return _trimToNull(user?.bank?.bankId ?? user?.bank?.bankCode);
}

String? _resolveBootstrapAcntName(
  AcntBootstrapState? state, {
  UserEntityDto? user,
}) {
  final String? acntName = _trimToNull(state?.bootstrapAcntName);
  if (acntName != null) {
    return acntName;
  }

  return _trimToNull(user?.bank?.accountName ?? user?.bank?.accountName);
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
