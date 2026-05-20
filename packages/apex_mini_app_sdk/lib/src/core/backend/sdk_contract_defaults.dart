import '../constants/ips_defaults.dart';

/// Default contract/bank values used when host config provides them.
class SdkContractDefaults {
  /// Default bank code.
  final String? bankCode;

  /// Default bank account code.
  final String? bankAcntCode;

  /// Default bank account holder name.
  final String? bankAcntName;

  /// Contract verification type.
  final String verificationType;

  /// Creates contract defaults used by securities onboarding/payment flows.
  const SdkContractDefaults({
    this.bankCode,
    this.bankAcntCode,
    this.bankAcntName,
    this.verificationType = IpsDefaults.contractVerificationType,
  });

  /// Whether all required bank defaults are configured.
  bool get isConfigured =>
      (bankCode?.isNotEmpty ?? false) &&
      (bankAcntCode?.isNotEmpty ?? false) &&
      (bankAcntName?.isNotEmpty ?? false);
}
