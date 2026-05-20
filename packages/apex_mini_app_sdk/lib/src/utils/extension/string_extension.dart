import 'package:email_validator/email_validator.dart';

/// Null-safe string helpers used throughout form and API mapping code.
extension StringExtensions on String? {
  /// Whether the string is null, blank, or a literal null marker.
  bool get isNullOrEmpty =>
      this == null || this!.trim().isEmpty || this == 'NULL' || this == 'null';

  /// Whether the string contains visible non-null text.
  bool get isNotNullOrEmpty => !isNullOrEmpty;

  /// Whether the string contains an uppercase Latin letter.
  bool get hasUpperCase => this?.contains(RegExp(r'[A-Z]')) ?? false;

  /// Whether the string contains a digit.
  bool get hasDigit => this?.contains(RegExp(r'\d')) ?? false;

  // bool get capitalized => (this?.isEmpty ?? true) ? '' : '${this![0].toUpperCase()}${this!.substring(1).toLowerCase()}';
  /// Whether the string satisfies the minimum password length.
  bool get passLowLength => (this?.length ?? 0) >= 7;

  /// Formats an account number into 4-character groups.
  String formatAccountNo() {
    final str = this ?? '';
    final buffer = StringBuffer();
    for (int i = 0; i < str.length; i += 4) {
      buffer.write(
        ' ${str.substring(i, i + 4 > str.length ? str.length : i + 4)}',
      );
    }

    return buffer.toString().trim();
  }

  /// Whether the string is a valid email address.
  bool get isValidEmail => this != null && EmailValidator.validate(this!);

  /// Whether the string parses as an absolute URL.
  bool get isValidUrl => Uri.tryParse(this ?? '')?.isAbsolute ?? false;
}
