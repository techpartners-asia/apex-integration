/// Personal/bank information submitted during securities-account onboarding.
class SecAcntPersonalInfoData {
  /// Primary mobile number.
  final String? mobile;

  /// Secondary mobile number.
  final String? secondaryMobile;

  /// Email address.
  final String? email;

  /// IBAN or bank account number.
  final String? iban;

  /// Selected bank code.
  final String? bankCode;

  /// Selected bank display label.
  final String? bankLabel;

  /// Account holder name.
  final String? acntName;

  /// Creates personal and bank information for profile submission.
  const SecAcntPersonalInfoData({
    this.mobile,
    this.secondaryMobile,
    this.email,
    this.iban,
    this.bankCode,
    this.bankLabel,
    this.acntName,
  });
}
