import '../../features/ips/shared/constants/ips_defaults.dart';

class SdkContractDefaults {
  final String? bankCode;
  final String? bankAcntCode;
  final String? bankAcntName;
  final String verificationType;

  const SdkContractDefaults({
    this.bankCode,
    this.bankAcntCode,
    this.bankAcntName,
    this.verificationType = IpsDefaults.contractVerificationType,
  });

  bool get isConfigured =>
      (bankCode?.isNotEmpty ?? false) &&
      (bankAcntCode?.isNotEmpty ?? false) &&
      (bankAcntName?.isNotEmpty ?? false);
}
