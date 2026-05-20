/// Shared fallback values for IPS/securities feature flows.
final class IpsDefaults {
  /// Default currency used in money displays and requests.
  static const String defaultCurrency = 'MNT';

  /// Verification type for broker contract/account-opening requests.
  static const String contractVerificationType = 'IPS_ACNT';

  /// Fallback code when a security instrument is missing its code.
  static const String unknownSecurityCode = 'SECURITY';

  /// Fallback display name when a security instrument is missing its name.
  static const String unknownSecurityName = 'Security';

  /// Fallback contract id shown when backend contract id is unavailable.
  static const String contractIdFallback = 'IPS-CONTRACT';

  /// Fallback QR payload when payment QR data is unavailable.
  static const String qrFallbackValue = 'QR';

  /// Fallback order title when order data is incomplete.
  static const String orderTitleFallback = 'IPS Order';

  /// Backend security code label for bonds.
  static const String secuCodeBond = 'Bond';

  const IpsDefaults._();
}
